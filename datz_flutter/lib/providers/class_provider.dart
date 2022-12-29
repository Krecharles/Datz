import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../model/semester_model.dart';
import '../model/test_model.dart';

/// A ChangeNotifier providing the main business logic.
///
///
class ClassProvider with ChangeNotifier {
  Class? selectedClass;
  int selectedSemester;

  /// must be the id of a simpleSubject
  int? selectedSubjectId;

  bool failedToLoadClass = false;

  ClassProvider({this.selectedClass, this.selectedSemester = 0}) {
    loadCurrentClass();
  }

  @override
  void notifyListeners() {
    if (selectedClass != null) DataLoader.saveClass(selectedClass!);
    super.notifyListeners();
  }

  /// Loads the last used class from persistent memory.
  void loadCurrentClass() async {
    Class? loadedClass = await DataLoader.loadCurrentClass();
    selectedClass = loadedClass;

    if (selectedClass == null) failedToLoadClass = true;

    notifyListeners();
  }

  void deleteClass(BuildContext context, int classId) {
    if (classId == selectedClass?.id) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Cannot delete active Class'),
          content:
              const Text('Select a different Class before deleting this one'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }
    DataLoader.deleteClass(classId);
    DataLoader.removeClassId(classId);
    notifyListeners();
  }

  /// Performs business logic when selecting a new class in [ClassPickerPage]
  void createAndSelectClass(ClassMetaModel classMetaModel,
      {isCustomModel = false}) {
    Class newClass = Class.fromMetaModel(classMetaModel);
    DataLoader.addClassId(newClass.id);
    DataLoader.saveActiveClassId(newClass.id);
    DataLoader.saveClass(newClass);

    selectClass(newClass);
    if (isCustomModel) {
      FirebaseAnalytics.instance.logJoinGroup(
        groupId: "Custom Class",
      );
      FirebaseAnalytics.instance.logJoinGroup(
        groupId: "Custom_${newClass.name}",
      );
    } else {
      FirebaseAnalytics.instance.logJoinGroup(
        groupId: newClass.name,
      );
    }

    FirebaseAnalytics.instance.logSelectItem(
        itemListName: newClass.usesSemesters() ? "useSemesters" : "usesExams");
  }

  void selectClass(Class c) {
    if (kDebugMode) {
      print("Selected class: \n$c");
    }
    selectedClass = c;
    selectedSemester = 0;
    selectedSubjectId = null;
    failedToLoadClass = false;
    DataLoader.saveActiveClassId(c.id);
    notifyListeners();
  }

  void selectSemester(int sem) {
    selectedSemester = sem;
    notifyListeners();
  }

  void selectSubjectWithId(int subjectId) {
    selectedSubjectId = subjectId;
    notifyListeners();
  }

  void unSelectSubject() {
    selectedSubjectId = null;
    notifyListeners();
  }

  SimpleSubject? getSelectedSubject() {
    if (getSelectedSemester() == null) return null;
    if (selectedSubjectId == null) return null;

    for (Subject s in getSelectedSemester()!.subjects) {
      if (s is SimpleSubject && s.id == selectedSubjectId!) return s;
      if (s is CombiSubject) {
        for (SimpleSubject subSubject in s.subSubjects) {
          if (subSubject.id == selectedSubjectId) return subSubject;
        }
      }
    }
    return null;
  }

  /// is true if the global avg over all semesters is selected
  /// selectedClass == null, false is returned
  bool isDisplayingTotalAvg() {
    if (selectedClass == null) return false;
    return selectedSemester >= selectedClass!.semesters.length;
  }

  Semester? getSelectedSemester() {
    if (selectedClass == null || isDisplayingTotalAvg()) return null;
    return selectedClass!.semesters[selectedSemester];
  }

  void incrementBonusPoints() {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.plusPoints += 1;
    notifyListeners();
  }

  void decrementBonusPoints() {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.plusPoints -= 1;
    notifyListeners();
  }

  void addTest(Test newTest) {
    if (getSelectedSubject() == null) return;
    if (newTest is FixedContributionTest) {
      getSelectedSubject()!.fixedContributionTests.add(newTest);
    } else {
      getSelectedSubject()!.simpleTests.add(newTest);
    }
    notifyListeners();
  }

  void editTest(Test editedTest) {
    if (getSelectedSubject() == null) return;

    Test oldTest;

    if (editedTest is FixedContributionTest) {
      oldTest = getSelectedSubject()!
          .fixedContributionTests
          .firstWhere((Test t) => t.id == editedTest.id);
      if (oldTest is FixedContributionTest) {
        oldTest.contributionFractionBottom =
            editedTest.contributionFractionBottom;
        oldTest.contributionFractionTop = editedTest.contributionFractionTop;
      }
    } else {
      oldTest = getSelectedSubject()!
          .simpleTests
          .firstWhere((Test t) => t.id == editedTest.id);
    }

    oldTest.name = editedTest.name;
    oldTest.grade = editedTest.grade;
    oldTest.maxGrade = editedTest.maxGrade;
    notifyListeners();
  }

  void deleteTest(int testId) {
    if (getSelectedSubject() == null) return;
    getSelectedSubject()!.simpleTests.removeWhere((Test t) => t.id == testId);
    getSelectedSubject()!
        .fixedContributionTests
        .removeWhere((Test t) => t.id == testId);
    notifyListeners();
  }
}
