class GalleryModel {
  final int id;
  final String storeId;
  final String foodType;
  final String image;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  GalleryModel({
    required this.id,
    required this.storeId,
    required this.foodType,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });


  factory GalleryModel.fromMap(Map<String, dynamic> map) {
    return GalleryModel(
      id: map['id'],
      storeId: map['store_id'],
      foodType: map['food_type'],
      image: map['image'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
