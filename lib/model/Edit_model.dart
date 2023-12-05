class Edit_Model {
  String? name;
  String? age;
  String? location;
  String? profileImageUrl; // Add this field for the profile image

  Edit_Model({this.name, this.age, this.location, this.profileImageUrl});

  Edit_Model.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    location = json['location'];
    profileImageUrl = json['profileImageUrl']; // Load the profile image URL
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['age'] = age;
    data['location'] = location;
    data['profileImageUrl'] = profileImageUrl; // Save the profile image URL
    return data;
  }
}
