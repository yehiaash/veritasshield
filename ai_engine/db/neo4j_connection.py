from neo4j import GraphDatabase
from dotenv import load_dotenv, dotenv_values
from typing import Optional
import os

# Wrapper around the driver.
# All raw Cypher lives here - nothing above this layer touches Cypher directly.

# Singelton class
class Neo4jConnection:
    """
    Manages the Neo4j driver lifecycle and exposes
    low-level node/edge operations as clean Python methods.
    """
    _instance = None

    def __new__(cls, *args, **kwargs):
        if cls._instance is None:
            cls._instance = super(Neo4jConnection, cls).__new__(cls)
            cls._initialized = False
        return cls._instance

    def __init__(self):
        # Ensure __init__ logic only runs once
        if self._initialized:
            return
        
        load_dotenv()
        
        uri = os.getenv('NEO4J_URI')
        user = os.getenv('NEO4J_USERNAME')
        password = os.getenv('NEO4J_PASSWORD')

        self._driver = GraphDatabase.driver(uri, auth=(user, password))
        self._initialized = True

    def close(self):
        self._driver.close()

    def verify(self):
        self._driver.verify_connectivity()
        print('Connected to Neo4j ✓')

    # ── Schema ──────────────────────────────────────────────────────────────

    def create_constraints(self):
        """
        Uniqueness constraints on IDs.
        Run once — safe to re-run (idempotent).
        """
        with self._driver.session() as s:
            s.run('CREATE CONSTRAINT doc_id IF NOT EXISTS FOR (d:Document) REQUIRE d.id IS UNIQUE')
            s.run('CREATE CONSTRAINT clause_id IF NOT EXISTS FOR (c:Clause) REQUIRE c.id IS UNIQUE')
        print('Constraints created ✓')

    def clear_all(self):
        """Wipe entire graph. Use only in development/testing."""
        with self._driver.session() as s:
            s.run('MATCH (n) DETACH DELETE n')
        print('Graph cleared.')

    # ── Document nodes ───────────────────────────────────────────────────────

    def create_document(self, doc_id: int, title: str, doc_type: str,
                        file_extension: str, signed_at: Optional[str] = None) -> None:
        with self._driver.session() as s:
            s.run(
                '''
                MERGE (d:Document {id: $id})
                SET d.title         = $title,
                    d.doc_type      = $doc_type,
                    d.file_extension= $file_extension,
                    d.signed_at     = $signed_at
                ''',
                id=doc_id, title=title, doc_type=doc_type,
                file_extension=file_extension, signed_at=signed_at
            )

    def get_document(self, doc_id: int) -> Optional[dict]:
        with self._driver.session() as s:
            result = s.run('MATCH (d:Document {id: $id}) RETURN d', id=doc_id)
            record = result.single()
            return dict(record['d']) if record else None

    # ── Clause nodes ─────────────────────────────────────────────────────────

    def create_clause(self, clause_id: int, doc_id: int, text: str,
                      clause_type: str, embedding: list[float]) -> None:
        with self._driver.session() as s:
            s.run(
                '''
                MERGE (c:Clause {id: $id})
                SET c.text        = $text,
                    c.clause_type = $clause_type,
                    c.embedding   = $embedding
                WITH c
                MATCH (d:Document {id: $doc_id})
                MERGE (d)-[:HAS]->(c)
                ''',
                id=clause_id, text=text, clause_type=clause_type,
                embedding=embedding, doc_id=doc_id
            )

    def get_all_clauses(self, exclude_doc_id: Optional[int] = None) -> list[dict]:
        """
        Fetch all clauses from the graph, optionally excluding one document.
        Used for similarity comparison against existing DB.
        """
        with self._driver.session() as s:
            if exclude_doc_id:
                result = s.run(
                    '''
                    MATCH (d:Document)-[:HAS]->(c:Clause)
                    WHERE d.id <> $exclude_doc_id
                    RETURN c.id AS id, c.text AS text,
                           c.clause_type AS clause_type,
                           c.embedding AS embedding,
                           d.id AS doc_id, d.title AS doc_title
                    ''',
                    exclude_doc_id=exclude_doc_id
                )
            else:
                result = s.run(
                    '''
                    MATCH (d:Document)-[:HAS]->(c:Clause)
                    RETURN c.id AS id, c.text AS text,
                           c.clause_type AS clause_type,
                           c.embedding AS embedding,
                           d.id AS doc_id, d.title AS doc_title
                    '''
                )
            return [dict(r) for r in result]

    # ── Edges ────────────────────────────────────────────────────────────────

    def create_similar_to(self, clause_id_a: int, clause_id_b: int, score: float) -> None:
        with self._driver.session() as s:
            s.run(
                '''
                MATCH (a:Clause {id: $id_a}), (b:Clause {id: $id_b})
                MERGE (a)-[r:SIMILAR_TO]->(b)
                SET r.score = $score
                ''',
                id_a=clause_id_a, id_b=clause_id_b, score=round(score, 4)
            )

    def create_contradicts(self, clause_id_a: int, clause_id_b: int, reason: str, score: int = 0) -> None:
        with self._driver.session() as s:
            s.run(
                '''
                MATCH (a:Clause {id: $id_a}), (b:Clause {id: $id_b})
                MERGE (a)-[r:CONTRADICTS]->(b)
                SET r.reason = $reason
                SET r.score = $score
                ''',
                id_a=clause_id_a, id_b=clause_id_b, reason=reason, score=score
            )

    def get_conflicts_for_document(self, doc_id: int) -> list[dict]:
        """Return all CONTRADICTS edges involving clauses of a document."""
        with self._driver.session() as s:
            result = s.run(
                '''
                MATCH (d:Document {id: $doc_id})-[:HAS]->(c:Clause)
                      -[r:CONTRADICTS]->(other:Clause)<-[:HAS]-(other_doc:Document)
                RETURN c.id AS clause_id, c.text AS clause_text,
                       other.id AS conflict_id, other.text AS conflict_text,
                       r.reason AS reason,
                       other_doc.title AS from_document
                ''',
                doc_id=doc_id
            )
            return [dict(r) for r in result]
        

