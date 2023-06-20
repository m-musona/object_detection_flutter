import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/theme_provider.dart';
import '../../widgets/imageDetection/detected_image.dart';
import '../../widgets/imageDetection/detected_status.dart';

class DetectionTab extends StatelessWidget {
  const DetectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get Detection Provider and Theme Provider
    final dp = Provider.of<DetectionProvider>(context);
    final tp = Provider.of<ThemeProvider>(context);

    // Get Screen Size
    Size screen = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          DetectionStatusContainer(
            buttonPressed: () {
              dp.detectButtonPressed(
                ImageSource.gallery,
                context,
              );
            },
            imageFileBool: dp.imageFileList == null,
            objectsDetected: dp.objectsDetected,
            imagesDetected: dp.temporaryImagesDetected,
            progress: dp.progress,
            totalSteps: dp.totalSteps,
          ),
          Container(
            height: screen.height / 1.3,
            margin: const EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: tp.backgroundSecondaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: dp.imageFileList == null || dp.imageFileList!.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 150),
                    child: Center(
                      child: Text(
                        'No Images Picked',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: tp.primaryColor,
                        ),
                      ),
                    ),
                  )
                : dp.isImageDetecting
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 150),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: tp.primaryColor,
                          ),
                        ),
                      )
                    : MasonryGridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: dp.imageResults.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<dynamic> recognitions = dp.imageResults[index];
                          double height = dp.imageHeights[index];
                          double width = dp.imageWidths[index];
                          File detectedImage = File(
                            dp.imageFileList![index].path,
                          );

                          return ListImage(
                            image: detectedImage,
                            recognitions: recognitions,
                            imageHeight: height,
                            imageWidth: width,
                            isDetectionImage: true,
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
