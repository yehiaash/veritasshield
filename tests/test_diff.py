import pytest
import numpy as np
from unittest.mock import MagicMock, patch
from ai_engine.dataclasses import DocumentInput, Clause, SimilarityMatch, Conflict
from ai_engine.pipelines.diff import diff

@pytest.fixture
def mock_context():
    """Setup mocks for all dependencies."""
    return {
        'extractor': MagicMock(),
        'similarity_engine': MagicMock(),
        'conflict_detector': MagicMock(),
        'db': MagicMock()
    }

def test_diff_happy_path_with_actual_change(mock_context):
    """Test that a detected change returns the correct Clause objects and reason."""
    # 1. Input Setup
    doc_input = DocumentInput(document_id=55, raw_text="New text", title="V2", file_extension="pdf")
    
    # 2. Mock Extractor & Similarity (New Version)
    mock_context['extractor'].extract.return_value = ["Payment in 60 days"]
    mock_context['similarity_engine'].embed.return_value = np.array([[0.5, 0.5]])
    
    # 3. Mock Database (Old Version)
    mock_session = mock_context['db']._driver.session.return_value.__enter__.return_value
    mock_session.run.return_value = [
        {'id': 10, 'text': "Payment in 30 days", 'type': "Financial", 'title': "V1"}
    ]

    # 4. Mock Similarity Engine Match
    match = SimilarityMatch(
        new_clause_id=0, new_clause_text="Payment in 60 days",
        existing_clause_id=10, existing_clause_text="Payment in 30 days",
        existing_doc_title="V1", score=0.95
    )
    mock_context['similarity_engine'].find_similar.return_value = [match]

    # 5. Mock Conflict Detector
    change = Conflict(**match.__dict__, reason="Number mismatch: 60 vs 30")
    mock_context['conflict_detector'].detect.return_value = [change]

    # Run
    results = diff(doc_input, **mock_context)

    # Assertions
    assert len(results) == 1
    new_c, old_c, reason = results[0]
    
    assert new_c.clause_id == -1
    assert new_c.clause_text == "Payment in 60 days"
    assert new_c.clause_type == "Financial" # Inherited from old clause
    assert old_c.clause_id == 10
    assert reason == "Number mismatch: 60 vs 30"

def test_diff_no_similar_clauses_found(mock_context):
    """Test that if text changes so much there is no semantic match, diff is empty."""
    doc_input = DocumentInput(document_id=55, raw_text="Something totally different", title="V2", file_extension="pdf")
    
    mock_context['extractor'].extract.return_value = ["Apples and Oranges"]
    mock_context['similarity_engine'].embed.return_value = np.array([[0.1, 0.9]])
    
    # DB has old clauses
    mock_session = mock_context['db']._driver.session.return_value.__enter__.return_value
    mock_session.run.return_value = [{'id': 10, 'text': "Payment terms", 'type': "Financial"}]

    # Similarity engine finds nothing above threshold
    mock_context['similarity_engine'].find_similar.return_value = []

    results = diff(doc_input, **mock_context)

    assert results == []

def test_diff_document_not_in_database(mock_context):
    """Test behavior when the document_id provided does not exist in Neo4j."""
    doc_input = DocumentInput(document_id=404, raw_text="New text", title="V2", file_extension="pdf")
    
    # Database returns empty list
    mock_session = mock_context['db']._driver.session.return_value.__enter__.return_value
    mock_session.run.return_value = []

    results = diff(doc_input, **mock_context)

    assert results == []
    # Verify we didn't call the heavy conflict detector if the doc wasn't found
    mock_context['conflict_detector'].detect.assert_not_called()

def test_diff_multiple_clauses_some_changed_some_not(mock_context):
    """Test a document with two clauses where only one changed."""
    doc_input = DocumentInput(document_id=1, raw_text="Clause A. Clause B.", title="V2", file_extension="pdf")
    
    mock_context['extractor'].extract.return_value = ["Clause A", "Clause B changed"]
    mock_context['similarity_engine'].embed.return_value = np.array([[0.1, 0.1], [0.2, 0.2]])
    
    mock_session = mock_context['db']._driver.session.return_value.__enter__.return_value
    mock_session.run.return_value = [
        {'id': 101, 'text': "Clause A", 'type': "T1"},
        {'id': 102, 'text': "Clause B", 'type': "T2"}
    ]

    # Two matches found
    m1 = SimilarityMatch(0, "Clause A", 101, "Clause A", "V1", 1.0)
    m2 = SimilarityMatch(1, "Clause B changed", 102, "Clause B", "V1", 0.9)
    mock_context['similarity_engine'].find_similar.return_value = [m1, m2]

    # Conflict detector only flags the second one
    c2 = Conflict(**m2.__dict__, reason="Text mismatch")
    mock_context['conflict_detector'].detect.return_value = [c2]

    results = diff(doc_input, **mock_context)

    # Should only return 1 result (the change), not both matches
    assert len(results) == 1
    assert results[0][1].clause_id == 102
    assert results[0][2] == "Text mismatch"