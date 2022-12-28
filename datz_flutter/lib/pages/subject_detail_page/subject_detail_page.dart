import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:datz_flutter/pages/edit_test_page.dart';
import 'package:datz_flutter/pages/subject_detail_page/bonus_stepper_tile.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SubjectDetailPage extends StatelessWidget {
  const SubjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CustomColors.colorMid,
        previousPageTitle: "Back",
        middle: Text(
          context.watch<ClassProvider>().getSelectedSubject()?.name ?? "",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(child: buildBody(context)),
      ),
    );
  }

  Widget buildHeader(BuildContext context, double shrinkOffset) {
    const maxExtent = 200;
    // final shrinkRatio = clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
    final opacity = clampDouble(1 - 2 * shrinkOffset / maxExtent, 0, 1);
    final provider = context.watch<ClassProvider>();
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: CustomDecorations.primaryGradientDecoration(context),
        ),
        const Positioned(
          left: 12.0,
          top: 0,
          child: SafeArea(
              child: CupertinoNavigationBarBackButton(
            color: CupertinoColors.white,
            // previousPageTitle: "Back",
          )),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          bottom: 12.0 + opacity * 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                provider.getSelectedSubject()?.name ?? "",
                style: TextStyle(
                  fontSize: (1 - opacity) * 32,
                  color: CupertinoColors.white.withOpacity(1 - opacity),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                provider.getSelectedSubject()?.formattedAvg() ?? "",
                style: TextStyle(
                  fontSize: 32 + opacity * 64,
                  color: CupertinoColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Column(
      children: [
        buildSubjectInfoCard(context),
        const BonusStepperTile(),
        buildTestList(
          context,
          provider.getSelectedSubject()?.simpleTests,
          "Tests",
          buildTestTile,
        ),
        buildTestList(
          context,
          provider.getSelectedSubject()?.fixedContributionTests,
          "Fixed Contribution Tests",
          buildTestTile,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildAddTestButton(context),
          ],
        ),
      ],
    );
  }

  Widget buildAddTestButton(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Button(
      text: "Add Test",
      type: ButtonType.tinted,
      leadingIcon: CupertinoIcons.add,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TestEditPage(
              onSubmit: (Test newTest) => provider.addTest(newTest),
            ),
          ),
        );
      },
    );
  }

  Widget buildTestList(BuildContext context, List<Test>? tests, String header,
      Widget Function(BuildContext, Test) buildTile) {
    ClassProvider provider = context.watch<ClassProvider>();
    if (tests == null || tests.isEmpty) {
      return Container();
    }
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          header,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      children: [
        for (Test t in tests)
          Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => TestEditPage(
                          editTest: t,
                          onSubmit: (Test newTest) =>
                              provider.editTest(newTest),
                        ),
                      ),
                    );
                  },
                  backgroundColor: CupertinoColors.systemBlue,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (BuildContext context) {
                    provider.deleteTest(t.id);
                  },
                  backgroundColor: CupertinoColors.systemRed,
                  label: 'Delete',
                ),
              ],
            ),
            child: buildTile(context, t),
          ),
      ],
    );
  }

  Widget buildTestTile(BuildContext context, Test t) {
    final provider = context.watch<ClassProvider>();
    String title = t.name;
    if (t is FixedContributionTest) {
      title += "  -  ${t.getContributionFractionString()}";
    }
    return CupertinoListTile.notched(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TestEditPage(
              editTest: t,
              onSubmit: (Test newTest) => provider.editTest(newTest),
            ),
          ),
        );
      },
      title: Text(title),
      trailing: Row(
        children: [
          Text(
            "${t.grade} / ${t.maxGrade}",
            style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context)),
          ),
          const SizedBox(width: 4),
          const CupertinoListTileChevron()
        ],
      ),
    );
  }

  Widget buildSubjectInfoCard(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Container(
      // height: 100,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(20),
      decoration: CustomDecorations.primaryContainer(context),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            provider.getSelectedSubject()?.formattedAvg() ?? "",
            style: TextStyle(
              color: CupertinoColors.label.resolveFrom(context),
              fontSize: 34,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Coefficient: ${provider.getSelectedSubject()?.coef ?? ""}",
            style: TextStyle(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
