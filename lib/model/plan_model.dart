class PlanModel {
  final int id;
  final String appleProductId; // Add this line
  final String appleProductIdOffer; // Add this line
  final String name;
  final String duration;
  final String salePrice;
  final String offerPrice;
  final String netPrice;
  final String status;
  final String createdAt;
  final String updatedAt;

  PlanModel({
    required this.id,
    required this.appleProductId, // Add this line
    required this.appleProductIdOffer, // Add this line
    required this.name,
    required this.duration,
    required this.salePrice,
    required this.offerPrice,
    required this.netPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      id: map['id'] ?? 0,
      appleProductId: map['apple_product_id'] ?? '', // Update this line
      appleProductIdOffer: map['apple_product_id_offer']??'',
      name: map['name'] ?? '',
      duration: map['duration'] ?? '',
      salePrice: map['sale_price'] ?? '',
      offerPrice: map['offer_price'] ?? '',
      netPrice: map['net_price'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
