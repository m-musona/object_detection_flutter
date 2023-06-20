import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/theme_provider.dart';

class DetectionStatusContainer extends StatelessWidget {
  final void Function() buttonPressed;
  final bool imageFileBool;
  final int? objectsDetected;
  final int? imagesDetected;
  final double? progress;
  final int? totalSteps;
  const DetectionStatusContainer({
    super.key,
    required this.buttonPressed,
    required this.imageFileBool,
    required this.objectsDetected,
    required this.imagesDetected,
    required this.progress,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    // Get Detection Provider and Theme Provider
    final dp = Provider.of<DetectionProvider>(context);
    final tp = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(
        top: 12,
        left: 16,
        right: 16,
      ),
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: tp.backgroundSecondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          // If the image file list variable in detection provider is null
          dp.imageFileList == null || dp.imageFileList!.isEmpty
              ? Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            'No Images have Been Chosen',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: tp.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              // Checks if its done detecting
              : (progress! / totalSteps!) == 1
                  ? Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Detected $objectsDetected objects from $imagesDetected Images',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: tp.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Currently Detecting $objectsDetected objects from $imagesDetected Images',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: tp.primaryColor,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: (progress! / totalSteps!),
                                  strokeWidth: 4,
                                  color: tp.primaryColor,
                                  backgroundColor: tp.backgroundPrimaryColor,
                                ),
                              ),
                            ),
                            Text(
                              '${((progress! / totalSteps!) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: tp.primaryColor,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
          Divider(
            endIndent: 5,
            indent: 5,
            thickness: 1,
            color: tp.backgroundPrimaryColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                padding: const EdgeInsets.all(0),
                elevation: 3,
                onPressed: buttonPressed,
                child: Container(
                  height: 40,
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 24,
                  ),
                  decoration: BoxDecoration(
                    color: tp.primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Detect',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: tp.backgroundSecondaryColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
