class ProsecutorAgent:
    """
    Aggressive agent that flags potential risks
    """

    def evaluate(self, liability_result: dict) -> dict:
        base_score = liability_result["risk_score"]

        return {
            "boosted_score": min(10, base_score + 2),
            "reason": f"Matched risky pattern: {liability_result['matched_pattern']}"
        }


class ReviewerAgent:
    """
    Conservative agent that reduces false positives
    """

    def review(self, clause: str, prosecutor_output: dict) -> dict:
        score = prosecutor_output["boosted_score"]

        # Heuristic: short clauses less reliable
        if len(clause.split()) < 6:
            score -= 2

        final_score = max(1, min(10, score))

        return {
            "final_score": final_score,
            "decision": self._label(final_score)
        }

    def _label(self, score: int) -> str:
        if score >= 7:
            return "high_risk"
        elif score >= 4:
            return "medium_risk"
        else:
            return "low_risk"


class MultiAgentSystem:
    def __init__(self):
        self.prosecutor = ProsecutorAgent()
        self.reviewer = ReviewerAgent()

    def run(self, clause: str, liability_result: dict) -> dict:
        p = self.prosecutor.evaluate(liability_result)
        r = self.reviewer.review(clause, p)

        return {
            "initial_score": liability_result["risk_score"],
            "prosecutor_score": p["boosted_score"],
            "final_score": r["final_score"],
            "risk_label": r["decision"]
        }