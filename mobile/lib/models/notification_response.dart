class NotificationResponse {
  final int id;
  final String userId;
  final String title;
  final String message;
  final int type;
  final int? relatedEntityId;
  final bool isRead;
  final DateTime createdDate;

  NotificationResponse({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.relatedEntityId,
    required this.isRead,
    required this.createdDate,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      message: json['message'],
      type: json['type'],
      relatedEntityId: json['relatedEntityId'],
      isRead: json['isRead'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}
