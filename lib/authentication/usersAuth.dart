class UserLoginPosition {
  String id;
  final String email, position;

  UserLoginPosition({
    this.id = '',
    required this.email,
    required this.position,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'position': position,
      };

  static UserLoginPosition fromJson(Map<String, dynamic> json) =>
      UserLoginPosition(email: json['email'], position: json['position']);
}
