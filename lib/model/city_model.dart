

class CityModel{

  final int id;
  final String city;
  final String status;
  final String created_at;
  final String updated_at;

  CityModel(
      {required this.id,
        required this.city,
        required this.status,
        required this.created_at,
        required this.updated_at});

  factory CityModel.fromMap(Map<String, dynamic> map) {
    return CityModel(
      id: map['id'] ?? 0,
      city: map['city'] ?? '',
      status: map['status'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }

}