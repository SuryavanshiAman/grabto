

class CouponModel {
  final int id;
  final String storeId;
  final String couponTitle;
  final String couponDescription;
  final String couponDiscount;
  final String numberOfCoupon;
  final String banner;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String qrcode;

  CouponModel({
    required this.id,
    required this.storeId,
    required this.couponTitle,
    required this.couponDescription,
    required this.couponDiscount,
    required this.numberOfCoupon,
    required this.banner,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.qrcode,
  });

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] ?? 0,
      storeId: map['store_id'] ?? '',
      couponTitle: map['coupon_title'] ?? '',
      couponDescription: map['coupon_description'] ?? '',
      couponDiscount: map['coupon_discount'] ?? '',
      numberOfCoupon: map['no_of_coupon'] ?? '',
      banner: map['banner'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      qrcode: map['qrcode'] ?? '',
    );
  }

}
