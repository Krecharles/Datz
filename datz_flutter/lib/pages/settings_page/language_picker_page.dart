import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerPage extends StatelessWidget {
  const LanguagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.settings,
        middle: Text(AppLocalizations.of(context)!.language),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                for (String languageCode in SettingsProvider.languageCodes)
                  CupertinoListTile.notched(
                    leading: Opacity(
                      opacity: provider.languageCode == languageCode ? 1 : 0,
                      child: const Icon(CupertinoIcons.check_mark),
                    ),
                    title: Text(SettingsProvider.getLanguageDescriptionOfCode(
                        languageCode)),
                    onTap: () => provider.setLanguageCode(languageCode),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
