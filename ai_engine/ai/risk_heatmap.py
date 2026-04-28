class RiskHeatmap:
    """
    Converts clause-level risk into visual-friendly structure
    """

    def generate(self, clauses_analysis: list[dict]) -> dict:
        scores = [c["final_score"] for c in clauses_analysis]

        if not scores:
            return {"overall_risk": 0, "distribution": {}}

        return {
            "overall_risk": round(sum(scores) / len(scores), 2),
            "distribution": self._distribution(scores),
            "color": self._color(sum(scores) / len(scores))
        }

    def _distribution(self, scores):
        return {
            "low": len([s for s in scores if s <= 3]),
            "medium": len([s for s in scores if 4 <= s <= 6]),
            "high": len([s for s in scores if s >= 7]),
        }

    def _color(self, avg_score):
        if avg_score >= 7:
            return "red"
        elif avg_score >= 4:
            return "orange"
        return "green"