import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../constants/models.dart';
import '../../utils/providers/detection_provider.dart';
import '../../utils/providers/theme_provider.dart';

class HomeItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget nextPage;
  final bool isImage;
  const HomeItem({
    super.key,
    required this.icon,
    required this.title,
    required this.nextPage,
    required this.isImage,
  });

  @override
  Widget build(BuildContext context) {
    // Get Detection Provider and Theme Provider
    final dp = Provider.of<DetectionProvider>(context);
    final tp = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tp.backgroundSecondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: tp.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              child: Text(
                'Models Available',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: tp.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5,
              ),
              child: Text(
                '$yolov2 , $ssd, $mobilenet',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: tp.primaryColor,
                ),
              ),
            ),
            // Checks if image detection model is runing
            isImage
                ? dp.isImageDetecting
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detection in Progress',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: tp.primaryColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 3,
                              bottom: 12,
                            ),
                            child: LinearProgressIndicator(
                              value: (dp.progress! / dp.totalSteps!),
                              minHeight: 16,
                              color: tp.primaryColor,
                              backgroundColor: tp.backgroundPrimaryColor,
                              // borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox()
                : const SizedBox(),
            // Checks if its for image detection
            isImage
                ? Text(
                    'Detected ${dp.imagesDetected} Images in last 7 days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: tp.primaryColor,
                    ),
                  )
                : Text(
                    'Used ${dp.timesCameraUsed} times in last 7 days',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: tp.primaryColor,
                    ),
                  ),
            // Checks if its for image detection
            isImage
                ? dp.resetImageDate != null
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'Resets: ${DateFormat('HH:mm MMMM d, yyyy').format(dp.resetImageDate!)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: tp.primaryColor,
                          ),
                        ),
                      )
                    : const SizedBox()
                : dp.resetCameraDate != null
                    ? Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'Resets: ${DateFormat('HH:mm MMMM d, yyyy').format(dp.resetCameraDate!)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: tp.primaryColor,
                          ),
                        ),
                      )
                    : const SizedBox(),
            Divider(
              thickness: 1,
              height: 24,
              color: tp.primaryColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => nextPage),
                    );
                  },
                  icon: Icon(
                    icon,
                    size: 40,
                    color: tp.actionButtonColor,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
