import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/document_model.dart';

class VaultRepository {
  final DioClient _dioClient;

  VaultRepository(this._dioClient);

  Future<Either<Failure, List<DocumentModel>>> getDocuments() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.documents);
      final List<DocumentModel> docs = (response.data as List)
          .map((doc) => DocumentModel.fromJson(doc))
          .toList();
      return Right(docs);
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, DocumentModel>> uploadDocument(String filePath, String title) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dioClient.post(
        ApiEndpoints.uploadDocument,
        data: formData,
      );
      return Right(DocumentModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
