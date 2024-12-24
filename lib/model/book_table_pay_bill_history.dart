
class TablePayBillHistoryModel {
  final int id;
  final String offerbook_history_id;
  final String user_id;
  final String store_id;
  final String bill_amount;
  final String discount_percentage;
  final String discount_amount;
  final String after_discount_amount;
  final String convineince_fee_percentage;
  final String convineince_fee;
  final String after_convineince_fee;
  final String pay_amount;
  final String status;
  final String payment_status;
  final String razorpay_order_id;
  final String bundle;
  final String date;
  final String time;

  // Constructor with default values
  TablePayBillHistoryModel({
    required this.id,
    required this.offerbook_history_id,
    required this.user_id,
    required this.store_id,
    required this.bill_amount,
    required this.discount_percentage,
    required this.discount_amount,
    required this.after_discount_amount,
    required this.convineince_fee_percentage,
    required this.convineince_fee,
    required this.after_convineince_fee,
    required this.pay_amount,
    required this.status,
    required this.payment_status,
    required this.razorpay_order_id,
    required this.bundle,
    required this.date,
    required this.time,
  });

  // Factory method to create a TablePayBillHistory object from a Map (JSON) with default values
  factory TablePayBillHistoryModel.fromMap(Map<String, dynamic> e) {
    return TablePayBillHistoryModel(
      id: e['id'] ?? 0,
      offerbook_history_id: e['offerbook_history_id'] ?? "",  
      user_id: e['user_id'] ?? "",  
      store_id: e['store_id'] ?? "",  
      bill_amount: e['bill_amount'] ?? "0.0",  
      discount_percentage: e['discount_percentage'] ?? "0.0",  
      discount_amount: e['discount_amount'] ?? "0.0",  
      after_discount_amount: e['after_discount_amount'] ?? "0.0",  
      convineince_fee_percentage: e['convineince_fee_percentage'] ?? "0.0",  
      convineince_fee: e['convineince_fee'] ?? "0.0",  
      after_convineince_fee: e['after_convineince_fee'] ?? "0.0",  
      pay_amount: e['pay_amount'] ?? "0.0",  
      status: e['status'] ?? "0",
      payment_status: e['payment_status'] ?? "Pending",  
      razorpay_order_id: e['razorpay_order_id'] ?? "",  
      bundle: e['bundle'] ?? "",  
      date: e['date'] ?? "",  
      time: e['time'] ?? "", 
    );
  }
}
