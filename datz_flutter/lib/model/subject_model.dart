import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:flutter/foundation.dart';

/// parent class for SimpeSubject and CombiSubject
/// not intended to be instatiated
class Subject {
  late String name;
  late double coef; // double or int?
  late int id; // Must be the same across all semesters
  Subject({required this.name, required this.coef, int? id}) {
    this.id = id ?? randomId();
  }

  Map<String, dynamic> toJson() =>
      {"some key": "Subject.toJson() should never be called on parent class"};

  void applyMetaModelChanges(SubjectMetaModel subjectMetaModel) {
    name = subjectMetaModel.name;
    coef = subjectMetaModel.coef;
  }

  bool isAvgCalculable() {
    return false;
  }

  /// the average without rounding but with bonus
  double calcExactAvg() {
    return 0;
  }

  /// the average ceiled
  int calcFinalAvg() {
    return calcExactAvg().ceil();
  }

  String formattedAvg() {
    if (!isAvgCalculable()) return "";
    return formatDecimal(calcExactAvg());
  }
}

class SimpleSubject extends Subject {
  late List<Test> simpleTests;
  late List<FixedContributionTest> fixedContributionTests;
  late double plusPoints;
  SimpleSubject({
    required super.name,
    required super.coef,
    this.plusPoints = 0,
    required this.simpleTests,
    this.fixedContributionTests = const [],
    int? id,
  }) : super(id: id);

  SimpleSubject.fromMetaModel(SubjectMetaModel subjectMetaModel)
      : super(
            name: subjectMetaModel.name,
            coef: subjectMetaModel.coef,
            id: subjectMetaModel.id) {
    simpleTests = [];
    fixedContributionTests = [];
    plusPoints = 0;
  }

  SimpleSubject.fromJson(Map<String, dynamic> json) : super(name: "", coef: 0) {
    try {
      id = json["id"];
      name = json["name"];
      coef = json["coef"];
      plusPoints = json["plusPoints"];
      final testsList = (json["simpleTests"] ?? []) as List<dynamic>;
      simpleTests = testsList.map((s) => Test.fromJson(s)).toList();
      final fixedContributionTestsList =
          json["fixedContributionTests"] as List<dynamic>;
      fixedContributionTests = fixedContributionTestsList
          .map((s) => FixedContributionTest.fromJson(s))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse SimpleSubject $name: $e");
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'plusPoints': plusPoints,
        'simpleTests': simpleTests.map((s) => s.toJson()).toList(),
        'fixedContributionTests':
            fixedContributionTests.map((s) => s.toJson()).toList(),
      };

  @override
  bool isAvgCalculable() {
    return simpleTests.isNotEmpty || fixedContributionTests.isNotEmpty;
  }

  double calcExactAvgOfSimpleTests() {
    double gradeSum =
        simpleTests.fold(0, (prevVal, test) => prevVal + test.grade);
    double maxGradeSum =
        simpleTests.fold(0, (prevVal, test) => prevVal + test.maxGrade);
    return gradeSum / maxGradeSum * 60;
  }

  @override
  double calcExactAvg() {
    /// avg in percent
    double avg = 0;
    double contribution = 1;
    for (FixedContributionTest test in fixedContributionTests) {
      contribution -= test.calculateContribution();
      avg += test.calculateContribution() * (test.grade / test.maxGrade);
    }

    if (simpleTests.isNotEmpty) {
      avg += contribution * calcExactAvgOfSimpleTests() / 60;
    } else {
      // if no simple test exists, still display the average
      // TODO is this correct?
      avg = avg / (1 - contribution);
    }

    return avg * 60 + plusPoints;
  }
}

class CombiSubject extends Subject {
  late List<SimpleSubject> subSubjects;

  CombiSubject(
      {required super.name,
      required super.coef,
      required this.subSubjects,
      int? id})
      : super(id: id);

  CombiSubject.fromMetaModel(SubjectMetaModel subjectMetaModel)
      : super(
            name: subjectMetaModel.name,
            coef: subjectMetaModel.coef,
            id: subjectMetaModel.id) {
    subSubjects = [];
    for (SubjectMetaModel subModels in subjectMetaModel.subSubjects!) {
      if (subModels.subSubjects != null) {
        if (kDebugMode) {
          print("Multiple nested subSubjects not allowed");
        }
      } else {
        subSubjects.add(SimpleSubject.fromMetaModel(subModels));
      }
    }
  }

  CombiSubject.fromJson(Map<String, dynamic> json) : super(name: "", coef: 0) {
    try {
      id = json["id"];
      name = json["name"];
      coef = json["coef"];
      final subSubjectsList = json["subSubjects"] as List<dynamic>;
      subSubjects =
          subSubjectsList.map((s) => SimpleSubject.fromJson(s)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse SimpleSubject $name: $e");
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'subSubjects': subSubjects.map((s) => s.toJson()).toList(),
      };

  @override
  void applyMetaModelChanges(SubjectMetaModel subjectMetaModel) {
    super.applyMetaModelChanges(subjectMetaModel);

    if (subjectMetaModel.subSubjects == null) {
      if (kDebugMode) {
        print(
            "Got simple Subject in applyMetaModelChanges for a Combi subject");
      }
      return;
    }

    final List<SimpleSubject> subjectsTemp = [];
    for (SubjectMetaModel subjectMetaModel in subjectMetaModel.subSubjects!) {
      final subjectsWithId =
          subSubjects.where((s) => s.id == subjectMetaModel.id);
      if (subjectsWithId.isNotEmpty) {
        subjectsWithId.first.applyMetaModelChanges(subjectMetaModel);
        subjectsTemp.add(subjectsWithId.first);
        continue;
      }

      if (subjectMetaModel.subSubjects != null) {
        if (kDebugMode) {
          print("Multiple nested subSubjects not allowed");
        }
      } else {
        subjectsTemp.add(SimpleSubject.fromMetaModel(subjectMetaModel));
      }
    }

    subSubjects = subjectsTemp;
  }

  @override
  bool isAvgCalculable() {
    return subSubjects.any((SimpleSubject s) => s.isAvgCalculable());
  }

  /// the average without rounding but with bonus
  @override
  double calcExactAvg() {
    // double gradeSum = 0;
    // double coefSum = 0;

    // for (SimpleSubject s in subSubjects) {
    //   if (!s.isAvgCalculable()) continue;
    //   gradeSum += s.coef * s.calcExactAvg();
    //   coefSum += s.coef;
    // }

    final calcableSubjects =
        subSubjects.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSubjects.map((s) => s.calcExactAvg()).toList(),
      calcableSubjects.map((s) => s.coef).toList(),
    );
  }
}
