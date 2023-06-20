import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/models.dart';
import '../../pages/image/full_image.dart';
import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/theme_provider.dart';

class ListImage extends StatelessWidget {
  final File image;
  final List<dynamic>? recognitions;
  final double? imageHeight;
  final double? imageWidth;
  final bool isDetectionImage;

  const ListImage({
    super.key,
    required this.image,
    this.recognitions,
    this.imageHeight,
    this.imageWidth,
    required this.isDetectionImage,
  });

  @override
  Widget build(BuildContext context) {
    // Get Theme Provider and Detection Provider
    final tp = Provider.of<ThemeProvider>(context);
    final dp = Provider.of<DetectionProvider>(context);

    return Column(
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
              child: Container(
                decoration: BoxDecoration(
                  color: tp.backgroundSecondaryColor,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x34090F13),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          // Checks if its a Detected Image or Not
                          if (isDetectionImage) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FullImagePage(
                                  image: image,
                                  recognitions: recognitions,
                                  imageHeight: imageHeight,
                                  imageWidth: imageWidth,
                                  isDetectionImage: isDetectionImage,
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FullImagePage(
                                  image: image,
                                  isDetectionImage: isDetectionImage,
                                ),
                              ),
                            );
                          }
                        },
                        padding: const EdgeInsets.all(0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              0,
                            ),
                          ),
                          child: Hero(
                            tag: image,
                            child: Image.file(
                              image,
                              errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) =>
                                  Center(
                                child: Text(
                                  'This image type is not supported',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: tp.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Checks if its a Detected Image or Not
                      isDetectionImage
                          ? dp.model == posenet
                              ? Text(
                                  'Click Image for results',
                                  style: TextStyle(
                                    color: tp.primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: recognitions!.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      'Class: ${recognitions![index]['detectedClass']}, Confidence ${(recognitions![index]['confidenceInClass'] * 100).toStringAsFixed(2)}%\n',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: tp.primaryColor,
                                      ),
                                    );
                                  },
                                )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
