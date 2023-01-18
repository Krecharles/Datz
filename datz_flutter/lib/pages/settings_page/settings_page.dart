import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/pages/class_picker_page/class_picker_page.dart';
import 'package:datz_flutter/pages/credits_page/credits_page.dart';
import 'package:datz_flutter/pages/settings_page/brightness_picker_page.dart';
import 'package:datz_flutter/pages/settings_page/language_picker_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:datz_flutter/providers/settings_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logScreenView(screenName: "SettingsPage");
  }

  void onChangeClass(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ClassPickerPage(
          onExit: (context) => Navigator.pop(context),
        ),
      ),
    );
  }

  void onTapBrightness(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const BrightnessPickerPage(),
      ),
    ).then((value) {
      var brightnessString =
          context.read<SettingsProvider>().brightness?.name ?? "system";
      FirebaseAnalytics.instance
          .logEvent(name: "ChangeBrightness", parameters: {
        "brightness_value": brightnessString,
      });
    });
  }

  void onTapLanguage(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const LanguagePickerPage(),
      ),
    ).then((value) {
      var languageCode = context.read<SettingsProvider>().languageCode;
      FirebaseAnalytics.instance.logEvent(name: "ChangeLanguage", parameters: {
        "language_code": languageCode,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final classProvider = context.watch<ClassProvider>();
    final settingsProvider = context.watch<SettingsProvider>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.back,
        middle: Text(AppLocalizations.of(context)!.settings),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile.notched(
                  title: Text(AppLocalizations.of(context)!.class_),
                  trailing: Row(
                    children: [
                      Text(classProvider.selectedClass?.name ?? ""),
                      const SizedBox(width: 8),
                      const CupertinoListTileChevron()
                    ],
                  ),
                  onTap: () => onChangeClass(context),
                ),
                CupertinoListTile.notched(
                  title: Text(AppLocalizations.of(context)!.language),
                  trailing: Row(
                    children: [
                      Text(settingsProvider.getLanguageDescription()),
                      const SizedBox(width: 8),
                      const CupertinoListTileChevron()
                    ],
                  ),
                  onTap: () => onTapLanguage(context),
                ),
                CupertinoListTile.notched(
                    title: Text(AppLocalizations.of(context)!.brightness),
                    trailing: Row(
                      children: [
                        Text(
                            settingsProvider.getBrightnessDescription(context)),
                        const SizedBox(width: 8),
                        const CupertinoListTileChevron()
                      ],
                    ),
                    onTap: () => onTapBrightness(context)),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile.notched(
                  title: Text(AppLocalizations.of(context)!.credits),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const CreditsPage(),
                      ),
                    )
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
