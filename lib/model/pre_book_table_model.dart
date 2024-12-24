class PreBookTable {
  final int id;
  final String store_id;
  final String title;
  final String discount_percentage;
  final String booking_fee; // Nullable type for booking_fee
  final String available_seat;
  final String status;
  final String created_at;
  final String updated_at;

  PreBookTable({
    required this.id,
    required this.store_id,
    required this.title,
    required this.discount_percentage,
    required this.booking_fee, // Nullable field
    required this.available_seat,
    required this.status,
    required this.created_at,
    required this.updated_at,
  });

  factory PreBookTable.fromMap(Map<String, dynamic> e) {
    return PreBookTable(
      id: e['id'] ?? 0,
      store_id: e['store_id'] ?? '',
      title: e['title'] ?? '',
      discount_percentage: e['discount_percentage'] ?? '0',
      booking_fee: e['booking_fee'] ?? '',
      available_seat: e['available_seat'] ?? '0',
      status: e['status'] ?? '0',
      created_at: e['created_at'] ?? '',
      updated_at: e['updated_at'] ?? '',
    );
  }
}
