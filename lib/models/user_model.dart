class UserModels {
  List<Users>? users;

  UserModels({this.users});

  UserModels.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? id;
  String? firstName;
  String? lastName;
  int? age;
  String? gender;
  String? image;
  Address? address;
  String? role;

  Users({
    this.id,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.image,
    this.address,
    this.role,
  });

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    age = json['age'];
    gender = json['gender'];
    image = json['image'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['age'] = age;
    data['gender'] = gender;
    data['image'] = image;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['role'] = role;
    return data;
  }
}

class Address {
  String? address;
  String? city;
  String? state;
  String? country;

  Address({this.address, this.city, this.state, this.country});

  Address.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}
