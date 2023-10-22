class ContactModel {
  String? objectId;
  List<String>? tags;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? imagePath;
  bool? favorite;

  ContactModel.empty();

  ContactModel(
      {this.tags,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.imagePath,
      this.favorite});

  ContactModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'];
    tags = json['tags'].cast<String>();
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    imagePath = json['image_path'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tags'] = tags;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['image_path'] = imagePath;
    data['favorite'] = favorite;
    return data;
  }
}
