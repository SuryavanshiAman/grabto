

class LocalityModel {
  final int id;
  final String city_id;
  final String locality;
  final String image;
  final String status;
  final String created_at;
  final String updated_at;

  LocalityModel({
    required this.id,
    required this.city_id,
    required this.locality,
    required this.image,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory LocalityModel.fromMap(Map<String, dynamic> map) {
    return LocalityModel(
      id: map['id'] ?? 0,
      city_id: map['city_id'] ?? '',
      locality: map['locality'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }
}
