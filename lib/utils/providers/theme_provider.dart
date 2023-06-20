import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkModeOn = false;
  Color primaryColor = const Color(0xFF1E262B);
  Color backgroundPrimaryColor = const Color(0xFFF1F4F8);
  Color backgroundSecondaryColor = const Color(0xFFFFFFFF);
  Color actionButtonColor = const Color(0xFF1E262B);

  // Function used for saving whether application is in dark mode or not
  Future<void> setIsDarkModeOn(bool newIsDarkModeOn) async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    // save to shared preferences
    s.setBool('Is_Dark_Mode_On', newIsDarkModeOn);

    // set isDarkModeOn to saved Bool variable
    isDarkModeOn = s.getBool('Is_Dark_Mode_On')!;
  }

  void checkTheme(bool newIsDarkModeOn) {
    // Checks if newIsDarkModeOn is true
    if (newIsDarkModeOn) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      );
      // If true set theme to dark mode
      primaryColor = const Color(0xFFFFFFFF);
      backgroundPrimaryColor = const Color(0xFF0F0F0F);
      backgroundSecondaryColor = const Color(0xFF1E262B);
      actionButtonColor = const Color(0xFFF1F4F8);

      // Save theme state to shared preferences
      setIsDarkModeOn(newIsDarkModeOn);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFFFFFFF),
        ),
      );
      // If false set theme to light mode
      primaryColor = const Color(0xFF1E262B);
      backgroundPrimaryColor = const Color(0xFFF1F4F8);
      backgroundSecondaryColor = const Color(0xFFFFFFFF);
      actionButtonColor = const Color(0xFF1E262B);

      // Save theme state to shared preferences
      setIsDarkModeOn(newIsDarkModeOn);
    }

    notifyListeners();
  }
}
