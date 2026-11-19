import 'package:flutter/material.dart';
import 'package:team_task_management/models/task_response.dart';
import 'package:team_task_management/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final _taskService = TaskService();

  List<TaskResponse> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<TaskResponse> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<TaskResponse> tasksForUser(String userId) {
    return _tasks.where((element) => element.assignedUserId == userId).toList();
  }

  int openTaskCount(String userId) {
    return tasksForUser(
      userId,
    ).where((element) => element.status != 3 && element.status != 4).length;
  }

  int overdueTaskCount(String userId) {
    final now = DateTime.now();
    return tasksForUser(userId)
        .where(
          (element) =>
              element.dueDate.isBefore(now) &&
              element.status != 3 &&
              element.status != 4,
        )
        .length;
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _taskService.getAllTasks();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTaskStatus(TaskResponse task, int newStatus) async {
    try {
      final updatedTask = TaskResponse(
        id: task.id,
        projectId: task.projectId,
        title: task.title,
        description: task.description,
        assignedUserId: task.assignedUserId,
        priority: task.priority,
        status: newStatus,
        startDate: task.startDate,
        dueDate: task.dueDate,
        completedDate: newStatus == 3 ? DateTime.now() : task.completedDate,
        createdByUserId: task.createdByUserId,
        createdDate: task.createdDate,
        updatedDate: DateTime.now(),
      );

      final result = await _taskService.updateTask(updatedTask);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = result;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
