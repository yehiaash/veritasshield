import '../../data/models/analysis_model.dart';

abstract class AnalysisState {}

class AnalysisInitial extends AnalysisState {}

class AnalysisLoading extends AnalysisState {}

class AnalysisLoaded extends AnalysisState {
  final AnalysisModel analysis;
  AnalysisLoaded(this.analysis);
}

class AnalysisHistoryLoaded extends AnalysisState {
  final List<AnalysisModel> history;
  AnalysisHistoryLoaded(this.history);
}

class AnalysisError extends AnalysisState {
  final String message;
  AnalysisError(this.message);
}
