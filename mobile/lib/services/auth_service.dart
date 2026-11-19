import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:team_task_management/models/auth_response.dart';
import 'package:team_task_management/services/api_service.dart';

class AuthService {
  final _dio = ApiService.create();
  final _storage = const FlutterSecureStorage();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        "/api/Auth/login",
        data: {'email': email, 'password': password},
      );

      final authResponse = AuthResponse.fromJson(response.data);
      await _storage.write(key: 'jwt_token', value: authResponse.token);
      return authResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("E-posta veya şifre hatalı");
      }
      throw Exception("Bağlantı hatası, lütfen tekrar deneyin");
    }
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}
