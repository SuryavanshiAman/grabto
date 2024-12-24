

class GreatOfferModel {
  final int id;
  final String status;
  final String offerName;
  final String image;
  final String createdAt;
  final String updatedAt;

  GreatOfferModel({
    required this.id,
    required this.status,
    required this.offerName,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GreatOfferModel.fromMap(Map<String, dynamic> map) {
    return GreatOfferModel(
      id: map['id'] ?? 0,
      status: map['status'] ?? '',
      offerName: map['offer_name'] ?? '',
      image: map['image'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
