import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/pages/class_edit_page/class_creation_model.dart';
import 'package:flutter/cupertino.dart';

class ClassEditPage extends StatefulWidget {
  final void Function(ClassMetaModel classMetaModel, bool reportAsError)?
      onSubmit;
  final bool? allowClassMetaModelErrorReporting;
  late ClassCreationModel classCreationModel = ClassCreationModel(
    useSemesters: true,
    hasExams: false,
  );

  ClassEditPage({
    super.key,
    ClassCreationModel? classCreationModel,
    this.onSubmit,
    this.allowClassMetaModelErrorReporting,
  }) {
    this.classCreationModel = classCreationModel ??
        ClassCreationModel(
          useSemesters: true,
          hasExams: false,
        );
  }

  @override
  State<ClassEditPage> createState() => _ClassEditPageState();
}

class _ClassEditPageState extends State<ClassEditPage> {
  bool _reportErrors = false;

  void onSubmit() {
    String? errorMessage = widget.classCreationModel.validate();
    if (errorMessage != null) {
      return alertError(context, errorMessage);
    }
    ClassMetaModel metaModel = widget.classCreationModel.parseToMetaModel();

    widget.onSubmit?.call(metaModel, _reportErrors);
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
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Form(
            child: Column(
              children: [
                buildGeneralInformationForm(),
                buildSubjectsList(),
                const SizedBox(height: 32),
                if (widget.allowClassMetaModelErrorReporting != null &&
                    widget.allowClassMetaModelErrorReporting!) ...[
                  CupertinoListSection.insetGrouped(
                    footer: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        "If your change reflects an error in the default class configuration, please tick this box so that it can be fixed in future versions.",
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: -0.08,
                          fontWeight: FontWeight.w400,
                          color: CupertinoColors.secondaryLabel
                              .resolveFrom(context)
                              .withOpacity(0.6),
                        ),
                      ),
                    ),
                    children: [
                      BoolFieldFormRow(
                        title: const Text("Report as Error"),
                        value: _reportErrors,
                        onChanged: (newVal) =>
                            setState(() => _reportErrors = newVal),
                      )
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
                buildSubmitButtonRow(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGeneralInformationForm() {
    return CupertinoListSection.insetGrouped(
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
          CupertinoListSection.insetGrouped(children: [
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
          ]),
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
