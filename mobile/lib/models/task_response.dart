class TaskResponse {
  final int id;
  final int projectId;
  final String title;
  final String? description;
  final String? assignedUserId;
  final int priority;
  final int status;
  final DateTime? startDate;
  final DateTime dueDate;
  final DateTime? completedDate;
  final String? createdByUserId;
  final DateTime createdDate;
  final DateTime? updatedDate;

  TaskResponse({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    this.assignedUserId,
    required this.priority,
    required this.status,
    this.startDate,
    required this.dueDate,
    this.completedDate,
    this.createdByUserId,
    required this.createdDate,
    this.updatedDate,
  });

  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      id: json['id'],
      projectId: json['projectId'],
      title: json['title'] ?? 'İsimsiz Görev',
      description: json['description'],
      assignedUserId: json['assignedUserId'],
      priority: json['priority'] ?? 0,
      status: json['status'] ?? 0,
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : DateTime.now(),
      completedDate: json['completedDate'] != null
          ? DateTime.parse(json['completedDate'])
          : null,
      createdByUserId: json['createdByUserId'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : DateTime.now(),

      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
