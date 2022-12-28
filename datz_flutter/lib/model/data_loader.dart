import 'dart:convert';

import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

import 'package:datz_flutter/model/class_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataLoader {
  static void saveActiveClassId(int activeId) async {
    final userDefaults = await SharedPreferences.getInstance();
    userDefaults.setInt("activeClassId", activeId);
  }

  /// to be called after launch
  static Future<Class?> loadCurrentClass() async {
    // saveClass(myClass);
    final userDefaults = await SharedPreferences.getInstance();
    final int? currentClassId = userDefaults.getInt("activeClassId");
    if (currentClassId == null) return null;
    return loadClass(currentClassId);
  }

  static Future<Class?> loadClass(int classId) async {
    try {
      final userDefaults = await SharedPreferences.getInstance();
      final classData =
          userDefaults.getString(generateClassUserDefaultsKey(classId));
      final c = Class.fromJson(json.decode(classData!));
      // print("Loaded class ${c.name} with id ${c.id}");
      return c;
    } catch (e) {
      if (kDebugMode) {
        print("Loading class $classId failed: $e");
      }
      return null;
    }
  }

  /// className needs to be escaped because user could enter
  /// a classname equal to another SharedPreferene keys
  static String generateClassUserDefaultsKey(int classId) {
    return "KEY_$classId";
  }

  /// to be called after each update on a class to make it persistent
  static void saveClass(Class c) async {
    final userDefaults = await SharedPreferences.getInstance();
    Map<String, dynamic> classJson = c.toJson();
    userDefaults.setString(
        generateClassUserDefaultsKey(c.id), json.encode(classJson).toString());
    if (kDebugMode) {
      print("Saved class ${c.name} with id ${c.id} successfully");
    }
  }

  static Future<List<ClassMetaModel>> loadAllClassMetaModels() async {
    if (kDebugMode) {
      print("Loading all classes metadata");
    }
    try {
      final String response =
          await rootBundle.loadString('assets/class_meta_data/allClasses.json');
      List<ClassMetaModel> allClassMetaModels = [];
      final List<dynamic> data = await json.decode(response);
      for (Map<String, dynamic> classData in data) {
        allClassMetaModels.add(ClassMetaModel.fromJson(classData));
      }
      return allClassMetaModels;
    } catch (e) {
      if (kDebugMode) {
        print("could not load Class Meta Models. $e");
      }
      rethrow;
    }
  }

  /// loads the ids of all the classes the users has created
  static Future<List<int>> loadAllClassIds() async {
    final userDefaults = await SharedPreferences.getInstance();
    final List<String>? classData = userDefaults.getStringList("allClassIds");
    if (classData == null) return [];
    List<int> out = [];
    for (final s in classData) {
      final id = int.tryParse(s);
      if (id != null) {
        out.add(id);
      } else if (kDebugMode) {
        print("Could not parse id $id");
      }
    }
    return out;
  }

  /// adds a new class id to the users created classes. If the id already exists
  /// nothing will happen
  static void addClassId(int newClassId) async {
    final userDefaults = await SharedPreferences.getInstance();
    final allIds = await loadAllClassIds();
    if (allIds.contains(newClassId)) return;
    allIds.add(newClassId);
    userDefaults.setStringList("allClassIds", allIds.map((e) => "$e").toList());
  }

  /// removes a  class id from the users created classes. If the id does not
  /// exist nothing will happen
  static void removeClassId(int classId) async {
    final userDefaults = await SharedPreferences.getInstance();
    final allIds = await loadAllClassIds();
    if (!allIds.contains(classId)) return;
    allIds.remove(classId);
    userDefaults.setStringList("allClassIds", allIds.map((e) => "$e").toList());
  }

  /// Loads every class the user has in persitent memory
  static Future<List<Class>> loadAllClasses() async {
    final allIds = await loadAllClassIds();
    List<Class> allClasses = [];
    for (final id in allIds) {
      Class? c = await loadClass(id);
      if (c != null) allClasses.add(c);
    }

    return allClasses;
  }

  /// Deletes a user created class, usually in the class picker page
  /// should be called in combination with removeClassId()
  static void deleteClass(int classId) async {
    try {
      final userDefaults = await SharedPreferences.getInstance();
      userDefaults.remove(generateClassUserDefaultsKey(classId));
    } catch (e) {
      if (kDebugMode) {
        print("Deleting class $classId failed: $e");
      }
      return null;
    }
  }
}
