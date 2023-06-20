import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/models.dart';

class DetectionProvider extends ChangeNotifier {
  // Camera Detect Variables
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  DateTime? resetCameraDate;
  bool isCameraDetecting = false;
  int timesCameraUsed = 0;
  List<dynamic> cameraResults = [];

  // Image Detect Variables
  DateTime? resetImageDate;
  List<XFile>? imageFileList;
  bool isImageDetecting = false;
  int imagesDetected = 0;
  int? temporaryImagesDetected;
  double? progress;
  int? objectsDetected;
  List<List<dynamic>> imageResults = [];
  List<double> imageHeights = [];
  List<double> imageWidths = [];
  int? totalSteps;
  dynamic pickImageError;
  ImagePicker picker = ImagePicker();

  // General Variables
  String? model;
  DateTime now = DateTime.now();

  // Function used to change model Used For object Detection
  Future<void> changeModel(String newModel) async {
    SharedPreferences s = await SharedPreferences.getInstance();
    model = newModel;
    // Set model in shared preferences to chosen model
    s.setString('Model', model!);
    imageFileList = [];
    notifyListeners();
  }

  // Function used to add Cameras Available to device into a List of Cameras
  void addCameras(List<CameraDescription> listOfCameras) {
    cameras = listOfCameras;
    notifyListeners();
  }

  /* Function used to get the height and width of images and Adds them to 
  the Lists imageHeights and imageWidths */
  Future<void> getImageHeightAndWidth(XFile image) async {
    // Takes image XFile path converts it to File then makes file ui image
    Image images = Image.file(
      File(image.path),
    );
    Completer<ui.Image> completer = Completer<ui.Image>();
    images.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      }),
    );

    // Gets the width and height from the ui image
    ui.Image myImage = await completer.future;
    double width = myImage.width.toDouble();
    double height = myImage.height.toDouble();

    // Adds image height to imageHeights List and imageWidths List
    imageHeights.add(height);
    imageWidths.add(width);
  }

  // Function used to load The Tflite model and labels fromm assets folder
  Future<void> loadModel(String model) async {
    String res;

    // Loads model and label for a specific model in the model variable
    switch (model) {
      // Loads yolov2 model
      case yolov2:
        res = (await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        ))!;
        break;

      // Loads Mobile Net Model
      case mobilenet:
        res = (await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt"))!;
        break;

      // Loads Pose Net Model
      // Pose Net Does not need labels file
      case posenet:
        res = (await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite"))!;
        break;

      // If Model is not chosen or specified loads SSD Mobile Net model
      default:
        res = (await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt"))!;
    }

    // Logs the result of the model in the console
    print('Load Model : $res');
  }

  /* Function used to Set the ResetCameraDate to 7 days from now and adds 1 
  to the timesCameraUsed Variable then saves both to Shared Preferences*/
  Future<void> setResetCameraDate() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    // Saves the Date into shared preferences and changes resetCameraDate variable
    await s.setString('Camera_Reset_Date',
        now.add(const Duration(days: 7)).toIso8601String());
    resetCameraDate = now.add(const Duration(days: 7));

    // Adds 1 to the timesCameraUsed variable and saves it to shared preferences
    timesCameraUsed = timesCameraUsed + 1;
    await s.setInt('Camera_Detected_Number', timesCameraUsed);
    notifyListeners();
  }

  /* Function used to Set The ResetImageDate to 7 days from now and saves 
  ResetImageDate and imagesDetect in Shared Preferences */
  Future<void> setResetImageDate() async {
    final SharedPreferences s = await SharedPreferences.getInstance();

    // Saves the Date into shared preferences and changes resetImageDate variable
    await s.setString(
        'Image_Reset_Date', now.add(const Duration(days: 7)).toIso8601String());
    resetImageDate = now.add(const Duration(days: 7));

    // Saves the imagesDetected variable to shared preferences
    await s.setInt('Images_Detected_Number', imagesDetected);
    notifyListeners();
  }

  /* Function used to get date and saved variables from shared preferences and 
  It resets the date and variables if now is 7 days past the saved date */
  Future<void> getOrResetDateAndVariable() async {
    SharedPreferences s = await SharedPreferences.getInstance();

    // Checks if image reset date in shared preferences is not null
    if (s.getString('Image_Reset_Date') != null) {
      // Makes resetImageDate the image reset date in shared preferences
      resetImageDate = DateTime.parse(s.getString('Image_Reset_Date')!);

      // Checks if the now date is after the resetImageDate
      if (now.isAfter(resetImageDate!)) {
        // Reset the variable since 7 days have passed
        resetImageDate = null;
        imagesDetected = 0;
      } else {
        // Checks if number of images Detected in shared preferences is not null
        if (s.getInt('Images_Detected_Number') != null) {
          // Sets imagesDetected to number of images Detected in shared preferences
          imagesDetected = s.getInt('Images_Detected_Number')!;
        } else {
          // If not it is equal to 0
          imagesDetected = 0;
        }
      }
    }

    // Checks if camera reset date in shared preferences is not null
    if (s.getString('Camera_Reset_Date') != null) {
      // Makes resetImageDate the image reset date in shared preferences
      resetCameraDate = DateTime.parse(s.getString('Camera_Reset_Date')!);

      // Checks if the now date is after the resetCameraDate
      if (now.isAfter(resetCameraDate!)) {
        // Reset the variable since 7 days have passed
        resetCameraDate = null;
        timesCameraUsed = 0;
      } else {
        // Checks if number of times camera detected in shared preferences is not null
        if (s.getInt('Camera_Detected_Number') != null) {
          // Sets timesCameraUsed to number of times camera detected in shared preferences
          timesCameraUsed = s.getInt('Camera_Detected_Number')!;
        } else {
          // If not it is equal to 0
          timesCameraUsed = 0;
        }
      }
    }

    notifyListeners();
  }

  // Function used to detect objects using the camera
  Future<void> detectObjectsOnCamera(CameraController controller) async {
    // Load model and reset camera date
    loadModel(model!);
    setResetCameraDate();

    // Starts the image stream for the camera and gets frame as img
    controller.startImageStream((CameraImage img) async {
      // Checks if camera model is already detecting
      if (!isCameraDetecting) {
        isCameraDetecting = true;

        int startTime = DateTime.now().millisecondsSinceEpoch;
        print('Detection Started');

        // Check model and and run process for specific model
        if (model == mobilenet) {
          Tflite.runModelOnFrame(
            // Turns frame into byte list
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 2,
          ).then((recognitions) {
            int endTime = DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            // adds results to cameraResults
            cameraResults = recognitions!;

            print('Camera Recognitions: $recognitions');
            isCameraDetecting = false;
            notifyListeners();
          });
        } else if (model == posenet) {
          Tflite.runPoseNetOnFrame(
            // Turns frame into byte list
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: img.height,
            imageWidth: img.width,
            numResults: 2,
          ).then((recognitions) {
            int endTime = DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            // adds results to cameraResults
            cameraResults = recognitions!;

            print('Camera Recognitions: $recognitions');
            isCameraDetecting = false;
            notifyListeners();
          });
        } else {
          Tflite.detectObjectOnFrame(
            // Turns frame into byte list
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            model: model == yolov2 ? "YOLO" : "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: model == yolov2 ? 0 : 127.5,
            imageStd: model == yolov2 ? 255.0 : 127.5,
            numResultsPerClass: 1,
            threshold: model == yolov2 ? 0.2 : 0.4,
          ).then((recognitions) {
            int endTime = DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            // adds results to cameraResults
            cameraResults = recognitions!;

            isCameraDetecting = false;

            notifyListeners();
          });
        }
      }
    });
  }

  // Function used to detect objects on a list of images
  Future<void> detectObjectsOnImage() async {
    // Checks if list of images is null
    if (imageFileList == null) {
      print('No Image is found');
    } else {
      // Checks if image model is already detecting
      if (!isImageDetecting) {
        isImageDetecting = true;
        // Load model and reset image date
        loadModel(model!);

        int startTime = DateTime.now().millisecondsSinceEpoch;
        print('Detection Started');

        // Check model and and run process for specific model
        if (model == mobilenet) {
          // Go through each image in list and detect objects on them
          for (XFile image in imageFileList!) {
            await getImageHeightAndWidth(image);
            List<dynamic>? recognitions = await Tflite.runModelOnImage(
              path: image.path,
              numResults: 2,
            );

            // Set image detection variables
            temporaryImagesDetected = temporaryImagesDetected! + 1;
            progress = progress! + 1;
            objectsDetected = objectsDetected! + recognitions!.length;
            imageResults.add(recognitions);

            notifyListeners();
          }

          // Set image detection variables
          imagesDetected = imagesDetected + temporaryImagesDetected!;
          isImageDetecting = false;
          int endTime = DateTime.now().millisecondsSinceEpoch;

          // Reset image date and update variables
          setResetImageDate();

          print("Detection took ${endTime - startTime}");
        } else if (model == posenet) {
          // Go through each image in list and detect objects on them
          for (XFile image in imageFileList!) {
            await getImageHeightAndWidth(image);
            List<dynamic>? recognitions = await Tflite.runPoseNetOnImage(
              path: image.path,
              numResults: 2,
            );

            // Set image detection variables

            temporaryImagesDetected = temporaryImagesDetected! + 1;
            progress = progress! + 1;
            objectsDetected = objectsDetected! + recognitions!.length;
            imageResults.add(recognitions);

            notifyListeners();
          }

          // Set image detection variables
          imagesDetected = imagesDetected + temporaryImagesDetected!;
          isImageDetecting = false;
          int endTime = DateTime.now().millisecondsSinceEpoch;

          // Reset image date and update variables
          setResetImageDate();

          print("Detection took ${endTime - startTime}");
        } else {
          // Go through each image in list and detect objects on them
          for (XFile image in imageFileList!) {
            await getImageHeightAndWidth(image);
            List<dynamic>? recognitions = await Tflite.detectObjectOnImage(
              path: image.path,
              model: model == yolov2 ? "YOLO" : "SSDMobileNet",
              imageMean: model == yolov2 ? 0 : 127.5,
              imageStd: model == yolov2 ? 255.0 : 127.5,
              numResultsPerClass: 1,
              threshold: model == yolov2 ? 0.2 : 0.4,
            );

            // Set image detection variables
            temporaryImagesDetected = temporaryImagesDetected! + 1;
            progress = progress! + 1;
            objectsDetected = objectsDetected! + recognitions!.length;
            imageResults.add(recognitions);

            notifyListeners();
          }

          // Set image detection variables
          imagesDetected = imagesDetected + temporaryImagesDetected!;
          isImageDetecting = false;
          int endTime = DateTime.now().millisecondsSinceEpoch;

          // Reset image date and update variables
          setResetImageDate();

          print("Detection took ${endTime - startTime}");
        }
        // Closes the tflite model
        Tflite.close();
      }
    }
  }

  // Function used to initialize image detection
  Future<void> detectButtonPressed(
    ImageSource source,
    BuildContext? context,
  ) async {
    try {
      // Update image variables
      final List<XFile> pickedFileList = await picker.pickMultiImage();
      imageFileList = pickedFileList;
      imageResults = [];
      imageHeights = [];
      imageWidths = [];
      temporaryImagesDetected = 0;
      progress = 0.0;
      objectsDetected = 0;
      totalSteps = imageFileList!.length;
      notifyListeners();

      // Start detection
      detectObjectsOnImage();
    } catch (e) {
      // Print errors on console
      print('Pick Image Error $e');

      // set pickImageError to e
      pickImageError = e;
    }
  }
}
