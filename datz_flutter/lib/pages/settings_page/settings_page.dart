import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/pages/class_picker_page/class_picker_page.dart';
import 'package:datz_flutter/pages/credits_page/credits_page.dart';
import 'package:datz_flutter/pages/language_picker_page/language_picker_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:datz_flutter/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
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
                      Text(provider.selectedClass?.name ?? ""),
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
                      Text(context
                          .watch<LanguageProvider>()
                          .getLanguageDescription()),
                      const SizedBox(width: 8),
                      const CupertinoListTileChevron()
                    ],
                  ),
                  onTap: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const LanguagePickerPage(),
                      ),
                    )
                  },
                ),
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
