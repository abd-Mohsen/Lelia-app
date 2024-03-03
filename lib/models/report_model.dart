import 'dart:convert';

List<ReportModel> reportModelFromJson(String str) {
  final jsonData = json.decode(str);
  return List<ReportModel>.from(jsonData.map((x) => ReportModel.fromJson(x)));
}

String reportModelToJson(List<ReportModel> data) {
  final dyn = List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

class ReportModel {
  String title;
  String type;
  String size;
  String neighborhood;
  String street;
  String mobile;
  String landline;
  bool availability;
  String? status;
  String notes;
  double longitude;
  double latitude;
  DateTime date;
  bool? uploaded;

  ReportModel({
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
    this.uploaded,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        title: json["title"],
        type: json["type"],
        size: json["size"],
        neighborhood: json["neighborhood"],
        street: json["street"],
        mobile: json["mobile"],
        landline: json["landline"],
        availability: json["availability"],
        status: json["status"],
        notes: json["notes"],
        longitude: json["longitude"].toDouble(),
        latitude: json["latitude"].toDouble(),
        date: DateTime.parse(json["date"]),
        uploaded: json['uploaded'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "size": size,
        "neighborhood": neighborhood,
        "street": street,
        "mobile": mobile,
        "landline": landline,
        "availability": availability,
        "status": status,
        "notes": notes,
        "longitude": longitude,
        "latitude": latitude,
        "date": date.toIso8601String(),
        "uploaded": uploaded
      };

  @override
  String toString() {
    return "$title $uploaded";
  }
}
