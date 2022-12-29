import 'package:flutter/cupertino.dart';

/// A Custom ListSection with optional header and footer
class CustomCupertinoListSection extends StatelessWidget {
  final List<Widget> children;
  final String? header;
  final String? footer;
  const CustomCupertinoListSection({
    required this.children,
    this.header,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: (header == null)
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                header!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
      footer: (footer == null)
          ? null
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                footer!,
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
      children: children,
    );
  }
}
