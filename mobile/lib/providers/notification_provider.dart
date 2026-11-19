import 'package:flutter/material.dart';
import 'package:team_task_management/models/notification_response.dart';
import 'package:team_task_management/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final _notificationService = NotificationService();

  List<NotificationResponse> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationResponse> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getAllNotifications();
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);

      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = NotificationResponse(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          relatedEntityId: _notifications[index].relatedEntityId,
          isRead: true,
          createdDate: _notifications[index].createdDate,
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }
}
