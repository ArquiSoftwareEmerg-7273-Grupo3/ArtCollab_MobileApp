# Premium Design & Recommendation System - Design Specification

## Overview

This design document outlines the architecture and implementation details for the premium design system and intelligent recommendation engine. The system provides role-based user experiences with harmonious green color palettes, advanced analytics, and AI-powered matching between writers and illustrators.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Premium    │  │ Recommend.   │  │  Analytics   │  │
│  │  Components  │  │     UI       │  │  Dashboard   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│                    Business Logic                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │    Theme     │  │ Recommend.   │  │  Analytics   │  │
│  │   Manager    │  │   Engine     │  │   Service    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          │
┌─────────────────────────────────────────────────────────┐
│                      Data Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │    User      │  │  Recommend.  │  │  Analytics   │  │
│  │  Repository  │  │  Repository  │  │  Repository  │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
```

### Component Structure

```
lib/
├── core/
│   └── theme/
│       ├── premium_theme.dart          # Theme system
│       └── role_theme_provider.dart    # Role-based theming
├── features/
│   ├── recommendations/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── match_score.dart
│   │   │   │   └── recommendation.dart
│   │   │   ├── repositories/
│   │   │   │   └── recommendation_repository.dart
│   │   │   └── services/
│   │   │       └── recommendation_service.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── job_recommendations_page.dart
│   │       │   └── illustrator_recommendations_page.dart
│   │       └── widgets/
│   │           └── match_score_card.dart
│   ├── analytics/
│   │   ├── data/
│   │   │   └── services/
│   │   │       └── analytics_service.dart
│   │   └── presentation/
│   │       └── pages/
│   │           └── analytics_dashboard_page.dart
│   └── subscription/
│       └── presentation/
│           └── pages/
│               └── subscription_plans_page.dart
└── shared/
    └── widgets/
        ├── premium_card.dart
        ├── animated_button.dart
        ├── stats_card.dart
        └── recommendation_card.dart
```

## Design System

### Color Palette

#### Green Harmony Theme

```dart
// Writer Theme (Darker Greens - Professional)
static const Color writerPrimary = Color(0xFF059669);      // Emerald 600
static const Color writerSecondary = Color(0xFF047857);    // Emerald 700
static const Color writerAccent = Color(0xFF065F46);       // Emerald 800
static const Color writerLight = Color(0xFF10B981);        // Emerald 500

// Illustrator Theme (Lighter Greens - Creative)
static const Color illustratorPrimary = Color(0xFF34D399); // Emerald 400
static const Color illustratorSecondary = Color(0xFF6EE7B7); // Emerald 300
static const Color illustratorAccent = Color(0xFF10B981);  // Emerald 500
static const Color illustratorLight = Color(0xFFA7F3D0);   // Emerald 200

// Premium Colors (Golden accents)
static const Color premiumGold = Color(0xFFFFD700);
static const Color premiumOrange = Color(0xFFFFA500);
static const Color premiumBronze = Color(0xFFCD7F32);

// Neutral Colors
static const Color backgroundLight = Color(0xFFFAFAFA);
static const Color backgroundDark = Color(0xFF0F172A);
static const Color cardBackground = Color(0xFFFFFFFF);
static const Color textPrimary = Color(0xFF1E293B);
static const Color textSecondary = Color(0xFF64748B);
static const Color textTertiary = Color(0xFF94A3B8);
static const Color divider = Color(0xFFE2E8F0);
static const Color success = Color(0xFF10B981);
static const Color warning = Color(0xFFF59E0B);
static const Color error = Color(0xFFEF4444);
```

#### Gradients

```dart
// Writer Gradients
static const LinearGradient writerGradient = LinearGradient(
  colors: [Color(0xFF059669), Color(0xFF047857)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Illustrator Gradients
static const LinearGradient illustratorGradient = LinearGradient(
  colors: [Color(0xFF34D399), Color(0xFF6EE7B7)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// Premium Gradient
static const LinearGradient premiumGradient = LinearGradient(
  colors: [Color(0xFFFFD700), Color(0xFFFFA500), Color(0xFFCD7F32)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
```

### Typography

```dart
static const TextStyle displayLarge = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w800,
  letterSpacing: -0.5,
  height: 1.2,
);

static const TextStyle headlineLarge = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  letterSpacing: -0.25,
  height: 1.3,
);

static const TextStyle titleMedium = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  letterSpacing: 0,
  height: 1.5,
);

static const TextStyle bodyLarge = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
  height: 1.5,
);

static const TextStyle labelLarge = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.1,
  height: 1.4,
);
```

### Spacing & Sizing

```dart
static const double spacingXS = 4.0;
static const double spacingS = 8.0;
static const double spacingM = 16.0;
static const double spacingL = 24.0;
static const double spacingXL = 32.0;
static const double spacingXXL = 48.0;

static const double radiusSmall = 8.0;
static const double radiusMedium = 12.0;
static const double radiusLarge = 16.0;
static const double radiusXLarge = 24.0;
```

## Components and Interfaces

### Premium Card Component

```dart
class PremiumCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool isPremium;
  final bool hasGlow;
  final LinearGradient? gradient;
  
  // Features:
  // - Smooth shadow animations
  // - Scale effect on press
  // - Optional premium badge
  // - Glow effect for premium cards
  // - Customizable gradient backgrounds
}
```

### Animated Button Component

```dart
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isPremium;
  final AnimatedButtonStyle style; // primary, secondary, outline, ghost
  final AnimatedButtonSize size;   // small, medium, large
  
  // Features:
  // - Scale animation on press (0.95)
  // - Shimmer effect for premium buttons
  // - Loading state with spinner
  // - Icon support with animations
  // - Multiple style variants
}
```

### Stats Card Component

```dart
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? trend;          // e.g., "+12%"
  final bool isPositiveTrend;
  
  // Features:
  // - Icon with colored background
  // - Large value display
  // - Trend indicator with arrow
  // - Color-coded trends (green/red)
}
```

### Recommendation Card Component

```dart
class RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double matchScore;      // 0-100
  final String? imageUrl;
  final List<String> tags;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final bool isSaved;
  
  // Features:
  // - Match score badge with color coding
  // - Fire emoji for 90%+ matches
  // - Image preview
  // - Tag chips
  // - Save/bookmark functionality
}
```

## Data Models

### Match Score Model

```dart
class MatchScore {
  final double overall;         // 0-100
  final double skillMatch;      // 0-100
  final double experienceMatch; // 0-100
  final double budgetMatch;     // 0-100
  final double availabilityMatch; // 0-100
  final String explanation;
  final List<String> reasons;
  
  MatchScore({
    required this.overall,
    required this.skillMatch,
    required this.experienceMatch,
    required this.budgetMatch,
    required this.availabilityMatch,
    required this.explanation,
    required this.reasons,
  });
}
```

### Recommendation Model

```dart
class Recommendation {
  final String id;
  final String targetId;        // Job ID or User ID
  final String targetType;      // 'job' or 'illustrator'
  final MatchScore matchScore;
  final Map<String, dynamic> targetData;
  final DateTime createdAt;
  final bool isViewed;
  final bool isApplied;
  
  Recommendation({
    required this.id,
    required this.targetId,
    required this.targetType,
    required this.matchScore,
    required this.targetData,
    required this.createdAt,
    this.isViewed = false,
    this.isApplied = false,
  });
}
```

### Analytics Model

```dart
class UserAnalytics {
  final String userId;
  final int totalApplications;
  final double successRate;      // 0-100
  final int profileViews;
  final double earnings;
  final Map<String, int> applicationsByMonth;
  final List<String> topSkills;
  final List<AnalyticsSuggestion> suggestions;
  
  UserAnalytics({
    required this.userId,
    required this.totalApplications,
    required this.successRate,
    required this.profileViews,
    required this.earnings,
    required this.applicationsByMonth,
    required this.topSkills,
    required this.suggestions,
  });
}

class AnalyticsSuggestion {
  final String title;
  final String description;
  final IconData icon;
  final String actionText;
  
  AnalyticsSuggestion({
    required this.title,
    required this.description,
    required this.icon,
    required this.actionText,
  });
}
```

### Subscription Model

```dart
enum SubscriptionTier {
  free,
  pro,      // $9.99/month
  premium,  // $19.99/month
}

class UserSubscription {
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final bool isActive;
  final List<String> features;
  
  UserSubscription({
    required this.tier,
    this.expiresAt,
    required this.isActive,
    required this.features,
  });
  
  bool get isPremium => tier == SubscriptionTier.premium;
  bool get isPro => tier == SubscriptionTier.pro;
  bool get isFree => tier == SubscriptionTier.free;
}
```


## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system—essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*

### Property 1: Role-based theme application
*For any* user with an assigned role (writer or illustrator), when the application loads, the theme colors should match their role (darker greens for writers, lighter greens for illustrators).
**Validates: Requirements 1.1, 2.2, 3.2**

### Property 2: Profile creation prompt suppression
*For any* user with an assigned role, the system should not display profile creation prompts when accessing profile-related features.
**Validates: Requirements 2.4, 3.4, 8.1**

### Property 3: Match score range validation
*For any* recommendation (job or illustrator), the match score should be between 0 and 100 inclusive.
**Validates: Requirements 4.1, 5.1**

### Property 4: Illustrator match score calculation
*For any* job recommendation for illustrators, the match score should be calculated using the weighted formula: skill_match * 0.30 + experience * 0.20 + availability * 0.15 + budget * 0.15 + preferences * 0.10 + success_probability * 0.10.
**Validates: Requirements 4.2**

### Property 5: Writer match score calculation
*For any* illustrator recommendation for writers, the match score should be calculated using the weighted formula: portfolio_quality * 0.25 + reliability * 0.20 + skill_alignment * 0.20 + budget * 0.15 + availability * 0.10 + collaboration_fit * 0.10.
**Validates: Requirements 5.2**

### Property 6: High match indicator
*For any* recommendation with a match score above 90%, the display should include a fire emoji indicator.
**Validates: Requirements 4.4**

### Property 7: Recommendation completeness
*For any* displayed recommendation, it should contain all required fields: match score, target details, required skills/portfolio, and explanation.
**Validates: Requirements 4.3, 5.3**

### Property 8: Match breakdown completeness
*For any* writer's illustrator recommendation, the match breakdown should display individual scores for style compatibility, budget alignment, and availability.
**Validates: Requirements 5.4**

### Property 9: Recommendation tracking
*For any* user action on a recommendation (apply, contact, view), the system should create a tracking record with timestamp and action type.
**Validates: Requirements 4.5, 5.5, 9.1**

### Property 10: Trend indicator correctness
*For any* analytics metric with a trend value, positive trends should display green color with up arrow, and negative trends should display red color with down arrow.
**Validates: Requirements 6.2**

### Property 11: Analytics suggestions generation
*For any* user analytics with identified improvement opportunities, the system should display actionable suggestions with icons and descriptions.
**Validates: Requirements 6.5**

### Property 12: Premium badge display
*For any* premium user, their profile and content should display golden premium badges and indicators.
**Validates: Requirements 7.2**

### Property 13: Premium match score boost
*For any* premium user, their match scores should be multiplied by 1.10 (10% boost) compared to the base calculation.
**Validates: Requirements 7.3**

### Property 14: Premium priority placement
*For any* list containing both premium and non-premium users, premium users should appear before non-premium users when other factors are equal.
**Validates: Requirements 7.4**

### Property 15: Upgrade prompt display
*For any* free user attempting to access premium-only features, the system should display an upgrade prompt with subscription options.
**Validates: Requirements 7.5**

### Property 16: Profile data persistence
*For any* profile update, the changes should be immediately saved to the backend and reflected in subsequent loads.
**Validates: Requirements 8.2, 8.3**

### Property 17: Profile completion calculation
*For any* user profile, the completion percentage should be calculated as (filled_fields / total_fields) * 100, and suggestions should be shown when percentage < 100.
**Validates: Requirements 8.4**

### Property 18: Analytics event recording
*For any* user interaction (view, apply, contact), the system should record analytics events with user_id, action_type, target_id, and timestamp.
**Validates: Requirements 9.1, 9.2**

### Property 19: Algorithm performance metrics
*For any* recommendation shown, the system should track whether it resulted in an action, allowing calculation of recommendation accuracy = (successful_recommendations / total_recommendations) * 100.
**Validates: Requirements 9.3**

### Property 20: Trend detection
*For any* analytics period, the system should identify trends by comparing current period metrics to previous period and calculating percentage change.
**Validates: Requirements 9.4**

### Property 21: Privacy in aggregation
*For any* aggregated report, the data should not contain personally identifiable information (PII) such as names, emails, or specific user IDs.
**Validates: Requirements 9.5**

## Error Handling

### Theme Loading Errors
- If user role cannot be determined, default to illustrator theme (lighter greens)
- Log error and continue with graceful degradation
- Show notification to user to update profile

### Recommendation Engine Errors
- If match score calculation fails, return score of 0 with error explanation
- If recommendation service is unavailable, show cached recommendations
- Display user-friendly error message: "Unable to load recommendations. Please try again."

### Analytics Errors
- If analytics data cannot be loaded, show placeholder with retry button
- Cache last successful analytics data for offline viewing
- Gracefully handle missing data points in charts

### Subscription Errors
- If subscription status cannot be verified, treat as free tier
- Show warning banner: "Unable to verify subscription status"
- Allow retry with exponential backoff

### Profile Update Errors
- If save fails, keep changes in local state
- Show error snackbar with retry option
- Implement optimistic updates with rollback on failure

## Testing Strategy

### Unit Testing
- Test theme color selection based on user role
- Test match score calculation algorithms with known inputs
- Test profile completion percentage calculation
- Test trend indicator logic (positive/negative)
- Test premium boost calculation
- Test privacy filtering in aggregated reports

### Property-Based Testing
We will use the `faker` package for generating test data and custom generators for domain-specific models.

**Property Test 1: Role-based theme consistency**
- Generate random users with roles
- Verify theme colors match role expectations
- **Validates: Property 1**

**Property Test 2: Match score bounds**
- Generate random recommendation data
- Verify all match scores are 0-100
- **Validates: Property 3**

**Property Test 3: Match score calculation accuracy**
- Generate random skill/experience/budget data
- Calculate expected score manually
- Verify algorithm produces same result
- **Validates: Properties 4, 5**

**Property Test 4: Premium boost application**
- Generate random base scores
- Verify premium users get exactly 10% boost
- **Validates: Property 13**

**Property Test 5: Profile completion accuracy**
- Generate profiles with varying completeness
- Verify percentage calculation is correct
- **Validates: Property 17**

**Property Test 6: Privacy in aggregation**
- Generate user data with PII
- Verify aggregated reports contain no PII
- **Validates: Property 21**

### Integration Testing
- Test complete recommendation flow from API to UI
- Test analytics dashboard with real backend data
- Test subscription upgrade flow
- Test profile update synchronization

### Widget Testing
- Test premium card rendering with different states
- Test animated button interactions
- Test stats card with various metrics
- Test recommendation card with different match scores

## Performance Considerations

### Recommendation Engine
- Cache recommendations for 1 hour to reduce API calls
- Implement pagination for large result sets (20 items per page)
- Use background computation for match score calculations
- Index database queries on user_id and match_score

### Analytics Dashboard
- Lazy load chart data on scroll
- Cache analytics data for 15 minutes
- Use data aggregation on backend to reduce payload size
- Implement progressive loading for historical data

### Theme System
- Cache theme data in memory after first load
- Use const constructors for theme objects
- Minimize theme rebuilds with proper state management

### Animation Performance
- Use `RepaintBoundary` for animated widgets
- Limit simultaneous animations to 3
- Use `AnimatedBuilder` instead of `setState` for animations
- Implement animation disposal in widget lifecycle

## Security Considerations

### Subscription Verification
- Verify subscription status on backend, not client
- Implement JWT token validation for premium features
- Use secure storage for subscription tokens
- Implement subscription expiry checks

### Analytics Privacy
- Anonymize user data in analytics reports
- Implement GDPR-compliant data retention (90 days)
- Allow users to opt-out of analytics tracking
- Encrypt analytics data in transit and at rest

### Recommendation Data
- Validate all input data before match score calculation
- Sanitize user-generated content in recommendations
- Implement rate limiting on recommendation API (100 requests/hour)
- Log suspicious recommendation patterns

## Accessibility

### Color Contrast
- Ensure all text meets WCAG AA standards (4.5:1 ratio)
- Provide high contrast mode option
- Use semantic colors (not just color for meaning)

### Screen Reader Support
- Add semantic labels to all interactive elements
- Provide text alternatives for match score indicators
- Announce analytics updates to screen readers

### Keyboard Navigation
- Ensure all features accessible via keyboard
- Implement focus indicators for all interactive elements
- Support tab navigation through recommendation cards

## Deployment Strategy

### Phased Rollout
1. **Phase 1**: Deploy premium design system to 10% of users
2. **Phase 2**: Deploy recommendation engine to illustrators only
3. **Phase 3**: Deploy recommendation engine to writers
4. **Phase 4**: Deploy analytics dashboard
5. **Phase 5**: Deploy subscription features
6. **Phase 6**: Full rollout to 100% of users

### Feature Flags
- `premium_design_enabled`: Enable new design system
- `recommendations_enabled`: Enable recommendation engine
- `analytics_enabled`: Enable analytics dashboard
- `subscriptions_enabled`: Enable subscription features

### Monitoring
- Track recommendation click-through rates
- Monitor match score distribution
- Track subscription conversion rates
- Monitor API response times
- Track error rates and crash reports

### Rollback Plan
- Keep old design system code for 30 days
- Implement feature flag kill switch
- Maintain database migration rollback scripts
- Document rollback procedures for each phase
