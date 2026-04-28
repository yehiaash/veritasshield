from sklearn.metrics.pairwise import cosine_similarity
from ai_engine.models.embeddings import Embedder

class ClauseClassifier:
    def __init__(self):
        """
        Semantic classifier using embeddings
        """

        # Use shared embedding model (Singleton)
        self.model = Embedder()

        # Label prototypes
        self.labels = [
            "employment contract",
            "non disclosure agreement",
            "rental agreement",
            "loan agreement",
            "software license agreement",
            "contract renewal notice"
        ]

        # Map to your system labels
        self.label_map = {
            "employment contract": "employment_contract",
            "non disclosure agreement": "nda",
            "rental agreement": "rental_agreement",
            "loan agreement": "loan_agreement",
            "software license agreement": "software_license",
            "contract renewal notice": "contract_renewal"
        }

        # Precompute embeddings ONCE
        self.label_embeddings = self.model.encode(self.labels)

    def classify(self, raw_text: str) -> str:
        """
        Classify input text using cosine similarity
        """

        # Encode input text
        text_embedding = self.model.encode([raw_text])

        # Compute similarity
        similarities = cosine_similarity(text_embedding, self.label_embeddings)[0]

        # Get best match
        best_index = similarities.argmax()

        best_label = self.labels[best_index]

        return self.label_map[best_label]