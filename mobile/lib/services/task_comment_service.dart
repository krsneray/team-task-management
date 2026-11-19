import 'package:dio/dio.dart';
import 'package:team_task_management/models/task_comment_response.dart';
import 'package:team_task_management/services/api_service.dart';

class TaskCommentService {
  final _dio = ApiService.create();

  Future<List<TaskCommentResponse>> getCommentsByTaskId(int taskItemId) async {
    try {
      final response = await _dio.get('/TaskComment/task/$taskItemId');
      final List<dynamic> data = response.data;
      return data.map((json) => TaskCommentResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<TaskCommentResponse> addComment(int taskItemId, String content) async {
    try {
      final response = await _dio.post(
        '/TaskComment',
        data: {'taskItemId': taskItemId, 'content': content},
      );
      return TaskCommentResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    if (e.response?.statusCode == 401)
      return 'Oturum süreniz dolmuş, tekrar giriş yapın';
    return 'Yorum gönderilemedi, tekrar deneyin';
  }
}
