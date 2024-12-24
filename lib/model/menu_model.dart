

class MenuModel {
  final int id;
  final String store_id;
  final String image;
  final String status;
  final String created_at;
  final String updated_at;

  MenuModel({
    required this.id,
    required this.store_id,
    required this.image,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'] ?? 0,
      store_id: map['store_id'] ?? '',
      image: map['image'] ?? '',
      status: map['status'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }
}
