import 'dart:convert';
import 'dart:math';

import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/semester_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:flutter/foundation.dart';

typedef JsonData = Map<String, dynamic>;

class Class {
  late String name;

  /// Semesters is ensured to be at least 2, otherwise the segmented control
  /// selected semester throws an error
  late List<Semester> semesters;
  late int id;

  Class({required this.name, required this.semesters, int? id}) {
    this.id = id ?? randomId();
  }

  static List<SemesterMetaModel> calcSemesterMetaModels(
      bool useSemesters, bool hasExams) {
    if (useSemesters && !hasExams) {
      return [
        SemesterMetaModel(name: "Sem 1", coef: 1),
        SemesterMetaModel(name: "Sem 2", coef: 1),
      ];
    }
    if (useSemesters && hasExams) {
      return [
        SemesterMetaModel(name: "Sem 1", coef: 1),
        SemesterMetaModel(name: "Sem 2", coef: 1),
        // exam counts as 2/3
        SemesterMetaModel(name: "Exam", coef: 4),
      ];
    }
    if (!useSemesters && !hasExams) {
      return [
        SemesterMetaModel(name: "Trim 1", coef: 1),
        SemesterMetaModel(name: "Trim 2", coef: 1),
        SemesterMetaModel(name: "Trim 3", coef: 1),
      ];
    }
    if (kDebugMode) {
      print("Invalid semester config in class creation");
    }
    throw Error();
  }

  Class.fromMetaModel(ClassMetaModel classMetaModel) {
    name = classMetaModel.name;
    id = randomId();
    semesters = [];
    for (SemesterMetaModel semesterMetaModel in calcSemesterMetaModels(
      classMetaModel.useSemesters,
      classMetaModel.hasExams,
    )) {
      Semester s = Semester.fromMetaModel(classMetaModel, semesterMetaModel);
      semesters.add(s);
    }
  }

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  Class.fromJson(JsonData json) {
    try {
      name = json["name"];
      id = json["id"];
      final semesterList = json["semesters"] as List<dynamic>;
      semesters = semesterList.map((s) => Semester.fromJson(s)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Class $name: $e");
      }
      rethrow;
    }
  }

  JsonData toJson() => {
        'name': name,
        'id': id,
        'semesters': semesters.map((s) => s.toJson()).toList(),
      };

  void applyMetaModelChanges(ClassMetaModel classMetaModel) {
    name = classMetaModel.name;

    final List<Semester> semestersTemp = [];
    final semesterMetaModels = calcSemesterMetaModels(
        classMetaModel.useSemesters, classMetaModel.hasExams);

    semesterMetaModels.asMap().forEach(
      (index, semesterMetaModel) {
        // check if the semester already exists to keep tests in that semester
        if (index < semesters.length) {
          semesters[index]
              .applyMetaModelChanges(classMetaModel, semesterMetaModel);
          semestersTemp.add(semesters[index]);
        } else {
          Semester s =
              Semester.fromMetaModel(classMetaModel, semesterMetaModel);
          semestersTemp.add(s);
        }
      },
    );

    semesters = semestersTemp;
  }

  @override
  String toString() => const JsonEncoder.withIndent("  ").convert(toJson());

  List<String> getSemesterNames() {
    return semesters.map((Semester sem) => sem.name).toList();
  }

  bool usesSemesters() => semesters.first.name.toLowerCase().contains("sem");
  bool usesTrimesters() => semesters.first.name.toLowerCase().contains("tri");
  bool hasExams() => semesters.last.name.toLowerCase().contains("ex");

  bool isAvgCalculable() {
    return semesters.any((s) => s.isAvgCalculable());
  }

  /// the average without rounding
  double calcExactAvg() {
    final calcableSemesters =
        semesters.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSemesters.map((s) => s.calcExactAvg()).toList(),
      calcableSemesters.map((s) => s.coef).toList(),
    );
  }

  /// the average ceiled
  int calcFinalAvg() {
    return calcExactAvg().ceil();
  }

  String formattedAvg() {
    if (!isAvgCalculable()) return "";
    return formatDecimal(calcExactAvg());
  }

  /// also works for subSubjects
  Subject? getSubjectWithId(Semester semester, int subId) {
    for (Subject subject in semester.subjects) {
      if (subject.id == subId) return subject;
      if (subject is CombiSubject) {
        for (SimpleSubject subsub in subject.subSubjects) {
          if (subsub.id == subId) {
            return subsub;
          }
        }
      }
    }
    return null;
  }

  /// returns true if there is at least one Semester
  /// in which the sujects has a grade
  /// also works for subsubjects
  bool isSubjectTotalAvgCalculable(int subId) {
    for (Semester s in semesters) {
      Subject? sub = getSubjectWithId(s, subId);
      if (sub == null) {
        if (kDebugMode) print("There is no subject with id $subId");
        return false;
      }
      if (sub.isAvgCalculable()) return true;
    }
    return false;
  }

  /// should be called after isSubjectAvgCalculable
  /// also works for subsubjects
  double getSubjectTotalExactAvg(int subId) {
    double avg = 0;
    double coefSum = 0;
    for (Semester s in semesters) {
      Subject? sub = getSubjectWithId(s, subId);
      if (sub == null) {
        if (kDebugMode) print("Could not calculate final avg");
        return 0;
      }
      if (!sub.isAvgCalculable()) continue;
      avg += sub.calcFinalAvg() * s.coef;
      coefSum += s.coef;
    }
    return avg / coefSum;
  }

  /// should be called after isSubjectAvgCalculable
  /// also works for subsubjects
  int getSubjectTotalFinalAvg(int subId) {
    return getSubjectTotalExactAvg(subId).ceil();
  }
}

double weightedAvg(List<double> vals, List<double> coefs) {
  double avg = 0;
  double coefSum = 0;
  assert(vals.length == coefs.length);
  for (int i = 0; i < vals.length; i++) {
    avg += coefs[i] * vals[i];
    coefSum += coefs[i];
  }
  return avg / coefSum;
}

String formatDecimal(double val) {
  return val.toStringAsFixed(2);
}

int randomId() => Random().nextInt(0x7fffffff);
