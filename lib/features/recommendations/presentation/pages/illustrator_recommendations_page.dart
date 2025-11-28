import 'package:flutter/material.dart';
import 'package:artcollab_mobile/core/theme/premium_theme.dart';
import 'package:artcollab_mobile/shared/widgets/premium_card.dart';
import 'package:artcollab_mobile/shared/widgets/animated_button.dart';
import 'package:artcollab_mobile/features/recommendations/data/services/recommendation_service.dart';

class IllustratorRecommendationsPage extends StatefulWidget {
  const IllustratorRecommendationsPage({super.key});
  
  @override
  State<IllustratorRecommendationsPage> createState() => _IllustratorRecommendationsPageState();
}

class _IllustratorRecommendationsPageState extends State<IllustratorRecommendationsPage> {
  final RecommendationService _recommendationService = RecommendationService();
  bool _isLoading = true;
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }
  
  Future<void> _loadRecommendations() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Top Illustrators for Your Project'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _buildIllustratorsList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(PremiumTheme.spacingL),
      decoration: BoxDecoration(
        gradient: PremiumTheme.writerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(PremiumTheme.radiusXLarge),
          bottomRight: Radius.circular(PremiumTheme.radiusXLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎨 Find Your Perfect Illustrator',
            style: PremiumTheme.headlineMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: PremiumTheme.spacingS),
          Text(
            'Based on: Genre, Style, Budget, and Availability',
            style: PremiumTheme.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Search by name, style, or skill...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(PremiumTheme.radiusMedium),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
  
  Widget _buildIllustratorsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(PremiumTheme.spacingM),
      itemCount: 5, // Mock count
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: PremiumTheme.spacingM),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: PremiumTheme.illustratorPrimary,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: PremiumTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Illustrator Name',
                            style: PremiumTheme.titleMedium,
                          ),
                          Text(
                            'Fantasy & Sci-Fi Specialist',
                            style: PremiumTheme.bodySmall.copyWith(
                              color: PremiumTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        '94% Match',
                        style: PremiumTheme.labelMedium.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PremiumTheme.spacingM),
                Text(
                  '\$50-100/hr | Available Now',
                  style: PremiumTheme.bodyMedium.copyWith(
                    color: PremiumTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: PremiumTheme.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedButton(
                        text: 'View Portfolio',
                        style: AnimatedButtonStyle.outline,
                        size: AnimatedButtonSize.small,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: PremiumTheme.spacingS),
                    Expanded(
                      child: AnimatedButton(
                        text: 'Contact',
                        size: AnimatedButtonSize.small,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
