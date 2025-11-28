import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';
import 'package:artcollab_mobile/features/recommendations/presentation/pages/job_recommendations_page.dart';

class IllustratorDashboardPage extends StatefulWidget {
  const IllustratorDashboardPage({super.key});
  
  @override
  State<IllustratorDashboardPage> createState() => _IllustratorDashboardPageState();
}

class _IllustratorDashboardPageState extends State<IllustratorDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildPortfolioHighlight(),
                _buildJobRecommendations(),
                _buildQuickStats(),
                _buildTrendingStyles(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: PremiumTheme.illustratorGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(PremiumTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome back! 🎨',
                    style: PremiumTheme.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: PremiumTheme.spacingS),
                  Text(
                    'New opportunities await you',
                    style: PremiumTheme.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPortfolioHighlight() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: PremiumCard(
        gradient: PremiumTheme.subtleGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Highlight',
                  style: PremiumTheme.headlineMedium,
                ),
                Icon(
                  Icons.star,
                  color: PremiumTheme.premiumGold,
                ),
              ],
            ),
            const SizedBox(height: PremiumTheme.spacingM),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: PremiumTheme.illustratorPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 60,
                  color: PremiumTheme.illustratorPrimary,
                ),
              ),
            ),
            const SizedBox(height: PremiumTheme.spacingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '156 Views',
                      style: PremiumTheme.titleMedium,
                    ),
                    Text(
                      'This week',
                      style: PremiumTheme.bodySmall.copyWith(
                        color: PremiumTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                AnimatedButton(
                  text: 'View Portfolio',
                  size: AnimatedButtonSize.small,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildJobRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PremiumTheme.spacingM,
            vertical: PremiumTheme.spacingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jobs Perfect for You 🎯',
                style: PremiumTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JobRecommendationsPage(),
                    ),
                  );
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.spacingM),
            itemCount: 5,
            itemBuilder: (context, index) {
              final matchScore = 95 - (index * 3);
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: PremiumTheme.spacingM),
                child: PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$matchScore% Match',
                                  style: PremiumTheme.labelMedium.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (matchScore >= 90) ...[
                                  const SizedBox(width: 4),
                                  const Text('🔥', style: TextStyle(fontSize: 12)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: PremiumTheme.spacingM),
                      Text(
                        'Fantasy Book Cover',
                        style: PremiumTheme.titleMedium,
                      ),
                      const SizedBox(height: PremiumTheme.spacingXS),
                      Text(
                        'Budget: \$500-800 | 2 weeks',
                        style: PremiumTheme.bodySmall.copyWith(
                          color: PremiumTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: PremiumTheme.spacingS),
                      Wrap(
                        spacing: 4,
                        children: ['Digital Art', 'Fantasy'].map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: PremiumTheme.illustratorPrimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                            ),
                            child: Text(
                              tag,
                              style: PremiumTheme.labelSmall.copyWith(
                                color: PremiumTheme.illustratorPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),
                      AnimatedButton(
                        text: 'Apply Now',
                        width: double.infinity,
                        size: AnimatedButtonSize.small,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Performance',
            style: PremiumTheme.headlineMedium,
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Applications',
                  value: '24',
                  icon: Icons.send,
                  color: PremiumTheme.illustratorPrimary,
                  trend: '+12%',
                  isPositiveTrend: true,
                ),
              ),
              const SizedBox(width: PremiumTheme.spacingM),
              Expanded(
                child: StatsCard(
                  title: 'Success Rate',
                  value: '85%',
                  icon: Icons.check_circle,
                  color: PremiumTheme.success,
                  trend: '+5%',
                  isPositiveTrend: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Profile Views',
                  value: '342',
                  icon: Icons.visibility,
                  color: PremiumTheme.illustratorSecondary,
                  trend: '+18%',
                  isPositiveTrend: true,
                ),
              ),
              const SizedBox(width: PremiumTheme.spacingM),
              Expanded(
                child: StatsCard(
                  title: 'Earnings',
                  value: '\$3.2K',
                  icon: Icons.attach_money,
                  color: PremiumTheme.success,
                  subtitle: 'This month',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendingStyles() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: PremiumCard(
        gradient: PremiumTheme.subtleGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: PremiumTheme.success),
                const SizedBox(width: PremiumTheme.spacingS),
                Text(
                  'Trending Styles',
                  style: PremiumTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: PremiumTheme.spacingM),
            Text(
              '💡 Add more fantasy samples to your portfolio',
              style: PremiumTheme.bodyMedium,
            ),
            const SizedBox(height: PremiumTheme.spacingS),
            Text(
              '📈 Digital art demand increased by 25%',
              style: PremiumTheme.bodyMedium,
            ),
            const SizedBox(height: PremiumTheme.spacingS),
            Text(
              '⭐ Your style matches 15 new job postings',
              style: PremiumTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
