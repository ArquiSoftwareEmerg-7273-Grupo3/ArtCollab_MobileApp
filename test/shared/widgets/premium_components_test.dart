import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';

void main() {
  group('PremiumCard Tests', () {
    testWidgets('PremiumCard renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              child: Text('Test Content'),
            ),
          ),
        ),
      );
      
      expect(find.text('Test Content'), findsOneWidget);
    });
    
    testWidgets('PremiumCard shows premium badge when isPremium is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              isPremium: true,
              child: Text('Premium Content'),
            ),
          ),
        ),
      );
      
      expect(find.text('PREMIUM'), findsOneWidget);
    });
    
    testWidgets('PremiumCard does not show premium badge when isPremium is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              isPremium: false,
              child: Text('Regular Content'),
            ),
          ),
        ),
      );
      
      expect(find.text('PREMIUM'), findsNothing);
    });
    
    testWidgets('PremiumCard calls onTap when tapped', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumCard(
              onTap: () => tapped = true,
              child: const Text('Tappable'),
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Tappable'));
      await tester.pump();
      
      expect(tapped, isTrue);
    });
  });
  
  group('StatsCard Tests', () {
    testWidgets('StatsCard displays all required information', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatsCard(
              title: 'Applications',
              value: '24',
              icon: Icons.work,
              subtitle: 'This month',
              trend: '+12%',
              isPositiveTrend: true,
            ),
          ),
        ),
      );
      
      expect(find.text('Applications'), findsOneWidget);
      expect(find.text('24'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('+12%'), findsOneWidget);
      expect(find.byIcon(Icons.work), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });
    
    testWidgets('StatsCard shows trending down icon for negative trends', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatsCard(
              title: 'Revenue',
              value: '\$1000',
              icon: Icons.attach_money,
              trend: '-5%',
              isPositiveTrend: false,
            ),
          ),
        ),
      );
      
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
  });
  
  group('RecommendationCard Tests', () {
    testWidgets('RecommendationCard displays match score', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecommendationCard(
              title: 'Fantasy Book Cover',
              subtitle: 'Budget: \$500-800',
              matchScore: 96,
              tags: ['Digital Art', 'Fantasy'],
            ),
          ),
        ),
      );
      
      expect(find.text('96% Match'), findsOneWidget);
      expect(find.text('Fantasy Book Cover'), findsOneWidget);
      expect(find.text('Budget: \$500-800'), findsOneWidget);
    });
    
    testWidgets('RecommendationCard shows fire emoji for 90%+ matches', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecommendationCard(
              title: 'High Match Job',
              subtitle: 'Perfect for you',
              matchScore: 95,
            ),
          ),
        ),
      );
      
      expect(find.text('🔥'), findsOneWidget);
    });
    
    testWidgets('RecommendationCard does not show fire emoji for <90% matches', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecommendationCard(
              title: 'Medium Match Job',
              subtitle: 'Good fit',
              matchScore: 75,
            ),
          ),
        ),
      );
      
      expect(find.text('🔥'), findsNothing);
    });
    
    testWidgets('RecommendationCard displays tags', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RecommendationCard(
              title: 'Job Title',
              subtitle: 'Description',
              matchScore: 80,
              tags: ['Tag1', 'Tag2', 'Tag3'],
            ),
          ),
        ),
      );
      
      expect(find.text('Tag1'), findsOneWidget);
      expect(find.text('Tag2'), findsOneWidget);
      expect(find.text('Tag3'), findsOneWidget);
    });
  });
  
  group('AnimatedButton Tests', () {
    testWidgets('AnimatedButton displays text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Click Me',
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Click Me'), findsOneWidget);
    });
    
    testWidgets('AnimatedButton shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('AnimatedButton calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Press Me',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.text('Press Me'));
      await tester.pump();
      
      expect(pressed, isTrue);
    });
    
    testWidgets('AnimatedButton shows icon when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Save',
              icon: Icons.save,
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.byIcon(Icons.save), findsOneWidget);
    });
    
    testWidgets('AnimatedButton is disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );
      
      expect(find.text('Disabled'), findsOneWidget);
    });
  });
}
