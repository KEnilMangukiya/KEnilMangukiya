import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio dio;

  ApiClient({String? baseUrl}) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? 'https://api.example.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    dio = Dio(options);
    dio.interceptors.addAll([
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        compact: true,
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Attach tokens here if needed
          handler.next(options);
        },
        onError: (e, handler) {
          handler.next(e);
        },
      ),
    ]);
  }
}
