class Exercise {
  final String id;
  final String userId;
  final String nameEn;
  final String nameDe;
  final String descriptionEn;
  final String descriptionDe;
  final DateTime createdAt;

  Exercise({
    required this.id,
    required this.userId,
    required this.nameEn,
    required this.nameDe,
    required this.descriptionEn,
    required this.descriptionDe,
    required this.createdAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      userId: json['user_id'],
      nameEn: json['name_en'] ?? '',
      nameDe: json['name_de'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      descriptionDe: json['description_de'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name_en': nameEn,
      'name_de': nameDe,
      'description_en': descriptionEn,
      'description_de': descriptionDe,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String getName(String languageCode) {
    return languageCode == 'de' ? nameDe : nameEn;
  }

  String getDescription(String languageCode) {
    return languageCode == 'de' ? descriptionDe : descriptionEn;
  }

  Exercise copyWith({
    String? id,
    String? userId,
    String? nameEn,
    String? nameDe,
    String? descriptionEn,
    String? descriptionDe,
    DateTime? createdAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      nameEn: nameEn ?? this.nameEn,
      nameDe: nameDe ?? this.nameDe,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionDe: descriptionDe ?? this.descriptionDe,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 