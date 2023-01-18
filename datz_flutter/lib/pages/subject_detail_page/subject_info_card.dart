import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// A widget displaying the Average and Coefficient of a subject
class SubjectInfoCard extends StatelessWidget {
  const SubjectInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(20),
      decoration: CustomDecorations.primaryContainer(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            provider.getSelectedSubject()?.formattedExactAvg() ?? "",
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "${AppLocalizations.of(context)!.coefficient}: ${provider.getSelectedSubject()?.coef ?? ""}",
            style: TextStyle(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
