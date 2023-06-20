// See README.md for documentation
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';

import 'pages/splash_screen.dart';
import 'utils/providers/detection_provider.dart';
import 'utils/providers/saved_image_provider.dart';
import 'utils/providers/theme_provider.dart';

// Creat a variable for list of cameras on device
List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DetectionProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedImageProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      // Get Theme Provider
      child: MaterialApp(
        title: 'Object detection with tflite',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(
          cameras: cameras!,
        ),
      ),
    );
  }
}
