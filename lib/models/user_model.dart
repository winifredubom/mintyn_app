class User {
  final String id;
  final String name;
  final String email;
  final String title;
  final String? avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.title,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      title: json['title'] ?? '',
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'title': title,
      'avatarUrl': avatarUrl,
    };
  }
}
