
class UserModel {
  final int id;
  final String current_month;
  final String premium;
  final String status;
  final String name;
  final String email;
  final String mobile;
  final String dob;
  final String otp;
  final String image;
  final String home_location;
  final String current_location;
  final String lat;
  final String long;
  final String created_at;
  final String updated_at;

  UserModel({
    required this.id,
    required this.current_month,
    required this.premium,
    required this.status,
    required this.name,
    required this.email,
    required this.mobile,
    required this.dob,
    required this.otp,
    required this.image,
    required this.home_location,
    required this.current_location,
    required this.lat,
    required this.long,
    required this.created_at,
    required this.updated_at,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      current_month: map['current_month'] ?? '',
      premium: map['premium'] ?? '',
      status: map['status'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      dob: map['dob'] ?? '',
      otp: map['otp'] ?? '',
      image: map['image'] ?? '',
      home_location: map['home_location'] ?? '',
      current_location: map['current_location'] ?? '',
      lat: map['lat'] ?? '',
      long: map['long'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }
}
