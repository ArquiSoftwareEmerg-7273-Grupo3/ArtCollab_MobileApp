import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';

class SubscriptionPlansPage extends StatefulWidget {
  const SubscriptionPlansPage({super.key});
  
  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  bool _isYearly = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Choose Your Plan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(PremiumTheme.spacingM),
        child: Column(
          children: [
            _buildToggle(),
            const SizedBox(height: PremiumTheme.spacingL),
            _buildFreePlan(),
            const SizedBox(height: PremiumTheme.spacingM),
            _buildProPlan(),
            const SizedBox(height: PremiumTheme.spacingM),
            _buildPremiumPlan(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: PremiumTheme.spacingM),
                decoration: BoxDecoration(
                  color: !_isYearly ? PremiumTheme.illustratorPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Text(
                  'Monthly',
                  textAlign: TextAlign.center,
                  style: PremiumTheme.labelLarge.copyWith(
                    color: !_isYearly ? Colors.white : PremiumTheme.textPrimary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isYearly = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: PremiumTheme.spacingM),
                decoration: BoxDecoration(
                  color: _isYearly ? PremiumTheme.illustratorPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Column(
                  children: [
                    Text(
                      'Yearly',
                      textAlign: TextAlign.center,
                      style: PremiumTheme.labelLarge.copyWith(
                        color: _isYearly ? Colors.white : PremiumTheme.textPrimary,
                      ),
                    ),
                    Text(
                      'Save 20%',
                      style: PremiumTheme.labelSmall.copyWith(
                        color: _isYearly ? Colors.white : PremiumTheme.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFreePlan() {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Free', style: PremiumTheme.headlineMedium),
          const SizedBox(height: PremiumTheme.spacingS),
          Text(
            '\$0',
            style: PremiumTheme.displayLarge.copyWith(
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          _buildFeature('Basic job search'),
          _buildFeature('Limited applications (5/month)'),
          _buildFeature('Standard profile'),
          _buildFeature('Basic recommendations'),
          const SizedBox(height: PremiumTheme.spacingM),
          AnimatedButton(
            text: 'Current Plan',
            width: double.infinity,
            style: AnimatedButtonStyle.outline,
            onPressed: null,
          ),
        ],
      ),
    );
  }
  
  Widget _buildProPlan() {
    final price = _isYearly ? '\$95.88' : '\$9.99';
    final period = _isYearly ? '/year' : '/month';
    
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pro', style: PremiumTheme.headlineMedium),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: PremiumTheme.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                ),
                child: Text(
                  'POPULAR',
                  style: PremiumTheme.labelSmall.copyWith(
                    color: PremiumTheme.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: PremiumTheme.displayLarge.copyWith(
                  color: PremiumTheme.textPrimary,
                ),
              ),
              Text(
                period,
                style: PremiumTheme.bodyMedium.copyWith(
                  color: PremiumTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          _buildFeature('Unlimited applications'),
          _buildFeature('Advanced search filters'),
          _buildFeature('Priority in recommendations'),
          _buildFeature('Analytics dashboard'),
          _buildFeature('Premium profile badges'),
          const SizedBox(height: PremiumTheme.spacingM),
          AnimatedButton(
            text: 'Upgrade to Pro',
            width: double.infinity,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildPremiumPlan() {
    final price = _isYearly ? '\$191.88' : '\$19.99';
    final period = _isYearly ? '/year' : '/month';
    
    return PremiumCard(
      isPremium: true,
      hasGlow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Premium', style: PremiumTheme.headlineMedium),
          const SizedBox(height: PremiumTheme.spacingS),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: PremiumTheme.displayLarge.copyWith(
                  color: PremiumTheme.textPrimary,
                ),
              ),
              Text(
                period,
                style: PremiumTheme.bodyMedium.copyWith(
                  color: PremiumTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: PremiumTheme.spacingM),
          _buildFeature('All Pro features'),
          _buildFeature('AI-powered insights'),
          _buildFeature('Direct messaging'),
          _buildFeature('Featured profile placement'),
          _buildFeature('Custom portfolio themes'),
          _buildFeature('Advanced analytics'),
          const SizedBox(height: PremiumTheme.spacingM),
          AnimatedButton(
            text: 'Upgrade to Premium',
            width: double.infinity,
            isPremium: true,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PremiumTheme.spacingS),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 20,
            color: PremiumTheme.success,
          ),
          const SizedBox(width: PremiumTheme.spacingS),
          Expanded(
            child: Text(
              text,
              style: PremiumTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
