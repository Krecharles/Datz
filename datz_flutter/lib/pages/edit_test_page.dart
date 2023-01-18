import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/forms/form_rows.dart';
import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/consts.dart';
import 'package:datz_flutter/model/test_model.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A page used for both Test creation and modification.
///
/// Modification works by copying the data given by [editTest] into the form
/// values and keeping track of its id. [onSubmit] is called once the user is
/// done and before the page has popped itself.
class TestEditPage extends StatefulWidget {
  /// indicates whether it is a new test or modifying an existing one
  final Test? editTest;
  final void Function(Test) onSubmit;

  const TestEditPage({
    super.key,
    this.editTest,
    required this.onSubmit,
  });

  @override
  State<TestEditPage> createState() => _TestEditPageState();
}

class _TestEditPageState extends State<TestEditPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();
  TextEditingController _maxGradeController = TextEditingController();
  TextEditingController _fixedContribTestController = TextEditingController();
  bool _moreOptions = false;

  @override
  void initState() {
    super.initState();

    String? grade;
    String? maxGrade = "60";
    if (widget.editTest != null) {
      grade = Formatter.formatDecimalNumber(widget.editTest!.grade);
      maxGrade = Formatter.formatDecimalNumber(widget.editTest!.maxGrade);
    }

    _nameController =
        TextEditingController(text: widget.editTest?.name ?? "Test");
    _gradeController = TextEditingController(text: grade);
    _maxGradeController = TextEditingController(text: maxGrade);
    final test = widget.editTest;
    if (test is FixedContributionTest) {
      _moreOptions = true;
      _fixedContribTestController =
          TextEditingController(text: test.getContributionFractionString());
    }
  }

  void onSubmit() {
    if (_nameController.value.text == "") {
      return alertFormError(
          context, AppLocalizations.of(context)!.nameCannotBeEmpty);
    }
    String gradeString = _gradeController.value.text.replaceAll(",", ".");
    String maxGradeString = _maxGradeController.value.text.replaceAll(",", ".");
    if (double.tryParse(gradeString) == null) {
      return alertFormError(
          context, AppLocalizations.of(context)!.gradeMustBeNumber);
    }
    if (double.tryParse(maxGradeString) == null) {
      return alertFormError(
          context, AppLocalizations.of(context)!.maxGradeMustBeNumber);
    }

    if (!_moreOptions) {
      Test newTest = Test(
        id: widget.editTest?.id,
        name: _nameController.value.text,
        grade: double.parse(gradeString),
        maxGrade: double.parse(maxGradeString),
      );
      widget.onSubmit(newTest);
      Navigator.pop(context);
      return;
    }

    try {
      final vals = FixedContributionTest.parseStringToFraction(
          _fixedContribTestController.value.text);
      final top = vals[0];
      final bottom = vals[1];
      if (top <= 0 ||
          bottom <= 0 ||
          top.toDouble() / bottom.toDouble() <= 0 ||
          top.toDouble() / bottom.toDouble() >= 1) throw "Invalid Input";

      Test newTest = FixedContributionTest(
        id: widget.editTest?.id,
        name: _nameController.value.text,
        grade: double.parse(_gradeController.value.text),
        maxGrade: double.parse(_maxGradeController.value.text),
        contributionFractionTop: vals[0],
        contributionFractionBottom: vals[1],
      );
      widget.onSubmit(newTest);
      Navigator.pop(context);
      return;
    } catch (e) {
      return alertFormError(context, e.toString());
    }
  }

  bool isHandlingGivenFixedContribTest() {
    return widget.editTest is FixedContributionTest;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: AppLocalizations.of(context)!.back,
        middle: Text(
          widget.editTest == null
              ? AppLocalizations.of(context)!.addTest
              : AppLocalizations.of(context)!.editTest,
        ),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            buildInputForm(),
            const SizedBox(height: 32),
            if (widget.editTest == null || isHandlingGivenFixedContribTest())
              buildComplexForm(),
            const SizedBox(height: 32),
            buildSubmitButtonRow(context),
          ],
        ),
      ),
    );
  }

  Widget buildInputForm() {
    return CustomCupertinoListSection(
      children: [
        TextFieldFormRow(
            title: Text(AppLocalizations.of(context)!.name),
            controller: _nameController),
        NumberFieldFormRow(
            title: Text(AppLocalizations.of(context)!.grade),
            placeholder: "45",
            controller: _gradeController),
        NumberFieldFormRow(
            title: Text(AppLocalizations.of(context)!.maxGrade),
            controller: _maxGradeController),
      ],
    );
  }

  Widget buildComplexForm() {
    return CustomCupertinoListSection(
      footer: AppLocalizations.of(context)!.fixedContribExplanation,
      children: [
        BoolFieldFormRow(
          title: Text(AppLocalizations.of(context)!.moreOptions),
          value: _moreOptions,
          onChanged: (newVal) => setState(() {
            if (!isHandlingGivenFixedContribTest()) _moreOptions = newVal;
          }),
        ),
        if (_moreOptions)
          TextFieldFormRow(
            title: Text(AppLocalizations.of(context)!.fixedContrib),
            placeholder: "1/3",
            controller: _fixedContribTestController,
          ),
      ],
    );
  }

  Widget buildSubmitButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Button(
          type: ButtonType.filled,
          text: widget.editTest == null
              ? AppLocalizations.of(context)!.add
              : AppLocalizations.of(context)!.save,
          onPressed: onSubmit,
          // leadingIcon: CupertinoIcons.add,
        ),
        if (widget.editTest != null) ...[
          const SizedBox(width: 4),
          Button(
            type: ButtonType.plain,
            color: CupertinoColors.systemRed,
            text: AppLocalizations.of(context)!.delete,
            onPressed: () {
              context.read<ClassProvider>().deleteTest(widget.editTest!.id);
              Navigator.pop(context);
            },
            // leadingIcon: CupertinoIcons.trash,
          ),
        ]
      ],
    );
  }
}
