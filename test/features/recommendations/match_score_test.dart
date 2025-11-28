import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/features/recommendations/data/models/match_score.dart';
import 'package:artcollab_mobile/features/recommendations/data/models/recommendation.dart';

/// Feature: premium-design-recommendations, Property 3: Match score range validation
/// Validates: Requirements 4.1, 5.1
void main() {
  group('Match Score Bounds Tests', () {
    test('Property: All match scores should be between 0 and 100', () {
      // Generate various match scores
      final testScores = [
        0.0, 25.0, 50.0, 75.0, 90.0, 95.0, 100.0,
        10.5, 33.3, 66.6, 88.8, 99.9,
      ];
      
      for (final score in testScores) {
        final matchScore = MatchScore(
          overall: score,
          skillMatch: score,
          experienceMatch: score,
          budgetMatch: score,
          availabilityMatch: score,
          explanation: 'Test explanation',
          reasons: ['Test reason'],
        );
        
        expect(matchScore.overall, greaterThanOrEqualTo(0));
        expect(matchScore.overall, lessThanOrEqualTo(100));
        expect(matchScore.skillMatch, greaterThanOrEqualTo(0));
        expect(matchScore.skillMatch, lessThanOrEqualTo(100));
        expect(matchScore.experienceMatch, greaterThanOrEqualTo(0));
        expect(matchScore.experienceMatch, lessThanOrEqualTo(100));
        expect(matchScore.budgetMatch, greaterThanOrEqualTo(0));
        expect(matchScore.budgetMatch, lessThanOrEqualTo(100));
        expect(matchScore.availabilityMatch, greaterThanOrEqualTo(0));
        expect(matchScore.availabilityMatch, lessThanOrEqualTo(100));
      }
    });
    
    test('Match score classification works correctly', () {
      final highMatch = MatchScore(
        overall: 95,
        skillMatch: 90,
        experienceMatch: 95,
        budgetMatch: 100,
        availabilityMatch: 90,
        explanation: 'High match',
        reasons: [],
      );
      
      expect(highMatch.isHighMatch, isTrue);
      expect(highMatch.isMediumMatch, isFalse);
      expect(highMatch.isLowMatch, isFalse);
      
      final mediumMatch = MatchScore(
        overall: 75,
        skillMatch: 70,
        experienceMatch: 80,
        budgetMatch: 75,
        availabilityMatch: 70,
        explanation: 'Medium match',
        reasons: [],
      );
      
      expect(mediumMatch.isHighMatch, isFalse);
      expect(mediumMatch.isMediumMatch, isTrue);
      expect(mediumMatch.isLowMatch, isFalse);
      
      final lowMatch = MatchScore(
        overall: 50,
        skillMatch: 45,
        experienceMatch: 55,
        budgetMatch: 50,
        availabilityMatch: 50,
        explanation: 'Low match',
        reasons: [],
      );
      
      expect(lowMatch.isHighMatch, isFalse);
      expect(lowMatch.isMediumMatch, isFalse);
      expect(lowMatch.isLowMatch, isTrue);
    });
    
    test('Match score serialization preserves bounds', () {
      final original = MatchScore(
        overall: 85.5,
        skillMatch: 90.0,
        experienceMatch: 80.0,
        budgetMatch: 85.0,
        availabilityMatch: 88.0,
        explanation: 'Good match',
        reasons: ['Skill alignment', 'Budget fit'],
      );
      
      final json = original.toJson();
      final deserialized = MatchScore.fromJson(json);
      
      expect(deserialized.overall, equals(original.overall));
      expect(deserialized.overall, greaterThanOrEqualTo(0));
      expect(deserialized.overall, lessThanOrEqualTo(100));
    });
    
    test('Recommendation with match score maintains bounds', () {
      final matchScore = MatchScore(
        overall: 92.0,
        skillMatch: 95.0,
        experienceMatch: 90.0,
        budgetMatch: 88.0,
        availabilityMatch: 93.0,
        explanation: 'Excellent match',
        reasons: ['Perfect skill fit', 'Budget aligned'],
      );
      
      final recommendation = Recommendation(
        id: 'rec-1',
        targetId: 'job-1',
        targetType: 'job',
        matchScore: matchScore,
        targetData: {'title': 'Test Job'},
        createdAt: DateTime.now(),
      );
      
      expect(recommendation.matchScore.overall, greaterThanOrEqualTo(0));
      expect(recommendation.matchScore.overall, lessThanOrEqualTo(100));
    });
  });
}
