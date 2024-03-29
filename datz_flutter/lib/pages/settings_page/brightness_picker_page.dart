import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/providers/settings_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BrightnessPickerPage extends StatefulWidget {
  const BrightnessPickerPage({super.key});

  @override
  State<BrightnessPickerPage> createState() => _BrightnessPickerPageState();
}

class _BrightnessPickerPageState extends State<BrightnessPickerPage> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance
        .logScreenView(screenName: "BrightnessPickerPage");
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.settings,
        middle: Text(AppLocalizations.of(context)!.brightness),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile.notched(
                  leading: Opacity(
                    opacity: provider.brightness == null ? 1 : 0,
                    child: const Icon(CupertinoIcons.check_mark),
                  ),
                  title: Text(AppLocalizations.of(context)!.system),
                  onTap: () => provider.setBrightness(null),
                ),
                CupertinoListTile.notched(
                  leading: Opacity(
                    opacity: provider.brightness == Brightness.light ? 1 : 0,
                    child: const Icon(CupertinoIcons.check_mark),
                  ),
                  title: Text(AppLocalizations.of(context)!.light),
                  onTap: () => provider.setBrightness(Brightness.light),
                ),
                CupertinoListTile.notched(
                  leading: Opacity(
                    opacity: provider.brightness == Brightness.dark ? 1 : 0,
                    child: const Icon(CupertinoIcons.check_mark),
                  ),
                  title: Text(AppLocalizations.of(context)!.dark),
                  onTap: () => provider.setBrightness(Brightness.dark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
