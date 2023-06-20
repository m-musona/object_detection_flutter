import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../utils/providers/theme_provider.dart';
import 'detection_tab.dart';
import 'saved_images_tab.dart';

class ImageDashboardPage extends StatefulWidget {
  const ImageDashboardPage({super.key});

  @override
  State<ImageDashboardPage> createState() => _ImageDashboardPageState();
}

class _ImageDashboardPageState extends State<ImageDashboardPage> {
  int currentIndex = 0;

  // List of Pages
  final tabs = [
    const DetectionTab(),
    const SavedImagesTab(),
  ];

  @override
  Widget build(BuildContext context) {
    // Get Theme Provider
    final tp = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: tp.backgroundPrimaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            color: tp.primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: tp.backgroundSecondaryColor,
        title: Text(
          'Image Detection',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: tp.primaryColor,
          ),
        ),
      ),

      // Making the body the current tab
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: tp.backgroundPrimaryColor,
        elevation: 0,
        selectedItemColor: tp.primaryColor,
        unselectedItemColor: Colors.grey,

        // makes the inital tab the first page in the list
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.images,
            ),
            label: 'Detected Images',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.floppyDisk,
            ),
            label: 'Saved Images',
          ),
        ],
        onTap: (index) {
          // Change tab when item is tapped
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
