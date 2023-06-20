import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/providers/theme_provider.dart';
import 'camera/camera_detect.dart';
import 'image/image_dashboard.dart';
import 'settings_page.dart';
import '../widgets/generalWidgets/home_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get Theme Provider
    final tp = Provider.of<ThemeProvider>(context);

    // Get Screen Size
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: screen.width,
                  height: screen.height / 2,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E262B),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.settings,
                              size: 27,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: Text(
                        'Object Detection For Tflite Models in flutter',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Container(
                        width: screen.width,
                        decoration: BoxDecoration(
                          color: tp.backgroundPrimaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 4,
                                indent: 140,
                                endIndent: 140,
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Text(
                                  'Detection Type',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    color: tp.primaryColor,
                                  ),
                                ),
                              ),
                              const Column(
                                children: [
                                  HomeItem(
                                    icon: Icons.camera_alt,
                                    title: 'Real Time',
                                    nextPage: CameraDetect(),
                                    isImage: false,
                                  ),
                                  HomeItem(
                                    icon: Icons.photo_library_rounded,
                                    title: 'Image',
                                    nextPage: ImageDashboardPage(),
                                    isImage: true,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
