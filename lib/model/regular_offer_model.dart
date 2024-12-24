class RegularOfferModel {
  final int id;
  final String store_id;
  final String title;
  final String description;
  final String discount_percentage;
  final String term_condition;
  final String image;
  final String status;
  final String created_at;
  final String updated_at;

  RegularOfferModel({
    required this.id,
    required this.store_id,
    required this.title,
    required this.description,
    required this.discount_percentage,
    required this.term_condition,
    required this.image,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory RegularOfferModel.fromMap(Map<String, dynamic> e) {
    return RegularOfferModel(
      id: e['id'] ?? 0,
      store_id: e['store_id'] ?? '',
      title: e['title'] ?? '',
      description: e['description'] ?? '',
      discount_percentage: e['discount_percentage'] ?? '0',
      term_condition: e['term_condition'] ?? '',
      image: e['image'] ?? '',
      status: e['status'] ?? '0',
      created_at: e['created_at'] ?? '',
      updated_at: e['updated_at'] ?? '',
    );
  }
}
