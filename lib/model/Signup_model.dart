class UserModel {
  final String email;
  final String password;
  final String? name; // Make name optional

  UserModel({
    required this.email,
    required this.password,
    this.name, // Make name optional
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['name'] = name; // Include name in the JSON data if available

    return data;
  }
}
