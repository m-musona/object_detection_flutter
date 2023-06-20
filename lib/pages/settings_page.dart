import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../constants/models.dart';
import '../utils/providers/detection_provider.dart';
import '../utils/providers/theme_provider.dart';
import '../widgets/generalWidgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get Detection Provider and Theme Provider
    final tp = Provider.of<ThemeProvider>(context);
    final dp = Provider.of<DetectionProvider>(context);

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
          'Settings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: tp.primaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Theme',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tp.primaryColor,
              ),
            ),
          ),
          SettingsListItem(
            switchStatus: tp.isDarkModeOn,
            themeItem: true,
            switchFunction: (value) {
              Provider.of<ThemeProvider>(context, listen: false)
                  .checkTheme(value);
              tp.isDarkModeOn = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Model',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tp.primaryColor,
              ),
            ),
          ),
          SettingsListItem(
            title: yolov2,
            switchStatus: dp.model == yolov2,
            themeItem: false,
            switchFunction: (value) {
              Provider.of<DetectionProvider>(context, listen: false)
                  .changeModel(yolov2);
            },
          ),
          SettingsListItem(
            title: ssd,
            switchStatus: dp.model == ssd,
            themeItem: false,
            switchFunction: (value) {
              Provider.of<DetectionProvider>(context, listen: false)
                  .changeModel(ssd);
            },
          ),
          SettingsListItem(
            title: posenet,
            switchStatus: dp.model == posenet,
            themeItem: false,
            switchFunction: (value) {
              Provider.of<DetectionProvider>(context, listen: false)
                  .changeModel(posenet);
            },
          ),
          SettingsListItem(
            title: mobilenet,
            switchStatus: dp.model == mobilenet,
            themeItem: false,
            switchFunction: (value) {
              Provider.of<DetectionProvider>(context, listen: false)
                  .changeModel(mobilenet);
            },
          ),
        ],
      ),
    );
  }
}
