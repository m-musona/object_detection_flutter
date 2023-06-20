import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/models.dart';
import 'providers/detection_provider.dart';

// used to gereate a random color every time it is called
Color generateRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

// The Painter that draws Points on Image
class PontPainter extends CustomPainter {
  final double xpos;
  final double ypos;
  final String part;

  PontPainter(this.xpos, this.ypos, this.part);

  @override
  void paint(Canvas canvas, Size size) {
    // Draws the text and Sets the Parameters
    final textStyle = TextStyle(
      color: generateRandomColor(),
    );

    TextSpan span = TextSpan(
      text: part,
      style: textStyle,
    );

    TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    final textOffset = Offset(
      xpos - textPainter.width,
      ypos - textPainter.height,
    );
    textPainter.paint(
      canvas,
      textOffset,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// The Painter that draws the boxes
class BoundingBoxPainter extends CustomPainter {
  final Rect boundingBox;
  final String text;

  BoundingBoxPainter(this.boundingBox, this.text);

  // Function used to generate random colors
  @override
  void paint(Canvas canvas, Size size) {
    // Set the color of the bounding box and text to the random color
    Color boundingBoxAndText = generateRandomColor();

    // Set bounding box parameters
    final paint = Paint()
      ..color = boundingBoxAndText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRect(boundingBox, paint);

    // Set Text parameters and Draws Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: boundingBoxAndText, fontSize: 12.0),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textOffset = Offset(
      boundingBox.right - textPainter.width,
      boundingBox.top - textPainter.height,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ImageBndBox extends StatelessWidget {
  final List<dynamic> results;
  final double imageH;
  final double imageW;
  final double screenH;
  final double screenW;
  const ImageBndBox({
    super.key,
    required this.results,
    required this.imageH,
    required this.imageW,
    required this.screenH,
    required this.screenW,
  });

  @override
  Widget build(BuildContext context) {
    // Gets the Detection Provider
    final dp = Provider.of<DetectionProvider>(context);

    // Checks if using pose net
    if (dp.model == posenet) {
      // Goes throught all the results
      return ListView.builder(
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (BuildContext context, int index) {
            Map keypoints = results[index]['keypoints'];

            // Goes throught all the keypoints in the results
            return ListView.builder(
              shrinkWrap: true,
              itemCount: keypoints.length,
              itemBuilder: (BuildContext context, int index) {
                // Break keypoints into x, y and part class and confidence
                double x = keypoints[index]['x'];
                double y = keypoints[index]['y'];
                String part = keypoints[index]['part'];

                // Get the Scale Height and the Scale Width
                double scaleH = screenW / imageW * imageH;
                double scaleW = screenH / imageH * imageW;

                return CustomPaint(
                  painter: PontPainter(
                    (x * scaleW),
                    (y * scaleH),
                    "●\n $part",
                  ),
                  child: const SizedBox(
                    height: 1,
                  ),
                );
              },
            );
          });
    } else {
      // Goes throught all the results
      return ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (BuildContext context, int index) {
          // Break results into x, y, h(height), w(width), class and confidence
          double y = results[index]['rect']['y'];
          double x = results[index]['rect']['x'];
          double h = results[index]['rect']['h'];
          double w = results[index]['rect']['w'];
          double confidence = results[index]['confidenceInClass'];
          String classLabel = results[index]['detectedClass'];

          // Get the Scale Height and the Scale Width
          double scaleH = screenW / imageW * imageH;
          double scaleW = screenH / imageH * imageW;

          // For each object detected paint the Bounding Box And Text using the above variables
          return CustomPaint(
            painter: BoundingBoxPainter(
              Rect.fromLTRB(
                (x * scaleW),
                (y * scaleH),
                (w * screenW),
                (h * scaleH),
              ),
              '$classLabel ${(confidence * 100).toStringAsFixed(0)}%',
            ),
            child: const SizedBox(
              height: 1,
            ),
          );
        },
      );
    }
  }
}
