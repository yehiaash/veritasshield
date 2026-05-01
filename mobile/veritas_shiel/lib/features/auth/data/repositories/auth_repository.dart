import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/token_response.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository(this._dioClient);

  Future<Either<Failure, TokenResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );
      return Right(TokenResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TokenResponse>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );
      return Right(TokenResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
