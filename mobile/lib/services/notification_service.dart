import 'package:dio/dio.dart';
import 'package:team_task_management/models/notification_response.dart';
import 'package:team_task_management/services/api_service.dart';

class NotificationService {
  final _dio = ApiService.create();

  Future<List<NotificationResponse>> getAllNotifications() async {
    try {
      final response = await _dio.get('/Notification');
      final List<dynamic> data = response.data;
      return data.map((json) => NotificationResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.put('/Notification/$id/read');
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    if (e.response?.statusCode == 401)
      return 'Oturum süreniz dolmuş, tekrar giriş yapın';
    return 'Bağlantı hatası, lütfen tekrar deneyin';
  }
}
