import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ButtonType { filled, tinted, gray, plain }

class Button extends StatelessWidget {
  final ButtonType type;
  final String text;
  final IconData? leadingIcon;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final CupertinoDynamicColor color;

  const Button({
    super.key,
    required this.text,
    this.type = ButtonType.filled,
    this.leadingIcon,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
    this.color = CupertinoColors.systemBlue,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ButtonType.filled:
        return CupertinoButton(
          color: color,
          onPressed: onPressed,
          padding: padding,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon!,
                  size: 20,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      case ButtonType.tinted:
        return CupertinoButton(
          color: color.withOpacity(0.15),
          onPressed: onPressed,
          padding: padding,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon!,
                  size: 20,
                  color: CupertinoColors.systemBlue,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        );
      case ButtonType.plain:
        return CupertinoButton(
          color: Colors.transparent,
          onPressed: onPressed,
          padding: padding,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon!,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        );

      default:
        return CupertinoButton(
          color: CupertinoColors.systemFill.resolveFrom(context),
          onPressed: onPressed,
          padding: padding,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              if (leadingIcon != null) ...[
                Icon(
                  leadingIcon!,
                  size: 20,
                  color: color,
                ),
                const SizedBox(width: 10),
              ],
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        );
    }
  }
}
