import 'package:datz_flutter/components/forms/simple_stepper.dart';
import 'package:flutter/cupertino.dart';

void alertFormError(BuildContext context, String message) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

class NumberFieldFormRow extends StatelessWidget {
  const NumberFieldFormRow({
    super.key,
    required this.title,
    required this.controller,
    this.placeholder,
  });

  final TextEditingController controller;
  final Widget title;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: title,
      trailing: SizedBox(
        width: 64,
        child: CupertinoTextField(
          placeholder: placeholder,
          autocorrect: false,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          // controller: TextEditingController(text: "Test 1"),
        ),
      ),
    );
  }
}

class TextFieldFormRow extends StatelessWidget {
  const TextFieldFormRow({
    super.key,
    required this.title,
    required this.controller,
    this.placeholder,
  });

  final TextEditingController controller;
  final Widget title;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: title,
      trailing: SizedBox(
        width: 128,
        child: CupertinoTextField(
          autocorrect: false,
          placeholder: placeholder,
          controller: controller,
        ),
      ),
    );
  }
}

class BoolFieldFormRow extends StatelessWidget {
  const BoolFieldFormRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final Widget title;
  final bool value;
  final void Function(bool newVal) onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: title,
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class StepperFieldFormRow extends StatelessWidget {
  const StepperFieldFormRow({
    super.key,
    required this.title,
    required this.value,
    this.minValue,
    this.maxValue,
    required this.onChanged,
  });

  final Widget title;
  final int value;
  final int? minValue;
  final int? maxValue;
  final void Function(int newValue) onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile.notched(
      title: title,
      trailing: SimpleStepper(
        value: value,
        minValue: minValue,
        maxValue: maxValue,
        onChanged: onChanged,
        child: Text(
          "$value",
          style: CupertinoTheme.of(context).textTheme.textStyle,
        ),
      ),
    );
  }
}
