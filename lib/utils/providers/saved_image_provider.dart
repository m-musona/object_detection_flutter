import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_v3/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedImageProvider extends ChangeNotifier {
  // Variables
  List<String> imagePaths = [];

  // Function used to get list of image paths from shared preferences
  Future<void> getSavedImages() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    // Checks if list of image paths is not null
    if (s.getStringList('Saved_Image_Paths') != null) {
      // Sets variable imagePaths to list of image paths from shared preferences
      imagePaths = s.getStringList('Saved_Image_Paths')!;

      notifyListeners();
    }
  }

  // Function used to add paths to shared preferences
  Future<void> addSavedImages(String path) async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    // Checks if list of image paths is  null
    if (s.getStringList('Saved_Image_Paths') == null) {
      // Adds path to image path list and saves it to shared preferences
      imagePaths.add(path);
      s.setStringList('Saved_Image_Paths', imagePaths);

      notifyListeners();
    } else {
      /* Sets shared preferences List of Image Paths to imagePaths 
        adds path to imagePaths then saves imagePaths to shared Preferences
      */
      imagePaths = s.getStringList('Saved_Image_Paths')!;
      imagePaths.add(path);
      s.setStringList('Saved_Image_Paths', imagePaths);

      notifyListeners();
    }
  }

  // Function used for saving images with bounding boxes to device
  Future<void> saveImageWithBoundingBoxes(
    BuildContext context,
    GlobalKey globalKey,
  ) async {
    // Get the boundary of the image on the screen and turn it into byte data
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    // Get the directory of the application where user generated content can be stored
    final directory = await getApplicationDocumentsDirectory();
    DateTime now = DateTime.now();
    final path = '${directory.path}/${now.year}${now.month}${now.second}.png';

    // Turn the byte data into a file
    final file = File(path);
    await file.writeAsBytes(byteData!.buffer.asUint8List());

    // Save the image to the gallery of the device
    await ImageGallerySaver.saveFile(path);

    // Add the image path to shared preferences
    addSavedImages(path);
  }
}
