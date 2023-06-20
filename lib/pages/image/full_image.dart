import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../constants/models.dart';
import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/saved_image_provider.dart';
import '../../utils/imagebndbox.dart';

class FullImagePage extends StatelessWidget {
  final File image;
  final List<dynamic>? recognitions;
  final double? imageHeight;
  final double? imageWidth;
  final bool isDetectionImage;
  FullImagePage({
    super.key,
    required this.image,
    this.recognitions,
    this.imageHeight,
    this.imageWidth,
    required this.isDetectionImage,
  });

  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Get Screen Size
    Size screen = MediaQuery.of(context).size;

    // Get Saved Image Provider and Detection Provider
    final sip = Provider.of<SavedImageProvider>(context);
    final dp = Provider.of<DetectionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: screen.width,
              child: RepaintBoundary(
                key: globalKey,
                child: Stack(
                  children: [
                    Hero(
                      tag: image,
                      child: Image.file(
                        image,
                        fit: BoxFit.fitWidth,
                      ),
                    ),

                    // Checks if Image is a detection image
                    isDetectionImage
                        ? ImageBndBox(
                            results: recognitions!,
                            imageH: imageHeight!,
                            imageW: imageWidth!,
                            screenH: screen.height,
                            screenW: screen.width,
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 20.0,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(52, 9, 15, 19),
              ),
              child: IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  size: 30,
                  color: Color(0xFFFFFFFF),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),

          // Checks if Image is a detection image
          isDetectionImage
              ? Positioned(
                  top: 20.0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(52, 9, 15, 19),
                    ),
                    child: IconButton(
                      icon: const FaIcon(
                        Icons.save,
                        size: 30,
                        color: Color(0xFFFFFFFF),
                      ),
                      onPressed: () {
                        sip.saveImageWithBoundingBoxes(context, globalKey);
                      },
                    ),
                  ),
                )
              : const SizedBox(),

          // Checks if Image is a detection image
          isDetectionImage
              ? dp.model == posenet
                  ? const SizedBox(
                      height: 1,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Container(
                          width: screen.width,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(52, 9, 15, 19),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: recognitions!.length,
                            itemBuilder: (context, index) {
                              return Text(
                                'Detected Class: ${recognitions![index]['detectedClass']},\n Confidence ${(recognitions![index]['confidenceInClass'] * 100).toStringAsFixed(2)}%\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
              : const SizedBox(),
        ],
      ),
    );
  }
}
