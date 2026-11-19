class TaskCommentResponse {
  final int id;
  final int taskItemId;
  final String userId;
  final String content;
  final DateTime createdDate;
  final DateTime? updatedDate;

  TaskCommentResponse({
    required this.id,
    required this.taskItemId,
    required this.userId,
    required this.content,
    required this.createdDate,
    this.updatedDate,
  });

  factory TaskCommentResponse.fromJson(Map<String, dynamic> json) {
    return TaskCommentResponse(
      id: json['id'],
      taskItemId: json['taskItemId'],
      userId: json['userId'],
      content: json['content'],
      createdDate: DateTime.parse(json['createdDate']),
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
    );
  }
}
