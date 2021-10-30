class UserEX {
  UserEX({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEX.fromMap(Map<String, dynamic> data) {
    return UserEX(id: data['id'], name: data['fullName'], email: data['email']);
  }

  final String id;
  final String name;
  final String email;
}
