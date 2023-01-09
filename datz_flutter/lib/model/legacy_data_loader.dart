import 'dart:convert';

import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/model/semester_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:flutter/foundation.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LegacyDataLoader {
  /// Loads and Saves the Classes a user might have from the Xcode version.
  static void checkPreferences() async {
    try {
      final userDefaults = await SharedPreferences.getInstance();
      if (userDefaults.getBool("hasPortedLegacyData") ?? false) {
        if (kDebugMode) {
          print("Already Ported Legacy Data");
        }
        return;
      }

      NativeSharedPreferences prefs =
          await NativeSharedPreferences.getInstance();
      final allClassKeys = prefs.get('allNames') as List<dynamic>;

      for (final key in allClassKeys) {
        try {
          final String classString =
              utf8.decode(prefs.get('KEY_$key') as List<int>);
          final JsonData jsonMap = json.decode(classString);
          final Class newClass = parseLegacyClass(jsonMap);
          DataLoader.addClassId(newClass.id);
          DataLoader.saveClass(newClass);
          if (kDebugMode) {
            print("Parsed and saved legacy Class: $key");
          }
        } catch (e) {
          if (kDebugMode) {
            print("Something went wrong while parsing legacy Class: $e");
          }
        }
      }

      userDefaults.setBool("hasPortedLegacyData", true);
    } catch (e) {
      if (kDebugMode) {
        print("Something went wrong while Porting Legacy Data: $e");
      }
    }
  }

  static Class parseLegacyClass(JsonData json) {
    // previously only premiere classes had exams and semesters,
    // so for all classes json["trimesters"].length == 3
    bool hasExams = json["isPremiere"] ?? false;

    List<Semester> semesters = [];
    List<SemesterMetaModel> semesterMetaModels =
        Class.calcSemesterMetaModels(hasExams, hasExams);
    int semesterIndex = 0;
    Map<String, int> subjectIdMap = {};
    for (JsonData sem in json["trimesters"] as List<dynamic>) {
      List<Subject> subs = (sem["subjects"] as List<dynamic>)
          .map((e) => parseSubject(e, subjectIdMap))
          .toList();
      SemesterMetaModel currentMetaModel = semesterMetaModels[semesterIndex];
      semesters.add(Semester(
        name: currentMetaModel.name,
        coef: currentMetaModel.coef,
        subjects: subs,
      ));
      semesterIndex++;
    }

    return Class(name: json["name"], semesters: semesters);
  }

  static Subject parseSubject(JsonData json, Map<String, int> subjectIdMap) {
    int id = randomId();
    if (subjectIdMap.keys.contains(json["name"])) {
      id = subjectIdMap[json["name"]]!;
    } else {
      subjectIdMap[json["name"]] = id;
    }

    final combis = json["combiSubjects"];
    if (combis == null) {
      final tests =
          (json["tests"] as List<dynamic>).map((e) => parseTest(e)).toList();
      return SimpleSubject(
          id: id,
          name: json["name"],
          coef: (json["coef"] as int).toDouble(),
          simpleTests: tests,
          plusPoints: (json["plusPoints"] as int).toDouble());
    }
    final subSubjects = (combis["subjects"] as List<dynamic>)
        .map((e) => parseSubject(e, subjectIdMap) as SimpleSubject)
        .toList();
    return CombiSubject(
      id: id,
      name: json["name"],
      coef: (json["coef"] as int).toDouble(),
      subSubjects: subSubjects,
    );
  }

  static Test parseTest(JsonData json) {
    return Test(
      name: "Test",
      grade: (json["grade"] as int).toDouble(),
      maxGrade: (json["maxGrade"] as int).toDouble(),
    );
  }
}
