import 'package:datz_flutter/model/class_model.dart';
import 'package:flutter/foundation.dart';

class Test {
  late String name;
  late double grade;
  late double maxGrade;
  late int id;
  Test(
      {required this.name,
      required this.grade,
      required this.maxGrade,
      int? id}) {
    this.id = id ?? randomId();
  }

  Test.fromJson(Map<String, dynamic> json) {
    try {
      name = json["name"];
      grade = json["grade"];
      maxGrade = json["maxGrade"];
      id = json["id"];
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Test $name: $e");
      }
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'grade': grade,
        'maxGrade': maxGrade,
      };
}

class FixedContributionTest extends Test {
  /// e.g contributionFractionTop / ContributionFraction Bottom = 1 / 3
  late int contributionFractionTop;
  late int contributionFractionBottom;
  FixedContributionTest(
      {required super.name,
      required super.grade,
      required super.maxGrade,
      required this.contributionFractionTop,
      required this.contributionFractionBottom,
      int? id})
      : super(id: id);

  FixedContributionTest.fromJson(Map<String, dynamic> json)
      : super(grade: 0, maxGrade: 0, name: "") {
    try {
      name = json["name"];
      grade = json["grade"];
      maxGrade = json["maxGrade"];
      id = json["id"];
      contributionFractionTop = json["contributionFractionTop"];
      contributionFractionBottom = json["contributionFractionBottom"];
    } catch (e) {
      if (kDebugMode) {
        print("There was an error trying to parse Test $name: $e");
      }
      rethrow;
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'grade': grade,
        'maxGrade': maxGrade,
        'contributionFractionTop': contributionFractionTop,
        'contributionFractionBottom': contributionFractionBottom,
      };

  double calculateContribution() {
    return contributionFractionTop.toDouble() /
        contributionFractionBottom.toDouble();
  }

  String getContributionFractionString() {
    return "$contributionFractionTop / $contributionFractionBottom";
  }

  /// returns a List [a, b] where a is the top fraction and b is the bottom one
  /// can throw errors if it is not possible
  static List<int> parseStringToFraction(String string) {
    final parts = string.replaceAll(" ", "").split("/");
    if (parts.length != 2) throw "Fraction input needs to have exactly one '/'";
    try {
      final left = int.parse(parts[0]);
      final right = int.parse(parts[1]);
      return [left, right];
    } catch (e) {
      throw "Unable to parse input into a number.";
    }
  }
}
