import 'package:dio/dio.dart';
import 'package:team_task_management/models/project_response.dart';
import 'package:team_task_management/services/api_service.dart';

class ProjectService {
  final _dio = ApiService.create();

  Future<List<ProjectResponse>> getAllProjects() async {
    try {
      final response = await _dio.get('/Project');
      final List<dynamic> data = response.data;
      return data.map((json) => ProjectResponse.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  Future<ProjectResponse> getProjectById(int id) async {
    try {
      final response = await _dio.get('/Project/$id');
      return ProjectResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_mapError(e));
    }
  }

  String _mapError(DioException e) {
    if (e.response?.statusCode == 401)
      return 'Oturum süreniz dolmuş, tekrar giriş yapın';
    if (e.response?.statusCode == 404) return 'Proje bulunamadı';
    return 'Bağlantı hatası, lütfen tekrar deneyin';
  }
}
