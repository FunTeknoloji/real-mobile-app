class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String username;
  final String? birthDate;
  final String? avatarUrl;
  final String role;
  final String status;
  final String plan;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    this.birthDate,
    this.avatarUrl,
    required this.role,
    required this.status,
    required this.plan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      username: json['username'] ?? '',
      birthDate: json['birth_date'],
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'user',
      status: json['status'] ?? 'active',
      plan: json['plan'] ?? 'free',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'username': username,
      'birth_date': birthDate,
      'avatar_url': avatarUrl,
      'role': role,
      'status': status,
      'plan': plan,
    };
  }
}
