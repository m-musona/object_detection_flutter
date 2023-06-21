# Flutter Object Detection App Documentation

## Overview

The Flutter Object Detection App is a mobile application that enables users to perform object detection on images or real-time camera feeds using their smartphones or tablets. It leverages machine learning models to accurately detect and classify objects within the provided input.

## Packages and Usage

1. camera - Package used for real time detection by getting List of cameras on device and splitting camera feed into frames.
2. flutter_staggered_grid_view - Package used for displaying images in a staggered grid after detecting or saving.
3. flutter_tflite - Package used to load Tflite models and use them to detect objects on images and frames.
4. font_awesome_flutter - Package used to get specific icons from the font awsome library.
5. image_gallery_saver_v3 - Package used to save detected images with bounding boxes on them to gallery.
6. image_picker - Package used to get images saved on device.
7. intl - Package used to format date on home item widget to desired format.
8. path_provider - Package used to get device path to save images to.
9. provider - Package used for state management in the widget tree.
10. shared_preferences - Package used to save variables to device

## Features

1. Object Detection: The app can identify and locate objects within images or real-time camera feeds, providing bounding boxes around each detected object.

2. Classification: In addition to detection, the app can classify the detected objects into predefined categories, such as car, person, or dog.

3. Camera Input: The app allows users to capture images or use the device's camera feed as the input source for object detection Using the camera package.

4. Image Selection: Users can select images from the device's gallery or file system for object detection.

5. Real-time Detection: When using the camera input, the app performs object detection and classification in real-time, enabling users to view and analyze the content as it happens.

6. User-friendly Interface: The app provides an intuitive and visually appealing user interface for interacting with the application and viewing the detection results.

## Made on System with

- Flutter SDK: version 3.10.5
- Dart SDK: version 3.0.5

## System Requirements

- Android Studio or Vscode (for running the app on a physical device or emulator)
- Internet connectivity (for downloading required packages and models)

## Installation

1. Install Flutter by following the official installation guide: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
   - You may need to install Android Studio for the latest command line tools [Instructions for downloading command line tools](https://developer.android.com/tools)
   - You may also need to accept the licences by running the following command in the terminal:

   ```
   flutter doctor --android-licenses
   ```

2. Unzip the zip file

3. Navigate to the folder containing the unziped Files:

4. Fetch the project dependencies by running the following command in the terminal:

   ```
   flutter pub get
   ```

5. Launch the app on a physical device or emulator:

   ```
   flutter run
   ```

## Usage

1. Launch the Object Detection Flutter App on your physical device or emulator.

2. Grant the necessary permissions to access the camera and photo gallery when prompted.

3. Choose the desired detection type: camera or gallery.

4. If using the camera, the app will display the camera feed. Point the camera at the objects you want to detect.

5. If using the gallery, you can browse and select an image from the available options.

6. Once an image or camera feed is provided, the app will perform object detection and display bounding boxes around the detected objects.

7. Explore the detection results and interact with the app's interface to view the objects and their details.

8. To detect objects in a new image or camera frame, use the provided controls to switch the input source or capture a new photo.

9. To exit the app, use the device's back or home button or close the emulator.

## Configuration with Custom Tflite Model

In the `assets` directory.

- Add a custom model.
- Add labels for model.

In the `models.dart` located in the `lib\constants` directory.

- Add a custom model name in that file.

In the `detection_provider.dart` located in the `lib\utils\providers` directory.

- Add a custom model to `loadModel` function.
- Restructure code according to your needs and model.

In the `settings_page.dart` located in the `lib\pages` directory.

- Add a another `SettingsListItem` widget.
- `title` should be the model name saved in the `models.dart` file.
- `switchStatus` should be `dp.model == model name`
- `themeItem` should be `false`
- On `switchFunction` in the function at the end it should have your model name

Feel free to modify these parameters based on your specific requirements and update the app accordingly.

## Troubleshooting

If you encounter any issues while installing or running the app, please refer to the official Flutter documentation for troubleshooting guidance: [Flutter Troubleshooting](https://flutter.dev/docs/resources/faq)

Additionally, you can seek help from the Flutter community forums and resources for assistance in resolving any problems you may encounter during the app development process.

If you encounter error `Target URI does not exist: 'package:packageName/packageName.dart'` run the command:

```
flutter pub get
```
