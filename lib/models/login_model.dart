class LoginModel {
  bool? status;
  String? message;
  Data? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] == null ? null : Data.fromJson(json['data']);
  }
}

class Data {
  String? name, email, phone, image, token;
  int? id, points, credit;

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}
