enum SubscriptionTier {
  free,
  pro,      // $9.99/month
  premium,  // $19.99/month
}

class UserSubscription {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final List<String> features;
  
  UserSubscription({
    required this.tier,
    this.expiresAt,
    required this.isActive,
    required this.features,
  });
  
  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      isActive: json['isActive'] as bool,
      features: (json['features'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'tier': tier.name,
      'expiresAt': expiresAt?.toIso8601String(),
      'isActive': isActive,
      'features': features,
    };
  }
  
  bool get isPremium => tier == SubscriptionTier.premium;
  bool get isPro => tier == SubscriptionTier.pro;
  bool get isFree => tier == SubscriptionTier.free;
  
  double get matchScoreBoost => (isPremium || isPro) ? 1.10 : 1.0;
  
  static UserSubscription get defaultFree => UserSubscription(
    tier: SubscriptionTier.free,
    isActive: true,
    features: [
      'Basic job search',
      'Limited applications (5/month)',
      'Standard profile',
      'Basic recommendations',
    ],
  );
  
  static UserSubscription get pro => UserSubscription(
    tier: SubscriptionTier.pro,
    isActive: true,
    features: [
      'Unlimited applications',
      'Advanced search filters',
      'Priority in recommendations',
      'Analytics dashboard',
      'Premium profile badges',
    ],
  );
  
  static UserSubscription get premiumPlan => UserSubscription(
    tier: SubscriptionTier.premium,
    isActive: true,
    features: [
      'All Pro features',
      'AI-powered insights',
      'Direct messaging',
      'Featured profile placement',
      'Custom portfolio themes',
      'Advanced analytics',
    ],
  );
}
