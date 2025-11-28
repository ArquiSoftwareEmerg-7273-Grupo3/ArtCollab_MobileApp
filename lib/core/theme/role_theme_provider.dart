import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'premium_theme.dart';

/// Provider for managing role-based theming
class RoleThemeProvider extends ChangeNotifier {
  String _userRole = 'illustrator';
  ThemeData _themeData = PremiumTheme.getThemeForRole('illustrator');
  
  String get userRole => _userRole;
  ThemeData get themeData => _themeData;
  
  Color get primaryColor {
    return _userRole.toLowerCase() == 'escritor' || _userRole.toLowerCase() == 'writer'
        ? PremiumTheme.writerPrimary
        : PremiumTheme.illustratorPrimary;
  }
  
  Color get secondaryColor {
    return _userRole.toLowerCase() == 'escritor' || _userRole.toLowerCase() == 'writer'
        ? PremiumTheme.writerSecondary
        : PremiumTheme.illustratorSecondary;
  }
  
  LinearGradient get gradient {
    return _userRole.toLowerCase() == 'escritor' || _userRole.toLowerCase() == 'writer'
        ? PremiumTheme.writerGradient
        : PremiumTheme.illustratorGradient;
  }
  
  bool get isWriter {
    return _userRole.toLowerCase() == 'escritor' || _userRole.toLowerCase() == 'writer';
  }
  
  bool get isIllustrator {
    return _userRole.toLowerCase() == 'ilustrador' || _userRole.toLowerCase() == 'illustrator';
  }
  
  /// Initialize theme from stored user role
  Future<void> initializeTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedRole = prefs.getString('user_role');
      
      if (storedRole != null && storedRole.isNotEmpty) {
        _userRole = storedRole;
        _themeData = PremiumTheme.getThemeForRole(_userRole);
        notifyListeners();
      }
    } catch (e) {
      // Default to illustrator theme on error
      _userRole = 'illustrator';
      _themeData = PremiumTheme.getThemeForRole('illustrator');
    }
  }
  
  /// Update theme based on user role
  Future<void> setUserRole(String role) async {
    if (role.isEmpty) return;
    
    _userRole = role;
    _themeData = PremiumTheme.getThemeForRole(role);
    
    // Save to preferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);
    } catch (e) {
      // Handle error silently
    }
    
    notifyListeners();
  }
}
