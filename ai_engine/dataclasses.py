from dataclasses import dataclass
from typing import Optional

@dataclass
class SimilarityMatch:
    """
    Represents a high-confidence semantic match between a newly analyzed 
    clause and an existing clause in the knowledge graph.

    Attributes:
        new_clause_id (int): Unique identifier for the clause currently being processed.
        new_clause_text (str): The raw text content of the new clause.
        existing_clause_id (int): Unique identifier of the matching clause found in Neo4j.
        existing_clause_text (str): The raw text content of the existing clause.
        existing_doc_title (str): The title of the source document containing the match.
        score (float): The cosine similarity score (typically 0.0 to 1.0).
    """
    new_clause_id:    int
    new_clause_text:  str
    existing_clause_id:   int
    existing_clause_text: str
    existing_doc_title:   str
    score:            float


@dataclass
class Conflict(SimilarityMatch):
    """
    Represents a detected logical contradiction or legal inconsistency between 
    a new clause and an existing clause in the database.

    Attributes:
        new_clause_id (int): Unique identifier for the incoming clause.
        new_clause_text (str): The raw text content of the incoming clause.
        existing_clause_id (int): Unique identifier of the conflicting clause.
        existing_clause_text (str): The raw text content of the conflicting clause.
        existing_doc_title (str): The title of the document where the conflict was found.
        score (float): The semantic similarity that triggered the conflict check.
        reason (str): A human-readable explanation or LLM-generated rationale for the conflict.
    """
    reason:               str   # human-readable explanation



# Input and output shapes matching the agreed API contract.

@dataclass
class DocumentInput:
    document_id:    int
    raw_text:       str
    title:          str
    file_extension: str
    language:       str = 'en'
    signed_at:      Optional[str] = None   # ISO date string '2024-01-01' or None


@dataclass
class AnalysisResult:
    document_id:    int
    doc_type:       str                 # from classifier
    clauses:        list[dict]          # [{id, text, clause_type}]
    similar_pairs:  list[SimilarityMatch]
    conflicts:      list[Conflict]

    def summary(self):
        print(f"\n{'═'*55}")
        print(f"  Document : {self.document_id}")
        print(f"  Type     : {self.doc_type}")
        print(f"  Clauses  : {len(self.clauses)}")
        print(f"  Similar  : {len(self.similar_pairs)} pairs")
        print(f"  Conflicts: {len(self.conflicts)}")
        print(f"{'═'*55}")
        if self.conflicts:
            print('\n  ⚠  CONFLICTS DETECTED:')
            for c in self.conflicts:
                print(f"\n  New    : {c.new_clause_text[:80]}...")
                print(f"  Exists : {c.existing_clause_text[:80]}...")
                print(f"  From   : '{c.existing_doc_title}'")
                print(f"  Reason : {c.reason}")
        else:
            print('\n  ✓ No conflicts detected.')

@dataclass
class Clause:
    clause_id: int
    clause_text: str
    clause_type: str