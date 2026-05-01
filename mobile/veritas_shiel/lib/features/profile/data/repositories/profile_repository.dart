import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

class ProfileRepository {
  final DioClient _dioClient;

  ProfileRepository(this._dioClient);

  Future<Either<Failure, UserModel>> getProfile() async {
    try {
      final response = await _dioClient.get(ApiEndpoints.profile);
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _dioClient.patch(
        ApiEndpoints.profile,
        data: data,
      );
      return Right(UserModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(ErrorHandler.handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
