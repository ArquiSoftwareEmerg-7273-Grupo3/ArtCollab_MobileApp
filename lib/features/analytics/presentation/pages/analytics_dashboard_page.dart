import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});
  
  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  String _selectedPeriod = '30D';
  final List<String> _periods = ['7D', '30D', '90D', '1Y'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Your Performance'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PremiumTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSelector(),
            const SizedBox(height: PremiumTheme.spacingL),
            _buildKeyMetrics(),
            const SizedBox(height: PremiumTheme.spacingL),
            _buildImprovementSuggestions(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPeriodSelector() {
    return Row(
      children: _periods.map((period) {
        final isSelected = period == _selectedPeriod;
        return Padding(
          padding: const EdgeInsets.only(right: PremiumTheme.spacingS),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPeriod = period),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: PremiumTheme.spacingM,
                vertical: PremiumTheme.spacingS,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? PremiumTheme.illustratorPrimary
                    : Colors.white,
                borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
                border: Border.all(
                  color: isSelected
                      ? PremiumTheme.illustratorPrimary
                      : PremiumTheme.divider,
                ),
              ),
              child: Text(
                period,
                style: PremiumTheme.labelLarge.copyWith(
                  color: isSelected ? Colors.white : PremiumTheme.textPrimary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  Widget _buildKeyMetrics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
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
                title: 'Earnings',
                value: '\$2.4K',
                icon: Icons.attach_money,
                trend: '+18%',
                isPositiveTrend: true,
              ),
            ),
            const SizedBox(width: PremiumTheme.spacingM),
            Expanded(
              child: StatsCard(
                title: 'Rating',
                value: '4.9',
                icon: Icons.star,
                subtitle: 'Average',
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildImprovementSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Improvement Suggestions',
          style: PremiumTheme.headlineMedium,
        ),
        const SizedBox(height: PremiumTheme.spacingM),
        PremiumCard(
          child: Column(
            children: [
              _buildSuggestionItem(
                Icons.lightbulb,
                'Add more fantasy samples',
                'Your fantasy work gets 40% more views',
              ),
              const Divider(),
              _buildSuggestionItem(
                Icons.trending_up,
                'Optimize your pricing',
                'Similar profiles charge 15% more',
              ),
              const Divider(),
              _buildSuggestionItem(
                Icons.schedule,
                'Respond faster',
                'Quick responses increase success by 25%',
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildSuggestionItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PremiumTheme.spacingS),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(PremiumTheme.spacingS),
            decoration: BoxDecoration(
              color: PremiumTheme.illustratorPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
            ),
            child: Icon(
              icon,
              color: PremiumTheme.illustratorPrimary,
            ),
          ),
          const SizedBox(width: PremiumTheme.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: PremiumTheme.titleMedium,
                ),
                Text(
                  description,
                  style: PremiumTheme.bodySmall.copyWith(
                    color: PremiumTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
