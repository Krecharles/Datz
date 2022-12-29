import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/pages/edit_class_page/class_creation_model.dart';
import 'package:flutter/cupertino.dart';

/// A page used for both Class creation and modification.
///
/// Modification works by copying the data given by [classCreationModel] into
/// the form values and keeping track of its id.
/// One can create a ClassCreationModel from a [Class] via
/// [ClassCreationModel.fromClassModel].
///
/// This Widget uses a [ClassCreationModel] to keep its state. This should be
/// the only use of said model.

// ignore: must_be_immutable
class EditClassPage extends StatefulWidget {
  final void Function(ClassMetaModel classMetaModel, bool reportAsError)
      onSubmit;
  late ClassCreationModel classCreationModel;
  late bool isCreatingNewClass;

  EditClassPage({
    super.key,
    ClassCreationModel? classCreationModel,
    required this.onSubmit,
  }) {
    this.classCreationModel = classCreationModel ??
        ClassCreationModel(
          useSemesters: true,
          hasExams: false,
        );
    isCreatingNewClass = classCreationModel == null;
  }

  @override
  State<EditClassPage> createState() => _EditClassPageState();
}

class _EditClassPageState extends State<EditClassPage> {
  bool _reportErrors = false;

  /// checks if there are validation errors, calls
  /// [ClassCreationModel.parseToMetaModel] and calls
  /// [widget.onSubmit] if there are no errors
  void onSubmit() {
    String? errorMessage = widget.classCreationModel.validate();
    if (errorMessage != null) {
      return alertFormError(context, errorMessage);
    }
    ClassMetaModel metaModel = widget.classCreationModel.parseToMetaModel();

    widget.onSubmit(metaModel, _reportErrors);
  }

  void removeSubject(int subjectId) {
    setState(() {
      widget.classCreationModel.removeSubject(subjectId);
    });
  }

  void addSimpleSubject() {
    setState(() {
      widget.classCreationModel.addSimpleSubject();
    });
  }

  void addCombiSubject() {
    setState(() {
      widget.classCreationModel.addCombiSubject();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text(
          "Edit Class",
        ),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            buildGeneralInformationForm(),
            buildSubjectsList(),
            const SizedBox(height: 32),
            CustomCupertinoListSection(
              footer:
                  "If you disagree with the preset class, please tick this box so that your changes will be reported to the developer.",
              children: [
                BoolFieldFormRow(
                  title: Text(widget.isCreatingNewClass
                      ? "Report as missing Class"
                      : "Report as Mistake in Preset"),
                  value: _reportErrors,
                  onChanged: (newVal) => setState(() => _reportErrors = newVal),
                )
              ],
            ),
            const SizedBox(height: 32),
            buildSubmitButtonRow(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget buildGeneralInformationForm() {
    return CustomCupertinoListSection(
      children: [
        TextFieldFormRow(
          controller: widget.classCreationModel.nameController,
          title: const Text("Name"),
          placeholder: "3MB",
        ),
        BoolFieldFormRow(
          title: const Text("Use Semesters"),
          value: widget.classCreationModel.useSemesters,
          onChanged: (newVal) => setState(() {
            widget.classCreationModel.useSemesters = newVal;
            // do not allow both Trimesters and Exams.
            if (!widget.classCreationModel.useSemesters &&
                widget.classCreationModel.hasExams) {
              widget.classCreationModel.hasExams = false;
            }
          }),
        ),
        BoolFieldFormRow(
          title: const Text("Has Exams"),
          value: widget.classCreationModel.hasExams,
          onChanged: (newVal) => setState(() {
            widget.classCreationModel.hasExams = newVal;
            // do not allow both Trimesters and Exams.
            if (!widget.classCreationModel.useSemesters &&
                widget.classCreationModel.hasExams) {
              widget.classCreationModel.useSemesters = true;
            }
          }),
        ),
      ],
    );
  }

  Widget buildSubjectsList() {
    return Column(
      children: [
        for (SubjectCreationModel subjectModel
            in widget.classCreationModel.subjects)
          CustomCupertinoListSection(
            children: [
              TextFieldFormRow(
                controller: subjectModel.nameController,
                title: const Text("Subject Name"),
                placeholder: "Allemand",
              ),
              StepperFieldFormRow(
                title: const Text("Coefficient"),
                value: subjectModel.coef,
                minValue: 1,
                maxValue: 99,
                onChanged: (int newValue) => setState(() {
                  subjectModel.coef = newValue;
                }),
              ),
              if (subjectModel.subSubjects != null) ...[
                StepperFieldFormRow(
                  title: const Text("Combi Subjects"),
                  value: subjectModel.subSubjects!.length,
                  minValue: 1,
                  maxValue: 9,
                  onChanged: (int newValue) => setState(() {
                    if (newValue > subjectModel.subSubjects!.length) {
                      subjectModel.addSubSubject();
                    }
                    if (newValue < subjectModel.subSubjects!.length) {
                      subjectModel.removeSubSubject();
                    }
                  }),
                ),
                for (SubjectCreationModel subSubjectModel
                    in subjectModel.subSubjects!)
                  ...buildSubSubject(subSubjectModel),
              ],
              CupertinoListTile.notched(
                title: Center(
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        color: CupertinoColors.systemRed.resolveFrom(context)),
                  ),
                ),
                onTap: () => removeSubject(subjectModel.id),
              )
            ],
          ),
      ],
    );
  }

  List<Widget> buildSubSubject(SubjectCreationModel subSubjectModel) {
    return [
      TextFieldFormRow(
        controller: subSubjectModel.nameController,
        title: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Subject Name"),
        ),
        placeholder: "Allemand",
      ),
      StepperFieldFormRow(
        title: const Padding(
          padding: EdgeInsets.only(left: 24.0),
          child: Text("Coefficient"),
        ),
        value: subSubjectModel.coef,
        minValue: 1,
        maxValue: 99,
        onChanged: (int newValue) => setState(() {
          subSubjectModel.coef = newValue;
        }),
      ),
    ];
  }

  Widget buildSubmitButtonRow(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              type: ButtonType.tinted,
              text: "Subject",
              leadingIcon: CupertinoIcons.add,
              onPressed: addSimpleSubject,
              // leadingIcon: CupertinoIcons.add,
            ),
            const SizedBox(width: 8),
            Button(
              type: ButtonType.plain,
              text: "Combi",
              leadingIcon: CupertinoIcons.add,
              onPressed: addCombiSubject,
              // leadingIcon: CupertinoIcons.add,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              type: ButtonType.filled,
              text: "Save",
              onPressed: onSubmit,
              // leadingIcon: CupertinoIcons.add,
            ),
          ],
        ),
      ],
    );
  }
}
