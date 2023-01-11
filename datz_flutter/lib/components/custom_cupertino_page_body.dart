import 'package:flutter/cupertino.dart';

/// A wrapper Widget for my common cupertino page design needs.
///
/// Includes a Scrollview dismissing the keyboard, SafeArea and a maxWidth of 600.
class CustomCupertinoPageBody extends StatelessWidget {
  final Widget child;
  final bool needsSafeArea;
  const CustomCupertinoPageBody({
    super.key,
    required this.child,
    this.needsSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!needsSafeArea) {
      return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: child,
          ),
        ),
      ),
    );
  }
}
