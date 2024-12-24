class FeaturesModel {
  final int id;
  final String storeId;
  final String status;
  final String image;
  final String name;
  final String createdAt;
  final String updatedAt;

  FeaturesModel({
    required this.id,
    required this.storeId,
    required this.status,
    required this.image,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeaturesModel.fromMap(Map<String, dynamic> map) {
    return FeaturesModel(
      id: map['id'] ?? 0,
      storeId: map['store_id'] ?? '',
      status: map['status'] ?? '',
      image: map['image'] ?? '',
      name: map['name'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
