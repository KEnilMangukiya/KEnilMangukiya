import 'package:dio/dio.dart';

class Failure implements Exception {
  final String message;
  final int? code;
  Failure(this.message, {this.code});
  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

Failure mapDioError(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure('Connection timeout', code: 408);
      case DioExceptionType.badResponse:
        return Failure('Server error', code: error.response?.statusCode);
      case DioExceptionType.cancel:
        return Failure('Request cancelled');
      default:
        return Failure('Network error');
    }
  }
  return Failure('Unexpected error');
}
