class RegularOfferHistory {
  final int id;
  final String user_id;
  final String store_id;
  final String walkin_offer_id; // Adjusted from offer_book_tbl_id
  final String date;
  final String time;
  final String bill_amount; // Adjusted from amount
  final String discount_percentage;
  final String discount_amount;
  final String after_discount_amount; // Adjusted from after_gst_amount
  final String convenience_fee_percentage;
  final String convenience_fee;
  final String after_convenience_fee; // Adjusted to match JSON
  final String pay_amount;
  final String status;
  final String payment_status;
  final String razorpay_order_id;
  final String bundle;
  final String username; // New field from JSON
  final String store_name;
  final String logo;
  final String address;
  final String map_link;
  final String mobile;
  final String title;

  RegularOfferHistory({
    required this.id,
    required this.user_id,
    required this.store_id,
    required this.walkin_offer_id,
    required this.date,
    required this.time,
    required this.bill_amount,
    required this.discount_percentage,
    required this.discount_amount,
    required this.after_discount_amount,
    required this.convenience_fee_percentage,
    required this.convenience_fee,
    required this.after_convenience_fee,
    required this.pay_amount,
    required this.status,
    required this.payment_status,
    required this.razorpay_order_id,
    required this.bundle,
    required this.username,
    required this.store_name,
    required this.logo,
    required this.address,
    required this.map_link,
    required this.mobile,
    required this.title,
  });

  factory RegularOfferHistory.fromMap(Map<String, dynamic> e) {
    return RegularOfferHistory(
      id: e['id'] ?? 0,
      user_id: e['user_id'] ?? '',
      store_id: e['store_id'] ?? '',
      walkin_offer_id: e['walkin_offer_id'] ?? '',
      date: e['date'] ?? '',
      time: e['time'] ?? '',
      bill_amount: e['bill_amount'] ?? '0',
      discount_percentage: e['discount_percentage'] ?? '0',
      discount_amount: e['discount_amount'] ?? '0',
      after_discount_amount: e['after_discount_amount'] ?? '0',
      convenience_fee_percentage: e['convenience_fee_percentage'] ?? '0',
      convenience_fee: e['convenience_fee'] ?? '0',
      after_convenience_fee: e['after_convenience_fee'] ?? '0',
      pay_amount: e['pay_amount'] ?? '0',
      status: e['status'] ?? '0',
      payment_status: e['payment_status'] ?? '',
      razorpay_order_id: e['razorpay_order_id'] ?? '',
      bundle: e['bundle'] ?? '',
      username: e['username'] ?? '',
      store_name: e['store_name'] ?? '',
      logo: e['logo'] ?? '',
      address: e['address'] ?? '',
      map_link: e['map_link'] ?? '',
      mobile: e['mobile'] ?? '',
      title: e['title'] ?? '',
    );
  }
}
