class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? regdate;
  String? subscription;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.regdate,
      this.subscription});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    regdate = json['regdate'];
    subscription = json['subscription'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['regdate'] = regdate;
    data['subscription'] = subscription.toString();
    return data;
  }
}
