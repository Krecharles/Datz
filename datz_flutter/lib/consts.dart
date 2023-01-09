import 'package:flutter/cupertino.dart';

class CustomColors {
  static const color1 = CupertinoDynamicColor.withBrightness(
      color: Color(0xFF848BAD), darkColor: Color(0xFF636880));
  static const color2 = CupertinoDynamicColor.withBrightness(
      color: Color(0xFFBA9DB3), darkColor: Color(0xFF8D6584));
  static const colorMid = CupertinoDynamicColor.withBrightness(
      color: Color(0xFF9F92B2), darkColor: Color(0xFF796583));

  static Color backgroundColor(BuildContext context) {
    return CupertinoDynamicColor.withBrightness(
      color: CupertinoColors.white,
      darkColor: CupertinoColors.systemGrey6.darkColor,
    ).resolveFrom(context);
  }
}

class CustomDecorations {
  static BoxDecoration primaryGradientDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          CustomColors.color1.resolveFrom(context),
          CustomColors.color2.resolveFrom(context)
        ],
        stops: const [0, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        tileMode: TileMode.repeated,
      ),
    );
  }

  static BoxDecoration primaryContainer(BuildContext context) {
    return BoxDecoration(
      color: CustomColors.backgroundColor(context),
      borderRadius: const BorderRadius.all(Radius.circular(14)),
    );
  }
}

class Formatter {
  /// 15 -> "15", 15.5 -> "15.50"
  static String formatDecimalNumber(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }
}
