class UserEX {
  UserEX({
    required this.id,
    required this.name,
    required this.email,
    required this.ratings,
  });

  factory UserEX.fromMap(Map<String, dynamic> data) {
    return UserEX(
        ratings: data['ratings'],
        id: data['id'],
        name: data['fullName'],
        email: data['email']);
  }

  final String id;
  final String name;
  final String email;
  final List<dynamic> ratings;
}
