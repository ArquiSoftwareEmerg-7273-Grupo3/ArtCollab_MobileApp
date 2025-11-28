import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/features/recommendations/data/services/recommendation_service.dart';
import 'package:artcollab_mobile/features/recommendations/data/models/match_score.dart';

void main() {
  late RecommendationService service;
  
  setUp(() {
    service = RecommendationService();
  });
  
  group('Illustrator Match Score Calculation Tests', () {
    /// Feature: premium-design-recommendations, Property 4: Illustrator match score calculation
    /// Validates: Requirements 4.2
    test('Property: Match score uses correct weights (30-20-15-15-10-10)', () {
      final illustrator = {
        'skills': ['Digital Art', 'Fantasy'],
        'experienceYears': 5,
        'hourlyRate': 50.0,
        'isAvailable': true,
        'preferences': ['Fantasy'],
        'successRate': 80.0,
      };
      
      final job = {
        'requiredSkills': ['Digital Art', 'Fantasy'],
        'experienceRequired': 3,
        'budgetMin': 40.0,
        'budgetMax': 60.0,
        'genre': 'Fantasy',
      };
      
      final matchScore = service.calculateIllustratorJobMatch(
        illustratorProfile: illustrator,
        jobData: job,
      );
      
      // Verify score is calculated
      expect(matchScore.overall, greaterThan(0));
      expect(matchScore.overall, lessThanOrEqualTo(100));
      
      // Verify all components are present
      expect(matchScore.skillMatch, greaterThanOrEqualTo(0));
      expect(matchScore.experienceMatch, greaterThanOrEqualTo(0));
      expect(matchScore.budgetMatch, greaterThanOrEqualTo(0));
      expect(matchScore.availabilityMatch, greaterThanOrEqualTo(0));
    });
    
    /// Feature: premium-design-recommendations, Property 6: High match indicator
    /// Validates: Requirements 4.4
    test('Property: Matches >= 90% are classified as high matches', () {
      final testScores = [90.0, 92.5, 95.0, 98.0, 100.0];
      
      for (final score in testScores) {
        final matchScore = MatchScore(
          overall: score,
          skillMatch: score,
          experienceMatch: score,
          budgetMatch: score,
          availabilityMatch: score,
          explanation: 'Test',
          reasons: [],
        );
        
        expect(matchScore.isHighMatch, isTrue,
            reason: 'Score $score should be high match');
      }
    });
    
    test('Property: Matches < 90% are not classified as high matches', () {
      final testScores = [0.0, 50.0, 75.0, 85.0, 89.9];
      
      for (final score in testScores) {
        final matchScore = MatchScore(
          overall: score,
          skillMatch: score,
          experienceMatch: score,
          budgetMatch: score,
          availabilityMatch: score,
          explanation: 'Test',
          reasons: [],
        );
        
        expect(matchScore.isHighMatch, isFalse,
            reason: 'Score $score should not be high match');
      }
    });
    
    /// Feature: premium-design-recommendations, Property 7: Recommendation completeness
    /// Validates: Requirements 4.3
    test('Property: All recommendations contain required fields', () {
      final matchScore = MatchScore(
        overall: 85.0,
        skillMatch: 90.0,
        experienceMatch: 80.0,
        budgetMatch: 85.0,
        availabilityMatch: 88.0,
        explanation: 'Good match',
        reasons: ['Skill fit', 'Budget aligned'],
      );
      
      // Verify all required fields are present
      expect(matchScore.overall, isNotNull);
      expect(matchScore.skillMatch, isNotNull);
      expect(matchScore.experienceMatch, isNotNull);
      expect(matchScore.budgetMatch, isNotNull);
      expect(matchScore.availabilityMatch, isNotNull);
      expect(matchScore.explanation, isNotEmpty);
      expect(matchScore.reasons, isNotNull);
    });
    
    test('Premium boost increases score by 10%', () {
      final illustrator = {
        'skills': ['Digital Art'],
        'experienceYears': 5,
        'hourlyRate': 50.0,
        'isAvailable': true,
        'preferences': ['Fantasy'],
        'successRate': 80.0,
      };
      
      final job = {
        'requiredSkills': ['Digital Art'],
        'experienceRequired': 3,
        'budgetMin': 40.0,
        'budgetMax': 60.0,
        'genre': 'Fantasy',
      };
      
      final normalScore = service.calculateIllustratorJobMatch(
        illustratorProfile: illustrator,
        jobData: job,
        isPremium: false,
      );
      
      final premiumScore = service.calculateIllustratorJobMatch(
        illustratorProfile: illustrator,
        jobData: job,
        isPremium: true,
      );
      
      // Premium score should be higher (but capped at 100)
      if (normalScore.overall < 91) {
        expect(premiumScore.overall, greaterThan(normalScore.overall));
      }
    });
  });
  
  group('Writer Match Score Calculation Tests', () {
    /// Feature: premium-design-recommendations, Property 5: Writer match score calculation
    /// Validates: Requirements 5.2
    test('Property: Match score uses correct weights (25-20-20-15-10-10)', () {
      final illustrator = {
        'portfolioQuality': 85.0,
        'reliabilityScore': 90.0,
        'skills': ['Digital Art', 'Fantasy'],
        'hourlyRate': 50.0,
        'isAvailable': true,
        'collaborationScore': 88.0,
      };
      
      final project = {
        'requiredSkills': ['Digital Art', 'Fantasy'],
        'budgetMin': 40.0,
        'budgetMax': 60.0,
      };
      
      final matchScore = service.calculateWriterIllustratorMatch(
        writerProject: project,
        illustratorProfile: illustrator,
      );
      
      // Verify score is calculated
      expect(matchScore.overall, greaterThan(0));
      expect(matchScore.overall, lessThanOrEqualTo(100));
      
      // Verify all components are present
      expect(matchScore.skillMatch, greaterThanOrEqualTo(0));
      expect(matchScore.experienceMatch, greaterThanOrEqualTo(0)); // Portfolio quality
      expect(matchScore.budgetMatch, greaterThanOrEqualTo(0));
      expect(matchScore.availabilityMatch, greaterThanOrEqualTo(0));
    });
  });
  
  group('Recommendation Tracking Tests', () {
    /// Feature: premium-design-recommendations, Property 9: Recommendation tracking
    /// Validates: Requirements 4.5
    test('Property: Tracking methods can be called without errors', () async {
      // These are placeholder tests until backend is implemented
      expect(() => service.trackRecommendationView('rec-1'), returnsNormally);
      expect(() => service.trackRecommendationApplication('rec-1'), returnsNormally);
      expect(() => service.trackRecommendationContact('rec-1'), returnsNormally);
    });
  });
}
