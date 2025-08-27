class Workout {
  final String id;
  final String userId;
  final String name;
  final DateTime date;
  final DateTime createdAt;

  Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.createdAt,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'date': date.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  Workout copyWith({
    String? id,
    String? userId,
    String? name,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Workout(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 