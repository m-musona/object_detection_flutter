import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/models.dart';
import 'home.dart';
import '../utils/providers/saved_image_provider.dart';
import '../utils/providers/theme_provider.dart';
import '../utils/providers/detection_provider.dart';

class SplashScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateFromSplash();
  }

  Future<void> _navigateFromSplash() async {
    // Get Detection Provider, SavedImageProvider  and Theme Provider
    final sip = Provider.of<SavedImageProvider>(context, listen: false);
    final tp = Provider.of<ThemeProvider>(context, listen: false);
    final dp = Provider.of<DetectionProvider>(context, listen: false);

    // Check Theme in shared preferences and set theme
    final SharedPreferences s = await SharedPreferences.getInstance();
    if (s.getBool('Is_Dark_Mode_On') != null) {
      tp.checkTheme(s.getBool('Is_Dark_Mode_On')!);
    } else {
      tp.checkTheme(false);
    }

    // Check Model saved in shared preferences and set model
    if (s.getString('Model') != null) {
      await dp.changeModel(s.getString('Model')!);
    } else {
      await dp.changeModel(yolov2);
    }

    // Perform functions that have to be at the start of the application
    dp.addCameras(widget.cameras);
    await dp.getOrResetDateAndVariable();
    await sip.getSavedImages();

    // how long the splash screen is their for
    await Future.delayed(const Duration(milliseconds: 1000), () {});

    changePage();
  }

  // Function to change page after splash is done
  void changePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E262B),
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Image.asset(
            'assets/logo-color.png',
          ),
        ),
      ),
    );
  }
}
