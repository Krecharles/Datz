import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/pages/edit_class_page/class_creation_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.back,
        middle: Text(
          AppLocalizations.of(context)!.editClass,
        ),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            buildGeneralInformationForm(),
            buildSubjectsList(),
            const SizedBox(height: 32),
            CustomCupertinoListSection(
              footer: AppLocalizations.of(context)!.reportAsMistakeDesciption,
              children: [
                BoolFieldFormRow(
                  title: Text(widget.isCreatingNewClass
                      ? AppLocalizations.of(context)!.reportAsMissing
                      : AppLocalizations.of(context)!.reportAsMistake),
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
          title: Text(AppLocalizations.of(context)!.name),
          placeholder: "3MB",
        ),
        BoolFieldFormRow(
          title: Text(AppLocalizations.of(context)!.useSemesters),
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
          title: Text(AppLocalizations.of(context)!.hasExams),
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
                title: Text(AppLocalizations.of(context)!.subjectName),
                placeholder: "Allemand",
              ),
              StepperFieldFormRow(
                title: Text(AppLocalizations.of(context)!.coefficient),
                value: subjectModel.coef,
                minValue: 1,
                maxValue: 99,
                onChanged: (int newValue) => setState(() {
                  subjectModel.coef = newValue;
                }),
              ),
              if (subjectModel.subSubjects != null) ...[
                StepperFieldFormRow(
                  title: Text(AppLocalizations.of(context)!.combiSubjects),
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
                    AppLocalizations.of(context)!.delete,
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
        title: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(AppLocalizations.of(context)!.subjectName),
        ),
        placeholder: "Allemand",
      ),
      StepperFieldFormRow(
        title: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Text(AppLocalizations.of(context)!.coefficient),
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
              text: AppLocalizations.of(context)!.subject,
              leadingIcon: CupertinoIcons.add,
              onPressed: addSimpleSubject,
              // leadingIcon: CupertinoIcons.add,
            ),
            const SizedBox(width: 8),
            Button(
              type: ButtonType.plain,
              text: AppLocalizations.of(context)!.combi,
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
              text: AppLocalizations.of(context)!.save,
              onPressed: onSubmit,
              // leadingIcon: CupertinoIcons.add,
            ),
          ],
        ),
      ],
    );
  }
}
