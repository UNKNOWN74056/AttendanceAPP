class UserToken {
  String? token;
  String? email; // Add this line to include email information

  UserToken({this.token, this.email});

  UserToken.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email']; // Add this line to parse email
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['email'] = email; // Add this line to include email in JSON
    return data;
  }
}
