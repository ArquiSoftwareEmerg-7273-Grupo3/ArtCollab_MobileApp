import 'package:flutter/material.dart';

class UserAnalytics {
  final String userId;
  final int totalApplications;
  final double successRate;
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
  
  factory UserAnalytics.fromJson(Map<String, dynamic> json) {
    return UserAnalytics(
      userId: json['userId'] as String,
      totalApplications: json['totalApplications'] as int,
      successRate: (json['successRate'] as num).toDouble(),
      profileViews: json['profileViews'] as int,
      earnings: (json['earnings'] as num).toDouble(),
      applicationsByMonth: Map<String, int>.from(json['applicationsByMonth'] as Map),
      topSkills: (json['topSkills'] as List<dynamic>).map((e) => e as String).toList(),
      suggestions: (json['suggestions'] as List<dynamic>)
          .map((e) => AnalyticsSuggestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalApplications': totalApplications,
      'successRate': successRate,
      'profileViews': profileViews,
      'earnings': earnings,
      'applicationsByMonth': applicationsByMonth,
      'topSkills': topSkills,
      'suggestions': suggestions.map((s) => s.toJson()).toList(),
    };
  }
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
  
  factory AnalyticsSuggestion.fromJson(Map<String, dynamic> json) {
    return AnalyticsSuggestion(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: IconData(json['iconCode'] as int, fontFamily: 'MaterialIcons'),
      actionText: json['actionText'] as String,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'iconCode': icon.codePoint,
      'actionText': actionText,
    };
  }
}
