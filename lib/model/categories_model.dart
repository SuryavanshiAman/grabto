class CategoriesModel {
  final int id;
  final String category_name;
  final String status;
  final String image;
  final String created_at;
  final String updated_at;



  CategoriesModel(
      {required this.id,
      required this.category_name,
      required this.status,
      required this.image,
      required this.created_at,
      required this.updated_at});

  factory CategoriesModel.fromMap(Map<String, dynamic> e) {
    return CategoriesModel(
        id: e['id'],
        category_name: e['category_name'],
        status: e['status'],
        image: e['image'],
        created_at: e['created_at'],
        updated_at: e['updated_at']);
  }



}
