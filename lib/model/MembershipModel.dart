class MembershipModel{

  final int id;
  final String discount_price;
  final String gst_price;
  final String pay_amount;
  final String salecode;
  final String user_id;
  final String plan_id;
  final String cur_date;
  final String exp_date;
  final String status;
  final String payment_status;
  final String razorpay_order_id;
  final String bundle;
  final String created_at;
  final String updated_at;
  final String plan_name;
  final String plan_duration;
  final int left_day;

  MembershipModel(
      {required this.id,
        required this.discount_price,
        required this.gst_price,
        required this.pay_amount,
        required this.salecode,
        required this.user_id,
        required this.plan_id,
        required this.cur_date,
        required this.exp_date,
        required this.status,
        required this.payment_status,
        required this.razorpay_order_id,
        required this.bundle,
        required this.created_at,
        required this.updated_at,
        required this.plan_name,
        required this.plan_duration,
        required this.left_day});

  factory MembershipModel.fromMap(Map<String, dynamic> map) {
    return MembershipModel(
      id: map['id'] ?? 0,
      discount_price: map['discount_price'] ?? '',
      gst_price: map['gst_price'] ?? '',
      pay_amount: map['pay_amount'] ?? '',
      salecode: map['salecode'] ?? '',
      user_id: map['user_id'] ?? '',
      plan_id: map['plan_id'] ?? '',
      cur_date: map['cur_date'] ?? '',
      exp_date: map['exp_date'] ?? '',
      status: map['status'] ?? '',
      payment_status: map['payment_status'] ?? '',
      razorpay_order_id: map['razorpay_order_id'] ?? '',
      bundle: map['bundle'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      plan_name: map['plan_name'] ?? '',
      plan_duration: map['plan_duration'] ?? '',
      left_day: map['left_day'] ?? 0,
    );
  }

}
