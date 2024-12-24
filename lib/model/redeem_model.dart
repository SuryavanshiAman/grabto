

class RedeemModel {
  final int id;
  final int? qty;
  final String userId;
  final String couponId;
  final String storeId;
  final String qrcode;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String storeName;
  final String logo;
  final String couponTitle;
  final String couponDescription;
  final String couponDiscount;

  RedeemModel({
    required this.id,
    required this.qty,
    required this.userId,
    required this.couponId,
    required this.storeId,
    required this.qrcode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.storeName,
    required this.logo,
    required this.couponTitle,
    required this.couponDescription,
    required this.couponDiscount,
  });

  factory RedeemModel.fromMap(Map<String, dynamic> map) {
    return RedeemModel(
      id: map['id'] ?? 0,
      qty: map['qty'] != null ? int.parse(map['qty']) : null, // Convert String to int
      userId: map['user_id'] ?? '',
      couponId: map['coupon_id'] ?? '',
      storeId: map['store_id'] ?? '',
      qrcode: map['qrcode'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      storeName: map['store_name'] ?? '',
      logo: map['logo'] ?? '',
      couponTitle: map['coupon_title'] ?? '',
      couponDescription: map['coupon_description'] ?? '',
      couponDiscount: map['coupon_discount'] ?? '',
    );
  }

}
