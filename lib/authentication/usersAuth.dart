class UserLoginPosition {
  String id;
  String isVerify;
  String adminVerify;

  final String email, position;
  final String address, contactnumber;
  final String firstname, middlename, lastname;
  final String name;
  UserLoginPosition(
      {this.id = '',
      this.isVerify = '',
      this.adminVerify = '',
      required this.email,
      required this.position,
      required this.firstname,
      required this.middlename,
      required this.lastname,
      required this.name,
      required this.address,
      required this.contactnumber});

  Map<String, dynamic> toJson() => {
        'id': id,
        'adminVerify': adminVerify,
        'isVerify': isVerify,
        'email': email,
        'position': position,
        'firstname': firstname,
        'middlename': middlename,
        'lastname': lastname,
        'address': address,
        'name': name,
        'contact number': contactnumber,
      };

  static UserLoginPosition fromJson(Map<String, dynamic> json) =>
      UserLoginPosition(
          email: json['email'],
          name: json['name'],
          position: json['position'],
          firstname: json['firstname'],
          middlename: json['middlename'],
          lastname: json['lastname'],
          address: json['address'],
          contactnumber: json['contact number']);
}
