class ProjectResponse {
  final int id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime targetEndDate;
  final int status;
  final String managerUserId;
  final DateTime createdTime;
  final DateTime updatedTime;

  ProjectResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.targetEndDate,
    required this.status,
    required this.managerUserId,
    required this.createdTime,
    required this.updatedTime,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      startDate: DateTime.parse(json["startDate"]),
      targetEndDate: DateTime.parse(json["targetEndDate"]),
      status: json["status"],
      managerUserId: json["managerUserId"],
      createdTime: DateTime.parse(json["createdTime"]),
      updatedTime: DateTime.parse(json["updatedTime"]),
    );
  }
}
