import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/subject_model.dart';
import 'package:flutter/cupertino.dart';

class ClassCreationModel {
  late TextEditingController nameController;
  late bool useSemesters;
  late bool hasExams;
  late List<SubjectCreationModel> subjects;
  ClassCreationModel({
    required this.useSemesters,
    required this.hasExams,
    List<SubjectCreationModel>? subjects,
  }) {
    nameController = TextEditingController();
    this.subjects = subjects ?? [];
  }

  String? validate() {
    if (nameController.value.text == "") {
      return "Classname cannot be empty.";
    }
    if (subjects.isEmpty) {
      return "Add at least one sujects.";
    }

    for (SubjectCreationModel s in subjects) {
      if (s.nameController.value.text == "") {
        return "Subjectname cannot be empty.";
      }
      if (s.subSubjects == null) continue;

      for (SubjectCreationModel sub in s.subSubjects!) {
        if (sub.nameController.value.text == "") {
          return "Subjectname cannot be empty.";
        }
      }
    }
    return null;
  }

  ClassCreationModel.fromClassModel(Class c) {
    nameController = TextEditingController(text: c.name);
    useSemesters = c.usesSemesters();
    hasExams = c.hasExams();
    subjects = c.semesters.first.subjects
        .map((s) => SubjectCreationModel.fromSubjectModel(s))
        .toList();
  }

  ClassMetaModel parseToMetaModel() {
    return ClassMetaModel(
      name: nameController.value.text,
      useSemesters: useSemesters,
      hasExams: hasExams,
      subjects: parseToSubjectMetaModel(),
    );
  }

  List<SubjectMetaModel> parseToSubjectMetaModel() {
    List<SubjectMetaModel> subjectModels = [];
    for (SubjectCreationModel s in subjects) {
      subjectModels.add(s.parseToSubjectMetaModel());
    }
    return subjectModels;
  }

  void removeSubject(int subjectId) {
    subjects.removeWhere((s) => s.id == subjectId);
  }

  void addSimpleSubject() {
    subjects.add(
      SubjectCreationModel(),
    );
  }

  void addCombiSubject() {
    subjects.add(
      SubjectCreationModel(
        subSubjects: [
          SubjectCreationModel(),
        ],
      ),
    );
  }
}

class SubjectCreationModel {
  late int id;
  late TextEditingController nameController;
  late int coef;
  List<SubjectCreationModel>? subSubjects;

  SubjectCreationModel({
    int? id,
    TextEditingController? nameController,
    this.coef = 1,
    this.subSubjects,
  }) {
    this.id = id ?? randomId();
    this.nameController = nameController ?? TextEditingController();
  }

  SubjectCreationModel.fromSubjectModel(Subject s) {
    id = s.id;
    nameController = TextEditingController(text: s.name);
    coef = s.coef.toInt();

    if (s is CombiSubject) {
      subSubjects = s.subSubjects
          .map((s) => SubjectCreationModel.fromSubjectModel(s))
          .toList();
    }
  }

  SubjectMetaModel parseToSubjectMetaModel() {
    if (subSubjects == null) {
      return SubjectMetaModel(
        name: nameController.value.text,
        coef: coef.toDouble(),
        id: id,
      );
    } else {
      List<SubjectMetaModel> subSubjectsModels = [];
      for (SubjectCreationModel subModel in subSubjects!) {
        subSubjectsModels.add(SubjectMetaModel(
          name: subModel.nameController.value.text,
          coef: subModel.coef.toDouble(),
          id: subModel.id,
        ));
      }
      return (SubjectMetaModel(
        name: nameController.value.text,
        coef: coef.toDouble(),
        subSubjects: subSubjectsModels,
        id: id,
      ));
    }
  }

  void addSubSubject() {
    if (subSubjects == null) return;
    subSubjects!.add(SubjectCreationModel(
      nameController: TextEditingController(),
    ));
  }

  void removeSubSubject() {
    if (subSubjects == null) return;
    subSubjects!.removeLast();
  }
}
