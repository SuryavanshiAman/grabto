
class SubCategoriesModel {
  final int id;
  final String category_id;
  final String subcategory_name;
  final String image;
  final String status;
  final String created_at;
  final String updated_at;



  SubCategoriesModel(
      {required this.id,
        required this.category_id,
        required this.subcategory_name,
        required this.image,
        required this.status,
        required this.created_at,
        required this.updated_at});

  factory SubCategoriesModel.fromMap(Map<String, dynamic> e) {
    return SubCategoriesModel(
        id: e['id'],
        category_id: e['category_id'],
        subcategory_name: e['subcategory_name'],
        image: e['image'],
        status: e['status'],
        created_at: e['created_at'],
        updated_at: e['updated_at']);
  }



}
