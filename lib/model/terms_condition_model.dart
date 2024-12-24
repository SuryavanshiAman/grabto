
class TermConditionModel {
  final int id;
  final String storeId;
  final String status;
  final String termCondition;
  final String createdAt;
  final String updatedAt;

  TermConditionModel({
    required this.id,
    required this.storeId,
    required this.status,
    required this.termCondition,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermConditionModel.fromMap(Map<String, dynamic> map) {
    return TermConditionModel(
      id: map['id'] ?? 0,
      storeId: map['store_id'] ?? '',
      status: map['status'] ?? '',
      termCondition: map['term_condition'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }
}
