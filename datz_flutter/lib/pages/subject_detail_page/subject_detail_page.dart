import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/slidables.dart';
import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:datz_flutter/pages/edit_test_page.dart';
import 'package:datz_flutter/pages/subject_detail_page/bonus_stepper_tile.dart';
import 'package:datz_flutter/pages/subject_detail_page/subject_info_card.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Shown when a user taps on a subjet in [HomePage].
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
      child: CustomCupertinoPageBody(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Column(
      children: [
        const SubjectInfoCard(),
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

  Widget buildTestList(BuildContext context, List<Test>? tests, String header,
      Widget Function(BuildContext, Test) buildTile) {
    ClassProvider provider = context.watch<ClassProvider>();
    if (tests == null || tests.isEmpty) {
      return Container();
    }
    return CustomCupertinoListSection(
      header: header,
      children: [
        for (Test t in tests)
          CustomSlidable(
            onEdit: (BuildContext context) => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => TestEditPage(
                  editTest: t,
                  onSubmit: (Test newTest) => provider.editTest(newTest),
                ),
              ),
            ),
            onDelete: (BuildContext context) => provider.deleteTest(t.id),
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
}
