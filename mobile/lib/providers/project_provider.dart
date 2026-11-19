import 'package:flutter/material.dart';
import 'package:team_task_management/models/project_response.dart';
import 'package:team_task_management/services/project_service.dart';

class ProjectProvider extends ChangeNotifier {
  final _projectService = ProjectService();

  List<ProjectResponse> _projects = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProjectResponse> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String projectNameById(int id) {
    final match = _projects.where((p) => p.id == id);
    return match.isEmpty ? 'Bilinmeyen Proje' : match.first.name;
  }

  Future<void> fetchProjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _projects = await _projectService.getAllProjects();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
