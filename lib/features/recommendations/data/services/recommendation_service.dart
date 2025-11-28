import '../models/match_score.dart';
import '../models/recommendation.dart';

class RecommendationService {
  /// Calculate match score for illustrator-job pairing
  /// Weights: skills(30%), experience(20%), availability(15%), budget(15%), preferences(10%), success(10%)
  MatchScore calculateIllustratorJobMatch({
    required Map<String, dynamic> illustratorProfile,
    required Map<String, dynamic> jobData,
    bool isPremium = false,
  }) {
    // Extract data
    final illustratorSkills = (illustratorProfile['skills'] as List?)?.cast<String>() ?? [];
    final jobRequiredSkills = (jobData['requiredSkills'] as List?)?.cast<String>() ?? [];
    final illustratorExperience = illustratorProfile['experienceYears'] as int? ?? 0;
    final jobExperienceRequired = jobData['experienceRequired'] as int? ?? 0;
    final illustratorRate = illustratorProfile['hourlyRate'] as double? ?? 0;
    final jobBudgetMin = jobData['budgetMin'] as double? ?? 0;
    final jobBudgetMax = jobData['budgetMax'] as double? ?? 0;
    final illustratorAvailable = illustratorProfile['isAvailable'] as bool? ?? false;
    final illustratorPreferences = (illustratorProfile['preferences'] as List?)?.cast<String>() ?? [];
    final jobGenre = jobData['genre'] as String? ?? '';
    final illustratorSuccessRate = illustratorProfile['successRate'] as double? ?? 50.0;
    
    // 1. Skill Match (30%)
    double skillMatch = 0.0;
    if (jobRequiredSkills.isNotEmpty) {
      final matchingSkills = illustratorSkills.where((skill) => 
        jobRequiredSkills.any((required) => 
          required.toLowerCase().contains(skill.toLowerCase()) ||
          skill.toLowerCase().contains(required.toLowerCase())
        )
      ).length;
      skillMatch = (matchingSkills / jobRequiredSkills.length) * 100;
    } else {
      skillMatch = 50.0; // Default if no skills specified
    }
    
    // 2. Experience Match (20%)
    double experienceMatch = 100.0;
    if (jobExperienceRequired > 0) {
      if (illustratorExperience >= jobExperienceRequired) {
        experienceMatch = 100.0;
      } else {
        experienceMatch = (illustratorExperience / jobExperienceRequired) * 100;
      }
    }
    
    // 3. Availability Match (15%)
    double availabilityMatch = illustratorAvailable ? 100.0 : 30.0;
    
    // 4. Budget Match (15%)
    double budgetMatch = 0.0;
    if (jobBudgetMax > 0) {
      if (illustratorRate >= jobBudgetMin && illustratorRate <= jobBudgetMax) {
        budgetMatch = 100.0;
      } else if (illustratorRate < jobBudgetMin) {
        budgetMatch = (illustratorRate / jobBudgetMin) * 100;
      } else {
        budgetMatch = (jobBudgetMax / illustratorRate) * 100;
      }
    } else {
      budgetMatch = 50.0;
    }
    
    // 5. Preferences Match (10%)
    double preferencesMatch = 50.0;
    if (illustratorPreferences.isNotEmpty && jobGenre.isNotEmpty) {
      final matchesPreference = illustratorPreferences.any((pref) =>
        jobGenre.toLowerCase().contains(pref.toLowerCase())
      );
      preferencesMatch = matchesPreference ? 100.0 : 30.0;
    }
    
    // 6. Success Probability (10%)
    double successProbability = illustratorSuccessRate;
    
    // Calculate weighted overall score
    double overall = (
      skillMatch * 0.30 +
      experienceMatch * 0.20 +
      availabilityMatch * 0.15 +
      budgetMatch * 0.15 +
      preferencesMatch * 0.10 +
      successProbability * 0.10
    );
    
    // Apply premium boost
    if (isPremium) {
      overall = overall * 1.10;
    }
    
    // Clamp to 0-100
    overall = overall.clamp(0.0, 100.0);
    
    // Generate explanation and reasons
    final reasons = <String>[];
    if (skillMatch >= 80) reasons.add('Excellent skill match');
    if (experienceMatch >= 90) reasons.add('Experience exceeds requirements');
    if (budgetMatch >= 90) reasons.add('Budget perfectly aligned');
    if (availabilityMatch >= 90) reasons.add('Currently available');
    if (preferencesMatch >= 90) reasons.add('Matches your preferences');
    
    final explanation = reasons.isNotEmpty
        ? reasons.join(', ')
        : 'Good potential match based on profile';
    
    return MatchScore(
      overall: overall,
      skillMatch: skillMatch,
      experienceMatch: experienceMatch,
      budgetMatch: budgetMatch,
      availabilityMatch: availabilityMatch,
      explanation: explanation,
      reasons: reasons,
    );
  }
  
  /// Calculate match score for writer-illustrator pairing
  /// Weights: portfolio(25%), reliability(20%), skills(20%), budget(15%), availability(10%), collaboration(10%)
  MatchScore calculateWriterIllustratorMatch({
    required Map<String, dynamic> writerProject,
    required Map<String, dynamic> illustratorProfile,
    bool isPremium = false,
  }) {
    // Extract data
    final portfolioQuality = illustratorProfile['portfolioQuality'] as double? ?? 50.0;
    final reliabilityScore = illustratorProfile['reliabilityScore'] as double? ?? 50.0;
    final illustratorSkills = (illustratorProfile['skills'] as List?)?.cast<String>() ?? [];
    final projectRequiredSkills = (writerProject['requiredSkills'] as List?)?.cast<String>() ?? [];
    final illustratorRate = illustratorProfile['hourlyRate'] as double? ?? 0;
    final projectBudgetMin = writerProject['budgetMin'] as double? ?? 0;
    final projectBudgetMax = writerProject['budgetMax'] as double? ?? 0;
    final illustratorAvailable = illustratorProfile['isAvailable'] as bool? ?? false;
    final collaborationFit = illustratorProfile['collaborationScore'] as double? ?? 50.0;
    
    // 1. Portfolio Quality (25%)
    double portfolioMatch = portfolioQuality;
    
    // 2. Reliability Score (20%)
    double reliabilityMatch = reliabilityScore;
    
    // 3. Skill Alignment (20%)
    double skillMatch = 0.0;
    if (projectRequiredSkills.isNotEmpty) {
      final matchingSkills = illustratorSkills.where((skill) =>
        projectRequiredSkills.any((required) =>
          required.toLowerCase().contains(skill.toLowerCase()) ||
          skill.toLowerCase().contains(required.toLowerCase())
        )
      ).length;
      skillMatch = (matchingSkills / projectRequiredSkills.length) * 100;
    } else {
      skillMatch = 50.0;
    }
    
    // 4. Budget Compatibility (15%)
    double budgetMatch = 0.0;
    if (projectBudgetMax > 0) {
      if (illustratorRate >= projectBudgetMin && illustratorRate <= projectBudgetMax) {
        budgetMatch = 100.0;
      } else if (illustratorRate < projectBudgetMin) {
        budgetMatch = (illustratorRate / projectBudgetMin) * 100;
      } else {
        budgetMatch = (projectBudgetMax / illustratorRate) * 100;
      }
    } else {
      budgetMatch = 50.0;
    }
    
    // 5. Availability (10%)
    double availabilityMatch = illustratorAvailable ? 100.0 : 30.0;
    
    // 6. Collaboration Fit (10%)
    double collaborationMatch = collaborationFit;
    
    // Calculate weighted overall score
    double overall = (
      portfolioMatch * 0.25 +
      reliabilityMatch * 0.20 +
      skillMatch * 0.20 +
      budgetMatch * 0.15 +
      availabilityMatch * 0.10 +
      collaborationMatch * 0.10
    );
    
    // Apply premium boost
    if (isPremium) {
      overall = overall * 1.10;
    }
    
    // Clamp to 0-100
    overall = overall.clamp(0.0, 100.0);
    
    // Generate explanation and reasons
    final reasons = <String>[];
    if (portfolioMatch >= 80) reasons.add('Outstanding portfolio quality');
    if (reliabilityMatch >= 85) reasons.add('Highly reliable track record');
    if (skillMatch >= 80) reasons.add('Perfect skill alignment');
    if (budgetMatch >= 90) reasons.add('Budget compatible');
    if (availabilityMatch >= 90) reasons.add('Available now');
    
    final explanation = reasons.isNotEmpty
        ? reasons.join(', ')
        : 'Solid match for your project';
    
    return MatchScore(
      overall: overall,
      skillMatch: skillMatch,
      experienceMatch: portfolioMatch,
      budgetMatch: budgetMatch,
      availabilityMatch: availabilityMatch,
      explanation: explanation,
      reasons: reasons,
    );
  }
  
  /// Track recommendation interaction
  Future<void> trackRecommendationView(String recommendationId) async {
    // TODO: Implement API call to track view
    print('Tracking view for recommendation: $recommendationId');
  }
  
  /// Track recommendation application
  Future<void> trackRecommendationApplication(String recommendationId) async {
    // TODO: Implement API call to track application
    print('Tracking application for recommendation: $recommendationId');
  }
  
  /// Track recommendation contact
  Future<void> trackRecommendationContact(String recommendationId) async {
    // TODO: Implement API call to track contact
    print('Tracking contact for recommendation: $recommendationId');
  }
}
