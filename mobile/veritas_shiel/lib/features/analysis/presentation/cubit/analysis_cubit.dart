import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/analysis_repository.dart';
import 'analysis_state.dart';

class AnalysisCubit extends Cubit<AnalysisState> {
  final AnalysisRepository _analysisRepository;

  AnalysisCubit(this._analysisRepository) : super(AnalysisInitial());

  Future<void> analyzeDocument(int documentId) async {
    emit(AnalysisLoading());
    final result = await _analysisRepository.analyzeDocument(documentId);
    result.fold(
      (failure) => emit(AnalysisError(failure.message)),
      (analysis) => emit(AnalysisLoaded(analysis)),
    );
  }

  Future<void> getAnalysisHistory() async {
    emit(AnalysisLoading());
    final result = await _analysisRepository.getAnalysisHistory();
    result.fold(
      (failure) => emit(AnalysisError(failure.message)),
      (history) => emit(AnalysisHistoryLoaded(history)),
    );
  }
}
