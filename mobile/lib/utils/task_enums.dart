import 'package:flutter/material.dart';

class TaskStatusInfo {
  final String label;
  final Color color;

  const TaskStatusInfo(this.label, this.color);
}

TaskStatusInfo getTaskStatusInfo(int status) {
  switch (status) {
    case 0:
      return const TaskStatusInfo("Yeni", Colors.grey);
    case 1:
      return const TaskStatusInfo("Devam Ediyor", Colors.blue);
    case 2:
      return const TaskStatusInfo("Beklemede", Colors.orange);
    case 3:
      return const TaskStatusInfo("Tamamlandı", Colors.green);
    case 4:
      return const TaskStatusInfo("İptal Edildi", Colors.red);
    default:
      return const TaskStatusInfo("Bilinmiyor", Colors.grey);
  }
}

class TaskPriorityInfo {
  final String label;
  final Color color;

  const TaskPriorityInfo(this.label, this.color);
}

TaskPriorityInfo getTaskPriorityInfo(int priority) {
  switch (priority) {
    case 0:
      return const TaskPriorityInfo("Düşük", Colors.green);
    case 1:
      return const TaskPriorityInfo("Orta", Colors.orange);
    case 2:
      return const TaskPriorityInfo("Yüksek", Colors.deepOrange);
    case 3:
      return const TaskPriorityInfo("Kritik", Colors.red);
    default:
      return const TaskPriorityInfo("Bilinmiyor", Colors.grey);
  }
}
