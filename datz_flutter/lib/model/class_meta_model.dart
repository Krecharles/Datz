import 'dart:convert';

import 'package:datz_flutter/model/class_model.dart';
import 'package:flutter/foundation.dart';

class ClassMetaModel {
  late String name;
  late bool useSemesters;
  late bool hasExams;
  late List<SubjectMetaModel> subjects;

  ClassMetaModel({
    required this.name,
    required this.useSemesters,
    required this.hasExams,
    required this.subjects,
  });

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  ClassMetaModel.fromJson(JsonData json) {
    try {
      name = json["name"];
      useSemesters = json["useSemesters"] ?? true;
      hasExams = json["hasExams"] ?? false;
      final subjectsList = json["subjects"] as List<dynamic>;
      subjects = subjectsList.map((s) => SubjectMetaModel.fromJson(s)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Class MetaData $name: $e");
      }
      rethrow;
    }
  }

  JsonData toJson() => {
        'name': name,
        "useSemesters": useSemesters,
        "hasExams": hasExams,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  @override
  String toString() => const JsonEncoder.withIndent("  ").convert(toJson());
}

class SubjectMetaModel {
  late String name;
  late double coef;
  late List<SubjectMetaModel>? subSubjects;
  late int id; // needed to have every subject in each semesters the same id

  SubjectMetaModel({
    required this.name,
    required this.coef,
    this.subSubjects,
    int? id,
  }) {
    this.id = id ?? randomId();
  }

  SubjectMetaModel.fromJson(JsonData json) {
    try {
      name = json["name"];
      coef = json["coef"];
      id = randomId();
      final subSubjectsList = json["subSubjects"] as List<dynamic>?;
      if (subSubjectsList != null) {
        subSubjects =
            subSubjectsList.map((s) => SubjectMetaModel.fromJson(s)).toList();
      } else {
        subSubjects = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Subject MetaData $name: $e");
      }
      rethrow;
    }
  }

  JsonData toJson() => {
        'name': name,
        "coef": coef,
        'subSubjects': subSubjects?.map((s) => s.toJson()).toList(),
      };

  @override
  String toString() => const JsonEncoder.withIndent("  ").convert(toJson());
}

class SemesterMetaModel {
  /// e.g. "Sem 1", "Exam"
  late String name;
  late double coef;

  SemesterMetaModel({
    required this.name,
    required this.coef,
  });

  /// This method throws an error if something didn't parse correctly or if the
  /// data format is not met. Be sure to wrap it in a try catch
  SemesterMetaModel.fromJson(JsonData json) {
    try {
      name = json["name"];
      coef = json["coef"];
    } catch (e) {
      if (kDebugMode) {
        print(
            "There was an error trying to parse Semester MetaModel $name: $e");
      }
      rethrow;
    }
  }
}
