from sklearn.metrics.pairwise import cosine_similarity
from ai_engine.models.embeddings import Embedder
from ai_engine.ai.liability_patterns import RISKY_PATTERNS


class LiabilityDetector:
    def __init__(self):
        self.model = Embedder()
        self.pattern_embeddings = self.model.encode(RISKY_PATTERNS)

    def analyze_clause(self, clause: str) -> dict:
        clause_embedding = self.model.encode([clause])

        similarities = cosine_similarity(clause_embedding, self.pattern_embeddings)[0]

        max_idx = similarities.argmax()
        max_score = float(similarities[max_idx])

        return {
            "clause": clause,
            "similarity": round(max_score, 3),
            "risk_score": self._normalize(max_score),
            "matched_pattern": RISKY_PATTERNS[max_idx]
        }

    def _normalize(self, sim: float) -> int:
        score = int(sim * 10)
        return max(1, min(10, score))