import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// A Wrapper for [SlidableActions], providing implementation for [onDelete] and [onEdit]
class CustomSlidable extends StatelessWidget {
  final Widget child;
  final void Function(BuildContext context)? onDelete;
  final void Function(BuildContext context)? onEdit;
  const CustomSlidable({
    super.key,
    required this.child,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (context) => onEdit!(context),
              backgroundColor: CupertinoColors.systemBlue,
              label: 'Edit',
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (context) => onDelete!(context),
              backgroundColor: CupertinoColors.systemRed,
              label: 'Delete',
            ),
        ],
      ),
      child: child,
    );
  }
}
