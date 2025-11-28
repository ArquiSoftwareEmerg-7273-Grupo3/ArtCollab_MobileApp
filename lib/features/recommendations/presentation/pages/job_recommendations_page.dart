import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';
import 'package:artcollab_mobile/features/recommendations/data/services/recommendation_service.dart';
import 'package:artcollab_mobile/features/recommendations/data/models/recommendation.dart';

class JobRecommendationsPage extends StatefulWidget {
  const JobRecommendationsPage({super.key});
  
  @override
  State<JobRecommendationsPage> createState() => _JobRecommendationsPageState();
}

class _JobRecommendationsPageState extends State<JobRecommendationsPage> {
  final RecommendationService _recommendationService = RecommendationService();
  List<Recommendation> _recommendations = [];
  bool _isLoading = true;
  String _selectedStyle = 'All';
  String _selectedBudget = 'All';
  String _selectedTime = 'All';
  
  final List<String> _styles = ['All', 'Digital Art', 'Traditional', 'Fantasy', 'Sci-Fi', 'Realistic'];
  final List<String> _budgets = ['All', '\$0-500', '\$500-1000', '\$1000-2000', '\$2000+'];
  final List<String> _times = ['All', '< 1 week', '1-2 weeks', '2-4 weeks', '1+ month'];
  
  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }
  
  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);
    
    // TODO: Load from API
    // Simulated data for now
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _recommendations = _generateMockRecommendations();
      _isLoading = false;
    });
  }
  
  List<Recommendation> _generateMockRecommendations() {
    // Mock data - replace with actual API call
    return [];
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Perfect Matches for You'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _recommendations.isEmpty
                    ? _buildEmptyState()
                    : _buildRecommendationsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(PremiumTheme.spacingL),
      decoration: BoxDecoration(
        gradient: PremiumTheme.illustratorGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(PremiumTheme.radiusXLarge),
          bottomRight: Radius.circular(PremiumTheme.radiusXLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎯 AI-Powered Job Matching',
            style: PremiumTheme.headlineMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: PremiumTheme.spacingS),
          Text(
            'We analyze your skills, portfolio, and preferences to find the perfect opportunities',
            style: PremiumTheme.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Style', _selectedStyle, _styles, (value) {
              setState(() => _selectedStyle = value);
            }),
            const SizedBox(width: PremiumTheme.spacingS),
            _buildFilterChip('Budget', _selectedBudget, _budgets, (value) {
              setState(() => _selectedBudget = value);
            }),
            const SizedBox(width: PremiumTheme.spacingS),
            _buildFilterChip('Timeline', _selectedTime, _times, (value) {
              setState(() => _selectedTime = value);
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFilterChip(
    String label,
    String selected,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (context) => options.map((option) {
        return PopupMenuItem(
          value: option,
          child: Text(option),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PremiumTheme.spacingM,
          vertical: PremiumTheme.spacingS,
        ),
        decoration: BoxDecoration(
          color: selected != options.first
              ? PremiumTheme.illustratorPrimary.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: selected != options.first
                ? PremiumTheme.illustratorPrimary
                : PremiumTheme.divider,
          ),
          borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $selected',
              style: PremiumTheme.labelMedium.copyWith(
                color: selected != options.first
                    ? PremiumTheme.illustratorPrimary
                    : PremiumTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 20,
              color: selected != options.first
                  ? PremiumTheme.illustratorPrimary
                  : PremiumTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: PremiumTheme.spacingM),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: PremiumTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                  ),
                ),
                const SizedBox(height: PremiumTheme.spacingM),
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: PremiumTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(PremiumTheme.radiusSmall),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: PremiumTheme.textTertiary,
          ),
          const SizedBox(height: PremiumTheme.spacingL),
          Text(
            'No recommendations yet',
            style: PremiumTheme.headlineMedium.copyWith(
              color: PremiumTheme.textPrimary,
            ),
          ),
          const SizedBox(height: PremiumTheme.spacingS),
          Text(
            'Complete your profile to get personalized job matches',
            style: PremiumTheme.bodyMedium.copyWith(
              color: PremiumTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PremiumTheme.spacingL),
          AnimatedButton(
            text: 'Complete Profile',
            icon: Icons.person,
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecommendationsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      itemCount: _recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = _recommendations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: PremiumTheme.spacingM),
          child: RecommendationCard(
            title: recommendation.targetData['title'] ?? 'Job Title',
            subtitle: recommendation.targetData['description'] ?? 'Description',
            matchScore: recommendation.matchScore.overall,
            imageUrl: recommendation.targetData['imageUrl'],
            tags: (recommendation.targetData['tags'] as List?)?.cast<String>() ?? [],
            onTap: () {
              _recommendationService.trackRecommendationView(recommendation.id);
              // Navigate to job detail
            },
            onSave: () {
              // Save recommendation
            },
          ),
        );
      },
    );
  }
}
