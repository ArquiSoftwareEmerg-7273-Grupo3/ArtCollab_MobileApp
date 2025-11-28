import 'match_score.dart';

class Recommendation {
  final String id;
  final String targetId;
  final String targetType; // 'job' or 'illustrator'
  final MatchScore matchScore;
  final Map<String, dynamic> targetData;
  final DateTime createdAt;
  final bool isViewed;
  final bool isApplied;
  
  Recommendation({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.matchScore,
    required this.targetData,
    required this.createdAt,
    this.isViewed = false,
    this.isApplied = false,
  });
  
  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      id: json['id'] as String,
      targetId: json['targetId'] as String,
      targetType: json['targetType'] as String,
      matchScore: MatchScore.fromJson(json['matchScore'] as Map<String, dynamic>),
      targetData: json['targetData'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
      isApplied: json['isApplied'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'targetId': targetId,
      'targetType': targetType,
      'matchScore': matchScore.toJson(),
      'targetData': targetData,
      'createdAt': createdAt.toIso8601String(),
      'isViewed': isViewed,
      'isApplied': isApplied,
    };
  }
  
  Recommendation copyWith({
    String? id,
    String? targetId,
    String? targetType,
    MatchScore? matchScore,
    Map<String, dynamic>? targetData,
    DateTime? createdAt,
    bool? isViewed,
    bool? isApplied,
  }) {
    return Recommendation(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      targetType: targetType ?? this.targetType,
      matchScore: matchScore ?? this.matchScore,
      targetData: targetData ?? this.targetData,
      createdAt: createdAt ?? this.createdAt,
      isViewed: isViewed ?? this.isViewed,
      isApplied: isApplied ?? this.isApplied,
    );
  }
}
