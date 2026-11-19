import 'package:dio/dio.dart';
import 'package:team_task_management/models/task_response.dart';
import 'package:team_task_management/services/api_service.dart';

class TaskService {
  final _dio = ApiService.create();

  Future<List<TaskResponse>> getAllTasks() async {
    try {
      // '/Task' yerine '/api/Task' yazıyoruz
      final response = await _dio.get("/api/Task");

      if (response.data is List) {
        final List<dynamic> data = response.data;
        return data.map((json) => TaskResponse.fromJson(json)).toList();
      } else {
        throw Exception("Sunucudan beklenen liste formatında veri gelmedi.");
      }
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<TaskResponse> getTaskById(int id) async {
    try {
      final response = await _dio.get("/Task/$id");
      return TaskResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<TaskResponse> updateTask(TaskResponse task) async {
    try {
      final response = await _dio.put(
        '/Task/${task.id}',
        data: {
          'id': task.id,
          'projectId': task.projectId,
          'title': task.title,
          'description': task.description,
          'assignedUserId': task.assignedUserId,
          'priority': task.priority,
          'status': task.status,
          'startDate': task.startDate?.toIso8601String(),
          'dueDate': task.dueDate.toIso8601String(),
          'completedDate': task.completedDate?.toIso8601String(),
          'createdByUserId': task.createdByUserId,
          'createdDate': task.createdDate.toIso8601String(),
          'updatedDate': task.updatedDate?.toIso8601String(),
        },
      );
      return TaskResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    if (e.response?.statusCode == 401)
      return 'Oturum süreniz dolmuş, tekrar giriş yapın';
    if (e.response?.statusCode == 404) return 'Görev bulunamadı';
    if (e.response?.statusCode == 403) return 'Bu işlem için yetkiniz yok';
    return 'Bağlantı hatası, lütfen tekrar deneyin';
  }
}
