import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';
import 'package:artcollab_mobile/features/recommendations/presentation/pages/illustrator_recommendations_page.dart';

class WriterDashboardPage extends StatefulWidget {
  const WriterDashboardPage({super.key});
  
  @override
  State<WriterDashboardPage> createState() => _WriterDashboardPageState();
}

class _WriterDashboardPageState extends State<WriterDashboardPage> {
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
                _buildQuickStats(),
                _buildRecommendedIllustrators(),
                _buildRecentProjects(),
                _buildTrendingGenres(),
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
            gradient: PremiumTheme.writerGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(PremiumTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Good morning, Writer! 👋',
                    style: PremiumTheme.displayMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: PremiumTheme.spacingS),
                  Text(
                    'Let\'s find your next great illustrator',
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
  
  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: Row(
        children: [
          Expanded(
            child: StatsCard(
              title: 'Active Projects',
              value: '3',
              icon: Icons.work,
              color: PremiumTheme.writerPrimary,
              trend: '+1',
              isPositiveTrend: true,
            ),
          ),
          const SizedBox(width: PremiumTheme.spacingM),
          Expanded(
            child: StatsCard(
              title: 'Applications',
              value: '12',
              icon: Icons.people,
              color: PremiumTheme.writerSecondary,
              trend: '+5',
              isPositiveTrend: true,
            ),
          ),
          const SizedBox(width: PremiumTheme.spacingM),
          Expanded(
            child: StatsCard(
              title: 'Budget Spent',
              value: '\$2.4K',
              icon: Icons.attach_money,
              color: PremiumTheme.success,
              subtitle: 'This month',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecommendedIllustrators() {
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
                'Recommended Illustrators',
                style: PremiumTheme.headlineMedium,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const IllustratorRecommendationsPage(),
                    ),
                  );
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: PremiumTheme.spacingM),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: PremiumTheme.spacingM),
                child: PremiumCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: PremiumTheme.illustratorPrimary,
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(height: PremiumTheme.spacingS),
                      Text(
                        'Illustrator ${index + 1}',
                        style: PremiumTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: PremiumTheme.spacingXS),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                        ),
                        child: Text(
                          '${90 + index}% Match',
                          style: PremiumTheme.labelSmall.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      AnimatedButton(
                        text: 'View',
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
  
  Widget _buildRecentProjects() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Recent Projects',
            style: PremiumTheme.headlineMedium,
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: PremiumTheme.spacingM),
                child: PremiumCard(
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: PremiumTheme.writerPrimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                        ),
                        child: Icon(
                          Icons.book,
                          color: PremiumTheme.writerPrimary,
                        ),
                      ),
                      const SizedBox(width: PremiumTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Project ${index + 1}',
                              style: PremiumTheme.titleMedium,
                            ),
                            const SizedBox(height: PremiumTheme.spacingXS),
                            Text(
                              '5 applications • Active',
                              style: PremiumTheme.bodySmall.copyWith(
                                color: PremiumTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: PremiumTheme.textTertiary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildTrendingGenres() {
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
                  'Trending in Your Genre',
                  style: PremiumTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: PremiumTheme.spacingM),
            Text(
              '📈 Fantasy illustrations are 30% more popular this month',
              style: PremiumTheme.bodyMedium,
            ),
            const SizedBox(height: PremiumTheme.spacingS),
            Text(
              '💡 Average budget for book covers: \$500-800',
              style: PremiumTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
