import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/analysis_model.dart';

class AnalysisRepository {
  final DioClient _dioClient;

  AnalysisRepository(this._dioClient);

  Future<Either<Failure, AnalysisModel>> analyzeDocument(int documentId) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.analyze,
        data: {'document_id': documentId},
      );
      return Right(AnalysisModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<AnalysisModel>>> getAnalysisHistory() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.results);
      final List<AnalysisModel> history = (response.data as List)
          .map((item) => AnalysisModel.fromJson(item))
          .toList();
      return Right(history);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
