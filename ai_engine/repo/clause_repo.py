from typing import List, Dict, Optional, Any
from ai_engine.db.neo4j_connection import Neo4jConnection
from ai_engine.dataclasses import Clause, Conflict, SimilarityMatch

class ClauseRepository:
    """
    Repository pattern for handling Clause data operations.
    """

    def __init__(self):
        pass

    def get_clauses_from_document(self, doc_id: int) -> List[Dict[str, Any]]:
        """
        Retrieve all clauses associated with a specific document.

        Args:
            doc_id (int): The ID of the document.

        Returns:
            List[Dict]: A list of clause dictionaries.
                        Example: [{'clause_id': 1, 'text': '...', 'type': '...'}, ...]
        """
        
        db = Neo4jConnection()

        with db._driver.session() as s:
            result = s.run(
                '''
                MATCH (d:Document {id: $doc_id})-[:HAS]->(c:Clause)
                RETURN c.id          AS id,
                    c.text        AS text,
                    c.clause_type AS clause_type
                ORDER BY c.id
                ''',
                doc_id=doc_id
            )
            return [dict(r) for r in result]

    def get_clause_details(self, clause_id: int) -> Optional[Dict[str, Any]]:
        """
        Retrieve detailed information for a single clause, including
        nested conflicts and similar clauses if available.

        Args:
            clause_id (int): The ID of the clause.

        Returns:
            Dict | None: The clause details dictionary or None if not found.
                         Example: {
                             'clause_id': 1,
                             'text': '...',
                             'type': '...',
                             'conflicts': [...],
                             'similar_clauses': [...]
                         }
        """
        db = Neo4jConnection()

        clause_details: Clause = None
        conflicts = []
        similar = []

        with db._driver.session() as s:
            clause_result = s.run(
                '''
                MATCH (c:Clause {id: $clause_id})
                RETURN  c.id          AS id,
                        c.text        AS text,
                        c.clause_type AS clause_type
                ''',
                clause_id=clause_id
            )
            record = clause_result.single()
            
            # Clause not found in db
            if not record:
                return None
    
            clause_details = Clause(record['id'], record['text'], record['clause_type'])
    
            conflicts_result = s.run(
                '''
                MATCH (c:Clause {id: $clause_id})-[r:CONTRADICTS]->(other:Clause)
                    <-[:HAS]-(other_doc:Document)
                RETURN  other.id          AS clause_id,
                        other.text        AS text,
                        other.clause_type AS clause_type,
                        r.reason          AS reason,
                        other_doc.id      AS doc_id,
                        other_doc.title   AS doc_title,
                        r.score           AS score
                ''',
                clause_id=clause_id
            )

            conflicts = [
                Conflict(
                    new_clause_id=clause_details.clause_id,
                    new_clause_text=clause_details.clause_text,
                    existing_clause_id=r['clause_id'],
                    existing_clause_text=r['text'],
                    existing_doc_title=r['doc_title'],
                    score=r['score'],
                    reason=r['reason']
                ) for r in conflicts_result
            ]
    
            similar_result = s.run(
                '''
                MATCH (c:Clause {id: $clause_id})-[r:SIMILAR_TO]->(other:Clause)
                    <-[:HAS]-(other_doc:Document)
                RETURN other.id          AS clause_id,
                    other.text        AS text,
                    other.clause_type AS clause_type,
                    r.score           AS score,
                    other_doc.id      AS doc_id,
                    other_doc.title   AS doc_title
                ORDER BY r.score DESC
                ''',
                clause_id=clause_id
            )
            similar = [
                SimilarityMatch(
                    new_clause_id=clause_details.clause_id,
                    new_clause_text=clause_details.clause_text,
                    existing_clause_id=r['clause_id'],
                    existing_clause_text=r['text'],
                    existing_doc_title=r['doc_title'],
                    score=r['score']
                ) for r in similar_result
            ]

        response = {
            'Clause'        : clause_details,
            'Conflicts'     : conflicts,
            'Similarities'  : similar 
        }

        return response
        

clause_repo = ClauseRepository() # I will import this instance in the service layer in backend to use its methods.