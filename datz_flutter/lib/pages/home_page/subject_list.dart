import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/model/semester_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:datz_flutter/pages/subject_detail_page/subject_detail_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SubjectList extends StatelessWidget {
  const SubjectList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    if (provider.selectedClass == null) return const Text("Loading");

    Semester sem = provider.isDisplayingTotalAvg()
        ? provider.selectedClass!.semesters.first
        : provider.getSelectedSemester()!;

    return Column(
      children: [
        for (Subject subject in sem.subjects) ...[
          if (subject is SimpleSubject) SimpleSubjectListTile(subject: subject),
          if (subject is CombiSubject) CombiSubjectListTile(subject: subject)
        ]
      ],
    );
  }
}

/// a simple subject is displayed as a list with a single tile
class SimpleSubjectListTile extends StatelessWidget {
  const SimpleSubjectListTile({
    super.key,
    required this.subject,
  });

  final SimpleSubject subject;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return CustomCupertinoListSection(
      children: [
        CupertinoListTile.notched(
          title: Text(
            subject.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onTap: () {
            if (provider.isDisplayingTotalAvg()) return;
            provider.selectSubjectWithId(subject.id);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: ((context) => const SubjectDetailPage()),
              ),
            ).then((_) => provider.unSelectSubject());
          },
          trailing: Row(
            children: [
              if (!provider.isDisplayingTotalAvg())
                Text(
                  subject.formattedFinalAvg(),
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                )
              else
                Text(
                  provider.selectedClass!
                          .isSubjectTotalAvgCalculable(subject.id)
                      ? provider.selectedClass!
                          .getSubjectTotalFinalAvg(subject.id)
                          .toString()
                      : "",
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              const SizedBox(width: 4),
              if (!provider.isDisplayingTotalAvg())
                const CupertinoListTileChevron()
            ],
          ),
        ),
      ],
    );
  }
}

class CombiSubjectListTile extends StatelessWidget {
  final CombiSubject subject;

  const CombiSubjectListTile({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return CustomCupertinoListSection(
      children: [
        CupertinoListTile.notched(
          title: Text(
            subject.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: Row(
            children: [
              if (!provider.isDisplayingTotalAvg())
                Text(
                  subject.formattedFinalAvg(),
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                )
              else
                Text(
                  provider.selectedClass!
                          .isSubjectTotalAvgCalculable(subject.id)
                      ? provider.selectedClass!
                          .getSubjectTotalFinalAvg(subject.id)
                          .toString()
                      : "",
                  style: TextStyle(
                      color:
                          CupertinoColors.secondaryLabel.resolveFrom(context)),
                ),
              if (!provider.isDisplayingTotalAvg()) const SizedBox(width: 22),
            ],
          ),
        ),
        for (SimpleSubject sub in subject.subSubjects)
          CupertinoListTile.notched(
            title: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(sub.name),
            ),
            onTap: () {
              if (provider.isDisplayingTotalAvg()) return;
              provider.selectSubjectWithId(sub.id);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: ((context) => const SubjectDetailPage()),
                ),
              ).then((_) => provider.unSelectSubject());
            },
            trailing: Row(
              children: [
                if (!provider.isDisplayingTotalAvg())
                  Text(
                    sub.formattedFinalAvg(),
                    style: TextStyle(
                        color: CupertinoColors.secondaryLabel
                            .resolveFrom(context)),
                  )
                else
                  Text(
                    provider.selectedClass!.isSubjectTotalAvgCalculable(sub.id)
                        ? provider.selectedClass!
                            .getSubjectTotalFinalAvg(sub.id)
                            .toString()
                        : "",
                    style: TextStyle(
                        color: CupertinoColors.secondaryLabel
                            .resolveFrom(context)),
                  ),
                if (!provider.isDisplayingTotalAvg()) ...[
                  const SizedBox(width: 4),
                  const CupertinoListTileChevron()
                ]
              ],
            ),
          ),
      ],
    );
  }
}
