import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/imagebndbox.dart';
import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/theme_provider.dart';

class CameraDetect extends StatefulWidget {
  const CameraDetect({super.key});

  @override
  State<CameraDetect> createState() => _CameraDetectState();
}

class _CameraDetectState extends State<CameraDetect> {
  CameraController? controller;
  Size? previewSize;

  @override
  void initState() {
    super.initState();

    // Get Detection Provider
    final dp = Provider.of<DetectionProvider>(context, listen: false);

    // Initialize camera controller with camera from detection provider
    controller = CameraController(dp.cameras![0], ResolutionPreset.high);

    controller!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});

      // Start detection with Camera
      dp.detectObjectsOnCamera(controller!);
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // Remove controller from widget tree
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if controller is not initialized or if its null and returns an empty container
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    // Get Screen Size
    Size screen = MediaQuery.of(context).size;

    // Find the Screen Height and Width
    double screenH = math.max(screen.height, screen.width);
    double screenW = math.min(screen.height, screen.width);

    // Get the Camera Controller Preview Size and set set screen as it
    screen = controller!.value.previewSize!;

    // Get the Preview Height and Width
    double previewH = math.max(screen.height, screen.width);
    double previewW = math.min(screen.height, screen.width);

    // Get the ratio of the screen and the preview
    double screenRatio = screenH / screenW;
    double previewRatio = previewH / previewW;

    // Get Detection Provider and Theme Provider
    final dp = Provider.of<DetectionProvider>(context);
    final tp = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: tp.backgroundPrimaryColor,
      body: Stack(
        children: [
          OverflowBox(
            maxHeight: screenRatio > previewRatio
                ? screenH
                : screenW / previewW * previewH,
            maxWidth: screenRatio > previewRatio
                ? screenH / previewH * previewW
                : screenW,
            child: CameraPreview(controller!),
          ),
          ImageBndBox(
            results: dp.cameraResults,
            imageH: screenRatio > previewRatio
                ? screenH
                : screenW / previewW * previewH,
            imageW: screenRatio > previewRatio
                ? screenH / previewH * previewW
                : screenW,
            screenH: screenH,
            screenW: screenW,
          ),
          Positioned(
            left: 20,
            top: 20,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: 30,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
