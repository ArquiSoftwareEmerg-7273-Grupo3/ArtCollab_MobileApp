import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/core/theme/role_theme_provider.dart';

/// Feature: premium-design-recommendations, Property 1: Role-based theme consistency
/// Validates: Requirements 1.1, 2.2, 3.2
void main() {
  group('Role-based Theme Tests', () {
    test('Writer role should use darker green colors', () {
      // Arrange
      final roles = ['escritor', 'writer', 'ESCRITOR', 'Writer'];
      
      // Act & Assert
      for (final role in roles) {
        final theme = PremiumTheme.getThemeForRole(role);
        expect(theme.colorScheme.primary, equals(PremiumTheme.writerPrimary));
        expect(theme.colorScheme.secondary, equals(PremiumTheme.writerSecondary));
      }
    });
    
    test('Illustrator role should use lighter green colors', () {
      // Arrange
      final roles = ['ilustrador', 'illustrator', 'ILUSTRADOR', 'Illustrator'];
      
      // Act & Assert
      for (final role in roles) {
        final theme = PremiumTheme.getThemeForRole(role);
        expect(theme.colorScheme.primary, equals(PremiumTheme.illustratorPrimary));
        expect(theme.colorScheme.secondary, equals(PremiumTheme.illustratorSecondary));
      }
    });
    
    test('Property: For any user with assigned role, theme colors should match role', () {
      // Property-based test: Generate various role inputs
      final testCases = [
        {'role': 'escritor', 'expectedPrimary': PremiumTheme.writerPrimary},
        {'role': 'writer', 'expectedPrimary': PremiumTheme.writerPrimary},
        {'role': 'WRITER', 'expectedPrimary': PremiumTheme.writerPrimary},
        {'role': 'ilustrador', 'expectedPrimary': PremiumTheme.illustratorPrimary},
        {'role': 'illustrator', 'expectedPrimary': PremiumTheme.illustratorPrimary},
        {'role': 'ILLUSTRATOR', 'expectedPrimary': PremiumTheme.illustratorPrimary},
      ];
      
      for (final testCase in testCases) {
        final role = testCase['role'] as String;
        final expectedPrimary = testCase['expectedPrimary'] as Color;
        
        final theme = PremiumTheme.getThemeForRole(role);
        
        expect(
          theme.colorScheme.primary,
          equals(expectedPrimary),
          reason: 'Role $role should have correct primary color',
        );
      }
    });
    
    test('RoleThemeProvider should correctly identify writer role', () {
      // Arrange
      final provider = RoleThemeProvider();
      
      // Act
      provider.setUserRole('escritor');
      
      // Assert
      expect(provider.isWriter, isTrue);
      expect(provider.isIllustrator, isFalse);
      expect(provider.primaryColor, equals(PremiumTheme.writerPrimary));
    });
    
    test('RoleThemeProvider should correctly identify illustrator role', () {
      // Arrange
      final provider = RoleThemeProvider();
      
      // Act
      provider.setUserRole('ilustrador');
      
      // Assert
      expect(provider.isIllustrator, isTrue);
      expect(provider.isWriter, isFalse);
      expect(provider.primaryColor, equals(PremiumTheme.illustratorPrimary));
    });
    
    test('Theme should have consistent styling properties', () {
      // Test that both themes have proper configuration
      final writerTheme = PremiumTheme.getThemeForRole('writer');
      final illustratorTheme = PremiumTheme.getThemeForRole('illustrator');
      
      // Both should use Material 3
      expect(writerTheme.useMaterial3, isTrue);
      expect(illustratorTheme.useMaterial3, isTrue);
      
      // Both should have card theme configured
      expect(writerTheme.cardTheme.elevation, equals(0));
      expect(illustratorTheme.cardTheme.elevation, equals(0));
      
      // Both should have proper text theme
      expect(writerTheme.textTheme.displayLarge, isNotNull);
      expect(illustratorTheme.textTheme.displayLarge, isNotNull);
    });
  });
}
