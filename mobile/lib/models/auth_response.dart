class AuthResponse {
  final String token;
  final String email;
  final String fullName;
  final List<String> roles;
  final DateTime expiresAt;

  AuthResponse({
    required this.token,
    required this.email,
    required this.fullName,
    required this.roles,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      email: json['email'],
      fullName: json['fullName'],
      roles: List<String>.from(json['roles']),
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}
