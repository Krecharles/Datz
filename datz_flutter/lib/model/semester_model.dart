import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:flutter/foundation.dart';

class Semester {
  late String name;
  late double coef;
  late List<Subject> subjects;
  late int id;

  Semester(
      {required this.name,
      required this.coef,
      required this.subjects,
      int? id}) {
    this.id = id ?? randomId();
  }

  Semester.fromMetaModel(
      ClassMetaModel classMetaModel, SemesterMetaModel semesterMetaModel) {
    name = semesterMetaModel.name;
    coef = semesterMetaModel.coef;
    id = randomId();

    subjects = [];
    for (SubjectMetaModel subjectMetaModel in classMetaModel.subjects) {
      if (subjectMetaModel.subSubjects == null ||
          subjectMetaModel.subSubjects!.isEmpty) {
        Subject s = SimpleSubject.fromMetaModel(subjectMetaModel);
        subjects.add(s);
      } else {
        Subject s = CombiSubject.fromMetaModel(subjectMetaModel);
        subjects.add(s);
      }
    }
  }

  Semester.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      coef = json["coef"];
      id = json["id"];
      final subjectsList = json["subjects"] as List<dynamic>;
      subjects = subjectsList.map((s) {
        if (s.keys.contains("subSubjects")) return CombiSubject.fromJson(s);
        return SimpleSubject.fromJson(s);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Semester $name: $e");
      }
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'coef': coef,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  void applyMetaModelChanges(
    ClassMetaModel classMetaModel,
    SemesterMetaModel semesterMetaModel,
  ) {
    name = semesterMetaModel.name;
    coef = semesterMetaModel.coef;

    final List<Subject> subjectsTemp = [];

    for (SubjectMetaModel subjectMetaModel in classMetaModel.subjects) {
      final subjectsWithId = subjects.where((s) => s.id == subjectMetaModel.id);

      if (subjectsWithId.isNotEmpty) {
        subjectsWithId.first.applyMetaModelChanges(subjectMetaModel);
        subjectsTemp.add(subjectsWithId.first);
        continue;
      }

      if (subjectMetaModel.subSubjects == null ||
          subjectMetaModel.subSubjects!.isEmpty) {
        Subject s = SimpleSubject.fromMetaModel(subjectMetaModel);
        subjectsTemp.add(s);
        continue;
      }

      Subject s = CombiSubject.fromMetaModel(subjectMetaModel);
      subjectsTemp.add(s);
    }

    subjects = subjectsTemp;
  }

  bool isAvgCalculable() {
    return subjects.any((s) => s.isAvgCalculable());
  }

  /// the average without rounding
  double calcExactAvg() {
    final calcableSubjects =
        subjects.where((s) => s.isAvgCalculable()).toList();

    // not + bonus as it is usually not the case for combisubjects
    return weightedAvg(
      calcableSubjects.map((s) => s.calcExactAvg()).toList(),
      calcableSubjects.map((s) => s.coef).toList(),
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
}
