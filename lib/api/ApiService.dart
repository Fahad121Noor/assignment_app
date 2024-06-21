import 'package:dio/dio.dart';
import 'package:retry/retry.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
  }

  Future<Response> get(String endpoint) async {
    try {
      final response = await retry(
            () => _dio.get(endpoint),
        retryIf: (e) => e is DioException,
      );
      print('GET $endpoint - Response: ${response.data}');
      return response;
    } catch (error) {
      print('GET $endpoint - Error: $error');
      rethrow;
    }
  }

  Future<Response> post(String endpoint, dynamic data) async {
    try {
      final response = await retry(
            () => _dio.post(endpoint, data: data),
        retryIf: (e) => e is DioException,
      );
      print('POST $endpoint - Request Data: $data - Response: ${response.data}');
      return response;
    } catch (error) {
      print('POST $endpoint - Request Data: $data - Error: $error');
      rethrow;
    }
  }

  Future<Response> put(String endpoint, dynamic data) async {
    try {
      final response = await retry(
            () => _dio.put(endpoint, data: data),
        retryIf: (e) => e is DioException,
      );
      print('PUT $endpoint - Request Data: $data - Response: ${response.data}');
      return response;
    } catch (error) {
      print('PUT $endpoint - Request Data: $data - Error: $error');
      rethrow;
    }
  }

  Future<Response> delete(String endpoint) async {
    try {
      final response = await retry(
            () => _dio.delete(endpoint),
        retryIf: (e) => e is DioException,
      );
      print('DELETE $endpoint - Response: ${response.data}');
      return response;
    } catch (error) {
      print('DELETE $endpoint - Error: $error');
      rethrow;
    }
  }
}