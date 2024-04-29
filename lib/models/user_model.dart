import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  final int id;
  final String userName;
  final String email;
  final String phone;
  final UserModel? supervisor;

  UserModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.phone,
    required this.supervisor,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        userName: json["user_name"],
        email: json["email"],
        phone: json["phone"],
        supervisor: json["supervisor"] != null ? UserModel.fromJson(json["supervisor"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "email": email,
        "phone": phone,
        "supervisor": supervisor!.toJson(),
      };
}
