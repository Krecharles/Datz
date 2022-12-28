import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SlidableListView extends StatefulWidget {
  const SlidableListView(
      {super.key, required this.children, this.headerLabelText});

  final List<Widget> children;
  final String? headerLabelText;

  @override
  State<SlidableListView> createState() => _SlidableListViewState();
}

class _SlidableListViewState extends State<SlidableListView> {
  final Set<SlidableController> _slidableControllers = {};
  late SlidableListProvider slidableListProvider;

  @override
  void initState() {
    super.initState();
    slidableListProvider =
        Provider.of<SlidableListProvider>(context, listen: false);
    slidableListProvider.subscribeEditModeListener(onChangeEditMode);
  }

  @override
  void dispose() {
    slidableListProvider.unSubscribeEditModeListener(onChangeEditMode);
    super.dispose();
  }

  void onChangeEditMode(bool isInEditMode) {
    if (isInEditMode) {
      showActions();
    } else {
      hideActions();
    }
  }

  void addController(SlidableController c) {
    _slidableControllers.add(c);
  }

  void removeController(SlidableController c) {
    _slidableControllers.remove(c);
  }

  void showActions() {
    for (final controller in _slidableControllers) {
      controller.openEndActionPane();
    }
  }

  void hideActions() {
    for (final controller in _slidableControllers) {
      controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: widget.headerLabelText == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                widget.headerLabelText!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
              ),
            ),
      children: [
        for (Widget child in widget.children) buildListTile(child),
      ],
    );
  }

  Widget buildListTile(Widget child) {
    return Slidable(
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: (BuildContext context) {},
            backgroundColor: CupertinoColors.systemBlue,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (BuildContext context) {},
            backgroundColor: CupertinoColors.systemRed,
            label: 'Delete',
          ),
        ],
      ),

      child: SlidableControllerSender(
        addController: addController,
        removeController: removeController,
        child: child,
      ),
    );
  }
}

class SlidableControllerSender extends StatefulWidget {
  const SlidableControllerSender({
    Key? key,
    this.child,
    required this.addController,
    required this.removeController,
  }) : super(key: key);

  final Widget? child;
  final Function addController;
  final Function removeController;

  @override
  // ignore: library_private_types_in_public_api
  _SlidableControllerSenderState createState() =>
      _SlidableControllerSenderState();
}

class _SlidableControllerSenderState extends State<SlidableControllerSender> {
  SlidableController? controller;

  @override
  void initState() {
    super.initState();
    controller = Slidable.of(context);
    widget.addController(controller);
  }

  @override
  void dispose() {
    widget.removeController(controller);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child!;
  }
}

class SlidableListProvider extends ChangeNotifier {
  bool isInEditMode;
  Set<Function> listeners = {};

  SlidableListProvider({this.isInEditMode = false});

  void toggleEditMode() {
    isInEditMode = !isInEditMode;
    notifyListeners();
    for (final listener in listeners) {
      listener(isInEditMode);
    }
  }

  void subscribeEditModeListener(Function callback) {
    listeners.add(callback);
  }

  void unSubscribeEditModeListener(Function callback) {
    listeners.remove(callback);
  }
}
