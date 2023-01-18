import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/providers/language_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePickerPage extends StatelessWidget {
  const LanguagePickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LanguageProvider>();
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
                for (String languageCode in LanguageProvider.languageCodes)
                  CupertinoListTile.notched(
                    leading: Opacity(
                      opacity: provider.languageCode == languageCode ? 1 : 0,
                      child: const Icon(CupertinoIcons.check_mark),
                    ),
                    title: Text(LanguageProvider.getLanguageDescriptionOfCode(
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
