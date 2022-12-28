import 'package:datz_flutter/components/buttons.dart';
import 'package:flutter/cupertino.dart';

class SimpleStepper extends StatelessWidget {
  final int value;
  final void Function(int newValue) onChanged;
  final int? minValue;
  final int? maxValue;
  final Widget? child;

  const SimpleStepper({
    super.key,
    this.value = 0,
    this.minValue,
    this.maxValue,
    required this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: Button(
            text: "-",
            onPressed: () {
              if (minValue != null && value - 1 >= minValue!) {
                onChanged(value - 1);
              }
            },
            type: ButtonType.tinted,
            padding: const EdgeInsets.all(0),
          ),
        ),
        const SizedBox(width: 8),
        if (child != null) ...[
          child!,
          const SizedBox(width: 8),
        ],
        SizedBox(
          height: 30,
          child: Button(
            text: "+",
            onPressed: () {
              if (maxValue != null && value + 1 <= maxValue!) {
                onChanged(value + 1);
              }
            },
            type: ButtonType.tinted,
            padding: const EdgeInsets.all(0),
          ),
        ),
      ],
    );
  }
}
