import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageSliverHeader extends StatelessWidget {
  final double shrinkOffset;

  const HomePageSliverHeader({
    super.key,
    required this.shrinkOffset,
  });

  @override
  Widget build(BuildContext context) {
    const maxExtent = 300;
    // final shrinkRatio = clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
    final opacity = clampDouble(1 - 2 * shrinkOffset / maxExtent, 0, 1);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: CustomDecorations.primaryGradientDecoration(context),
        ),
        buildClassIndicator(context, opacity),
        buildAvgLabel(context, opacity),
        buildSemesterPicker(context, opacity)
      ],
    );
  }

  Widget buildSemesterPicker(BuildContext context, double opacity) {
    final provider = context.watch<ClassProvider>();
    if (provider.selectedClass == null) return Container();

    List<String> semesterNames = provider.selectedClass!.getSemesterNames();
    Map<int, Widget> options = {};
    for (int i = 0; i < semesterNames.length; i++) {
      options[i] = Text(
        semesterNames[i],
        style: CupertinoTheme.of(context).textTheme.textStyle,
      );
    }
    options[semesterNames.length] = Text(
      "Total",
      style: CupertinoTheme.of(context).textTheme.textStyle,
    );

    return Positioned(
      left: 12.0,
      right: 12.0,
      bottom: 12.0 - shrinkOffset / 2,
      child: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Opacity(
            opacity: opacity,
            child: CupertinoSlidingSegmentedControl(
              groupValue: provider.selectedSemester,
              children: options,
              onValueChanged: (int? value) {
                provider.selectSemester(value ?? 0);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildClassIndicator(BuildContext context, double opacity) {
    return Positioned(
      right: 20.0,
      top: 12.0,
      child: Opacity(
        opacity: opacity,
        child: SafeArea(
          child: Text(
            context.watch<ClassProvider>().selectedClass?.name ?? "",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget buildAvgLabel(BuildContext context, double opacity) {
    return Positioned(
      left: 12.0,
      right: 12.0,
      bottom: 12.0 + opacity * 64,
      child: Text(
        calcMainHeaderNumber(context.watch<ClassProvider>()),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32 + opacity * 64,
          color: CupertinoColors.white,
        ),
      ),
    );
  }

  String calcMainHeaderNumber(ClassProvider provider) {
    if (provider.selectedClass == null) return "";
    if (provider.isDisplayingTotalAvg()) {
      return provider.selectedClass!.formattedAvg();
    }
    return provider.getSelectedSemester()?.formattedAvg() ?? "";
  }
}
