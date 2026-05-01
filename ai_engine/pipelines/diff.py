from typing import List, Tuple
from ai_engine.dataclasses import DocumentInput, Clause, Conflict
from ai_engine.pipelines.clause_extractor import ClauseExtractor
from ai_engine.utils.similarity_engine import SimilarityEngine
from ai_engine.utils.conflict_detector import ConflictDetector
from ai_engine.db.neo4j_connection import Neo4jConnection
from ai_engine.settings import SIMILAR_TO_THRESHOLD

def diff(
    newDocVersion: DocumentInput,
    extractor: ClauseExtractor,
    similarity_engine: SimilarityEngine,
    conflict_detector: ConflictDetector,
    db: Neo4jConnection
) -> List[Tuple[Clause, Clause, str]]:
    """
    Compares a new version of a document against its existing version in the database.
    Returns a list of tuples containing the new clause, the corresponding old clause, 
    and the conflict/change reason.

    Pipeline:
    1- Extract and embed the new version into temporary clause objects
    2- Fetch old version clauses
    3- Find same clauses
    4- Detect conflicts

    """

    # 1. Prepare New Version
    new_texts = extractor.extract(newDocVersion.raw_text)
    new_embeddings = similarity_engine.embed(new_texts)
    
    new_clauses_data = [
        {'id': i, 'text': text, 'embedding': emb.tolist()} 
        for i, (text, emb) in enumerate(zip(new_texts, new_embeddings))
    ]

    # 2. Fetch Old Version from DB
    with db._driver.session() as s:
        result = s.run(
            '''
            MATCH (d:Document {id: $doc_id})-[:HAS]->(c:Clause)
            RETURN c.id AS id, c.text AS text, c.clause_type AS type, d.title AS title
            ''',
            doc_id=newDocVersion.document_id
        )
        # Store as a dict keyed by ID for efficient lookup later
        old_version_map = {r['id']: r for r in result}

    if not old_version_map:
        return []

    # 3. Match identical/similar clauses between versions
    matches = similarity_engine.find_similar(
        new_clauses_data, 
        list(old_version_map.values()), 
        threshold=max(0.85, SIMILAR_TO_THRESHOLD+0.1) # Higher threshold to get exact matches 
    )

    # 4. Generate Diff result
    diff_results = []
    conflicts = conflict_detector.detect(matches)

    for change in conflicts:
        old_data = old_version_map.get(change.existing_clause_id)
        
        if not old_data:
            continue

        # Create structured New Clause
        new_clause = Clause(
            clause_id   = -1, # No ID
            clause_text = change.new_clause_text,
            clause_type = old_data['type']
        )

        # Create structured Old Clause
        old_clause = Clause(
            clause_id   = old_data['id'],
            clause_text = old_data['text'],
            clause_type = old_data['type']
        )

        diff_results.append((new_clause, old_clause, change.reason))

    return diff_results