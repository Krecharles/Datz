import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSliver extends StatelessWidget {
  final double minExtent, maxExtent;
  final Widget body;
  final Function buildHeader;

  const CustomSliver({
    super.key,
    required this.minExtent,
    required this.maxExtent,
    required this.buildHeader,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // A list of sliver widgets.
      slivers: <Widget>[
        SliverPersistentHeader(
          delegate: SliverDelegate(
            minExtent: minExtent,
            maxExtent: maxExtent,
            buildHeader: buildHeader,
          ),
          pinned: true,
        ),
        // This widget fills the remaining space in the viewport.
        // Drag the scrollable area to collapse the CupertinoSliverNavigationBar.
        SliverFillRemaining(hasScrollBody: false, child: body)
      ],
    );
  }
}

class SliverDelegate implements SliverPersistentHeaderDelegate {
  @override
  final double minExtent;
  @override
  final double maxExtent;
  final Function buildHeader;
  SliverDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.buildHeader,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return buildHeader(context, shrinkOffset);
  }

  /// returns 1 if not shrunk at all, and 0 if fully shrunk
  double shrinkRatio(double shrinkOffset) {
    return clampDouble(1 - shrinkOffset / maxExtent, 0, 1);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration =>
      const PersistentHeaderShowOnScreenConfiguration();

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();

  @override
  TickerProvider? get vsync => throw UnimplementedError();
}
