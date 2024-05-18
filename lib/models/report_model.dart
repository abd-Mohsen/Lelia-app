import 'dart:convert';

import 'package:lelia/models/user_model.dart';

List<ReportModel> reportModelFromJsonLocal(String str) {
  return List<ReportModel>.from(json.decode(str).map((x) => ReportModel.fromJsonLocal(x)));
}

List<ReportModel> reportModelFromJson(String str) {
  return List<ReportModel>.from(json.decode(str).map((x) => ReportModel.fromJsonRemote(x)));
}

String reportModelToJson(List<ReportModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  int? id;
  String title;
  String type;
  String size;
  String neighborhood;
  String street;
  String mobile;
  String landline;
  bool? availability;
  String? status;
  String? notes;
  double longitude;
  double latitude;
  DateTime date;
  List<String> images;
  bool? uploaded;
  UserModel? owner;

  static final Map<String, String> translation = {
    "صغير": "small",
    "وسط": "medium",
    "كبير": "big",
    "بائع جملة": "retail",
    "مركز تجاري (مول)": "mall",
    "صيدلية": "pharmacy",
    "بقالية": "supermarket",
  };

  ReportModel({
    this.id,
    required this.title,
    required this.type,
    required this.size,
    required this.neighborhood,
    required this.street,
    required this.mobile,
    required this.landline,
    required this.availability,
    this.status,
    required this.notes,
    required this.longitude,
    required this.latitude,
    required this.date,
    required this.images,
    this.uploaded,
    this.owner,
  });

  factory ReportModel.fromJsonLocal(Map<String, dynamic> json) => ReportModel(
        title: json["title"],
        type: json["type"],
        size: json["size"],
        neighborhood: json["neighborhood"],
        street: json["street"],
        mobile: json["mobile_number"],
        landline: json["landline_number"],
        availability: json["availability"], // might be null
        status: json["status"],
        notes: json["notes"],
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
        date: DateTime.parse(json["issue_date"]),
        uploaded: json['uploaded'] ?? true,
        images: List<String>.from(json["images"].map((x) => x)),
        owner: json["owner"] == null ? null : UserModel.fromJson(json["owner"]),
      );

  factory ReportModel.fromJsonRemote(Map<String, dynamic> json) => ReportModel(
        id: json["id"],
        title: json["title"],
        type: json["type"],
        size: json["size"],
        neighborhood: json["neighborhood"],
        street: json["street"],
        landline: json["landline_number"],
        mobile: json["mobile_number"],
        longitude: json["longitude"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        availability: json["status"] != null,
        status: json["status"],
        date: DateTime.parse(json["issue_date"]),
        notes: json["notes"],
        owner: UserModel.fromJson(json["owner"]),
        uploaded: true,
        images: List<String>.from(json["images"].map((x) => ImageModel.fromJson(x).path)),
      );

  //make another version of this that doesnt interfere with local storage
  Map<String, String> toJson() => {
        "title": title,
        "type": translation[type]!,
        "size": translation[size]!,
        "neighborhood": neighborhood,
        "street": street,
        "landline_number": landline,
        "mobile_number": mobile,
        "longitude": longitude.toString(),
        "latitude": latitude.toString(),
        "issue_date": date.toIso8601String(), //insure its like: '2024-05-11 23:34:50'
        "status": status ?? "unavailable",
        "notes": notes ?? "",
        //"images": List<String>.from(images.map((x) => x)),
      };

  Map<String, dynamic> toJsonLocal() => {
        "title": title,
        "type": type,
        "size": size,
        "neighborhood": neighborhood,
        "street": street,
        "landline_number": landline,
        "mobile_number": mobile,
        "longitude": longitude,
        "latitude": latitude,
        "issue_date": date.toIso8601String(), //insure its like: '2024-05-11 23:34:50'
        "availability": availability,
        "status": status,
        "notes": notes,
        "images": List<String>.from(images.map((x) => x)),
        "uploaded": uploaded,
      };

  @override
  String toString() {
    return "$notes\n";
  }
}

class ImageModel {
  final int id;
  final String path;

  ImageModel({
    required this.id,
    required this.path,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json["id"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "path": path,
      };
}
