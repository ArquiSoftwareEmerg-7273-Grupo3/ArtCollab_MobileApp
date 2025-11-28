class MatchScore {
  final double overall;
  final double skillMatch;
  final double experienceMatch;
  final double budgetMatch;
  final double availabilityMatch;
  final String explanation;
  final List<String> reasons;
  
  MatchScore({
    required this.overall,
    required this.skillMatch,
    required this.experienceMatch,
    required this.budgetMatch,
    required this.availabilityMatch,
    required this.explanation,
    required this.reasons,
  });
  
  factory MatchScore.fromJson(Map<String, dynamic> json) {
    return MatchScore(
      overall: (json['overall'] as num).toDouble(),
      skillMatch: (json['skillMatch'] as num).toDouble(),
      experienceMatch: (json['experienceMatch'] as num).toDouble(),
      budgetMatch: (json['budgetMatch'] as num).toDouble(),
      availabilityMatch: (json['availabilityMatch'] as num).toDouble(),
      explanation: json['explanation'] as String,
      reasons: (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'skillMatch': skillMatch,
      'experienceMatch': experienceMatch,
      'budgetMatch': budgetMatch,
      'availabilityMatch': availabilityMatch,
      'explanation': explanation,
      'reasons': reasons,
    };
  }
  
  bool get isHighMatch => overall >= 90;
  bool get isMediumMatch => overall >= 70 && overall < 90;
  bool get isLowMatch => overall < 70;
}
