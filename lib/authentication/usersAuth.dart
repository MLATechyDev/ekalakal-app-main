class UserLoginPosition {
  String id;

  final String email, position;
  final String name, address, contactnumber;

  UserLoginPosition(
      {this.id = '',
      required this.email,
      required this.position,
      required this.name,
      required this.address,
      required this.contactnumber});

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'position': position,
        'name': name,
        'address': address,
        'contact number': contactnumber,
      };

  static UserLoginPosition fromJson(Map<String, dynamic> json) =>
      UserLoginPosition(
          email: json['email'],
          position: json['position'],
          name: json['name'],
          address: json['address'],
          contactnumber: json['contact number']);
}
