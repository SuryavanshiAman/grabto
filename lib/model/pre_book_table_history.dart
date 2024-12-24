class PreBookTableHistoryModel {
  final int id;
  final String user_id;
  final String store_id;
  final String offer_book_tbl_id;
  final String no_of_guest;
  final String type;
  final String date;
  final String time;
  final String booking_date;
  final String booking_time;
  final String booking_fee;
  final String amount;
  final String gst_percentage;
  final String gst_amount;
  final String after_gst_amount;
  final String pay_amount;
  final String status;
  final String table_status;
  final String payment_status;
  final String razorpay_order_id;
  final String bundle;
  final String username;
  final String store_name;
  final String logo;
  final String address;
  final String map_link;
  final String mobile;
  final String title;
  final String discount_percentage;
  final String available_seat;

  PreBookTableHistoryModel({
    required this.id,
    required this.user_id,
    required this.store_id,
    required this.offer_book_tbl_id,
    required this.no_of_guest,
    required this.type,
    required this.date,
    required this.time,
    required this.booking_date,
    required this.booking_time,
    required this.booking_fee,
    required this.amount,
    required this.gst_percentage,
    required this.gst_amount,
    required this.after_gst_amount,
    required this.pay_amount,
    required this.status,
    required this.table_status,
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
    required this.discount_percentage,
    required this.available_seat,
  });

  factory PreBookTableHistoryModel.fromMap(Map<String, dynamic> e) {
    return PreBookTableHistoryModel(
      id: e['id'] ?? 0,
      user_id: e['user_id'] ?? '',
      store_id: e['store_id'] ?? '',
      offer_book_tbl_id: e['offer_book_tbl_id'] ?? '',
      no_of_guest: e['no_of_guest'] ?? '0',
      type: e['type'] ?? '',
      date: e['date'] ?? '',
      time: e['time'] ?? '',
      booking_date: e['booking_date'] ?? '',
      booking_time: e['booking_time'] ?? '',
      booking_fee: e['booking_fee'] ?? '0',
      amount: e['amount'] ?? '0',
      gst_percentage: e['gst_percentage'] ?? '0',
      gst_amount: e['gst_amount'] ?? '0',
      after_gst_amount: e['after_gst_amount'] ?? '0',
      pay_amount: e['pay_amount'] ?? '0',
      status: e['status'] ?? '0',
      table_status: e['table_status'] ?? '',
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
      discount_percentage: e['discount_percentage'] ?? '0',
      available_seat: e['available_seat'] ?? '0',
    );
  }
}
