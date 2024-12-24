class StoreModel {
  final int id;
  final String storeType;
  final String storeName;
  final String categoryId;
  final String subcategoryId;
  final String qrCode;
  final String logo;
  final String banner;
  final String mobile;
  final String password;
  final String address;
  final String mapLink;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String distance;
  final String latitude;
  final String longitude;
  final String offers;
  final String rating;
  final String redeem;
  final String offerId;
  final String topCollectionId;
  final String trendingStatus;
  final String recentStatus;
  final String topCollectionStatus;
  final String ownerFirstName;
  final String ownerLastName;
  final String address2;
  final String country;
  final String state;
  final String postcode;
  final String categoryName;
  final String subcategoryName;
  final String wishlistStatus; // Add wishlistStatus field
  final String kycStatus;

  StoreModel({
    required this.id,
    required this.storeType,
    required this.storeName,
    required this.categoryId,
    required this.subcategoryId,
    required this.qrCode,
    required this.logo,
    required this.banner,
    required this.mobile,
    required this.password,
    required this.address,
    required this.mapLink,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.offers,
    required this.rating,
    required this.redeem,
    required this.offerId,
    required this.topCollectionId,
    required this.trendingStatus,
    required this.recentStatus,
    required this.topCollectionStatus,
    required this.ownerFirstName,
    required this.ownerLastName,
    required this.address2,
    required this.country,
    required this.state,
    required this.postcode,
    required this.categoryName,
    required this.subcategoryName,
    required this.wishlistStatus, // Initialize wishlistStatus
    required this.kycStatus, // Initialize wishlistStatus
  });

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['id'] ?? 0,
      storeType: map['store_type'] ?? '',
      storeName: map['store_name'] ?? '',
      categoryId: map['category_id'] ?? '',
      subcategoryId: map['subcategory_id'] ?? '',
      qrCode: map['qrcode']?.toString() ?? '',
      logo: map['logo'] ?? '',
      banner: map['banner'] ?? '',
      mobile: map['mobile'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      mapLink: map['map_link'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      distance: map['distance'] ?? '',
      latitude: map['lat']?.toString() ?? '',
      longitude: map['long']?.toString() ?? '',
      offers: map['offers'] ?? '',
      rating: map['rating'] ?? '',
      redeem: map['redem'] ?? '',
      offerId: map['offer_id'] ?? '',
      topCollectionId: map['topcollection_id'] ?? '',
      trendingStatus: map['trending_status'] ?? '',
      recentStatus: map['recent_status'] ?? '',
      topCollectionStatus: map['topcollection_status'] ?? '',
      ownerFirstName: map['owner_fname'] ?? '',
      ownerLastName: map['owner_lname'] ?? '',
      address2: map['address2'] ?? '',
      country: map['country'] ?? '',
      state: map['state'] ?? '',
      postcode: map['postcode'] ?? '',
      categoryName: map['category_name'] ?? '',
      subcategoryName: map['subcategory_name'] ?? '',
      wishlistStatus: map['wishlist_status'] ?? '', // Initialize wishlistStatus
      kycStatus: map['kyc_status'] ?? '', // Initialize wishlistStatus
    );
  }
}