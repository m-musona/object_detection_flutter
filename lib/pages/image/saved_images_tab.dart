import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../utils/providers/saved_image_provider.dart';
import '../../utils/providers/theme_provider.dart';
import '../../widgets/imageDetection/detected_image.dart';

class SavedImagesTab extends StatelessWidget {
  const SavedImagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Get Saved Image Provider and Theme Provider
    final sip = Provider.of<SavedImageProvider>(context);
    final tp = Provider.of<ThemeProvider>(context);

    return Container(
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

      // Checks if imagePaths is an Empty list
      child: sip.imagePaths.isEmpty
          ? Center(
              child: Text(
                'No Images Are Saved',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
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
              itemCount: sip.imagePaths.length,
              itemBuilder: (BuildContext context, int index) {
                File savedImage = File(
                  sip.imagePaths[index],
                );

                return ListImage(
                  image: savedImage,
                  isDetectionImage: false,
                );
              },
            ),
    );
  }
}
