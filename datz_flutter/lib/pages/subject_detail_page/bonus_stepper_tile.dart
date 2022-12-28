import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BonusStepperTile extends StatelessWidget {
  const BonusStepperTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    if (provider.getSelectedSubject() == null) {
      return const Text("todo");
    }
    double bonusPoints = provider.getSelectedSubject()!.plusPoints;
    String bonusText = bonusPoints.toStringAsFixed(0);
    Color bonusLabelColor = CupertinoColors.label.resolveFrom(context);
    if (bonusPoints > 0) {
      bonusText = "+$bonusText";
      bonusLabelColor = CupertinoColors.systemGreen.resolveFrom(context);
    }
    if (bonusPoints < 0) {
      bonusLabelColor = CupertinoColors.systemRed.resolveFrom(context);
    }
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Bonus",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      children: [
        CupertinoListTile.notched(
          title: Text(
            bonusText,
            style: TextStyle(color: bonusLabelColor),
          ),
          trailing: Row(
            children: [
              SizedBox(
                height: 30,
                child: Button(
                  text: "-",
                  onPressed: provider.decrementBonusPoints,
                  type: ButtonType.tinted,
                  padding: const EdgeInsets.all(0),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 30,
                child: Button(
                  text: "+",
                  onPressed: provider.incrementBonusPoints,
                  type: ButtonType.tinted,
                  padding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
