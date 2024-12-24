class TimeModel {
  final int id;
  final String store_id;
  final String status;
  final String day;
  final String operation_status; // Add this field
  final String start_time;
  final String end_time;
  final String created_at;
  final String updated_at;

  TimeModel({
    required this.id,
    required this.store_id,
    required this.status,
    required this.day,
    required this.operation_status, // Update constructor to include this
    required this.start_time,
    required this.end_time,
    required this.created_at,
    required this.updated_at,
  });

  factory TimeModel.fromMap(Map<String, dynamic> map) {
    return TimeModel(
      id: map['id'] ?? 0,
      store_id: map['store_id'] ?? '',
      status: map['status'] ?? '',
      day: map['day'] ?? '',
      operation_status: map['operation_status'] ?? '', // Assign operation_status
      start_time: map['start_time'] ?? '',
      end_time: map['end_time'] ?? '',
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
    );
  }
}
