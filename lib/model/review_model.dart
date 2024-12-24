class ReviewModel {
  final int id;
  final String userId;
  final String storeId;
  final double rating; // Change type to double
  final String image;
  final String description;
  final String createdAt;
  final String name;
  final String userImage;
  final String date;
  final String time;
  final String timeDifference;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.rating,
    required this.image,
    required this.description,
    required this.createdAt,
    required this.name,
    required this.userImage,
    required this.date,
    required this.time,
    required this.timeDifference,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? 0,
      userId: map['user_id'] ?? '',
      storeId: map['store_id'] ?? '',
      rating: double.parse(map['rating'] ?? '0'),
      // Convert String to double
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      createdAt: map['created_at'] ?? '',
      name: map['name'] ?? '',
      userImage: map['user_image'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      timeDifference: map['time_difference'] ?? '',
    );
  }
}
