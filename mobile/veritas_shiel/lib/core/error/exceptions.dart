import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class CacheException implements Exception {}

class ErrorHandler {
  static String handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout with server";
      case DioExceptionType.sendTimeout:
        return "Send timeout in association with server";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout in connection with server";
      case DioExceptionType.badResponse:
        return _handleError(error.response?.statusCode, error.response?.data);
      case DioExceptionType.cancel:
        return "Request to server was cancelled";
      case DioExceptionType.connectionError:
        return "No internet connection";
      default:
        return "Unexpected error occurred";
    }
  }

  static String _handleError(int? statusCode, dynamic error) {
    if (error is Map && error.containsKey('detail')) {
      return error['detail'];
    }
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Oops, something went wrong';
    }
  }
}
