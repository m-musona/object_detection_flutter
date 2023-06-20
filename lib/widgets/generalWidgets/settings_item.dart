import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/providers/theme_provider.dart';

class SettingsListItem extends StatelessWidget {
  final String? title;
  final bool switchStatus;
  final bool themeItem;
  final void Function(bool) switchFunction;
  const SettingsListItem({
    super.key,
    this.title,
    required this.switchStatus,
    required this.themeItem,
    required this.switchFunction,
  });

  @override
  Widget build(BuildContext context) {
    // Get and Theme Provider
    final tp = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
      decoration: BoxDecoration(
        color: tp.backgroundSecondaryColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SwitchListTile(
        activeColor: tp.primaryColor,
        activeTrackColor: tp.primaryColor,
        inactiveTrackColor: tp.backgroundPrimaryColor,
        inactiveThumbColor: tp.backgroundPrimaryColor,
        // Checks if its used to change the theme
        title: themeItem
            ? Text(
                // Checks if switch is true or false
                switchStatus ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: tp.primaryColor,
                ),
              )
            : Text(
                title!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: tp.primaryColor,
                ),
              ),
        value: switchStatus,
        onChanged: switchFunction,
      ),
    );
  }
}
