import 'package:flutter/material.dart';
import 'package:team_task_management/models/task_comment_response.dart';
import '../services/task_comment_service.dart';

class TaskCommentProvider extends ChangeNotifier {
  final _commentService = TaskCommentService();

  List<TaskCommentResponse> _comments = [];
  bool _isLoading = false;
  bool _isSending = false;
  String? _errorMessage;

  List<TaskCommentResponse> get comments => _comments;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<void> fetchComments(int taskItemId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comments = await _commentService.getCommentsByTaskId(taskItemId);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addComment(int taskItemId, String content) async {
    _isSending = true;
    notifyListeners();

    try {
      final newComment = await _commentService.addComment(taskItemId, content);
      _comments.add(newComment);
      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isSending = false;
      notifyListeners();
      return false;
    }
  }
}
