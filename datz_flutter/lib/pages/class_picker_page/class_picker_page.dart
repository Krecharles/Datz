import 'package:cloud_functions/cloud_functions.dart';
import 'package:datz_flutter/components/custom_cupertino_list_section.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/slidables.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/pages/edit_class_page/edit_class_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// A Page that lets the select the current class.
///
/// Invoques [DataLoader.loadAllClassMetaModels] and [DataLoader.loadAllClasses].
/// Invoques [ClassProvider.selectClass] and [ClassProvider.createAndSelectClass].
class ClassPickerPage extends StatefulWidget {
  /// Is called when the user has selected a class.
  ///
  /// Should be used to pop this page.
  /// Functionality is needed for showing Picker when no class is selected on
  /// initial startup.
  final void Function(BuildContext context)? onExit;

  const ClassPickerPage({
    super.key,
    this.onExit,
  });

  @override
  State<ClassPickerPage> createState() => _ClassPickerPageState();
}

class _ClassPickerPageState extends State<ClassPickerPage> {
  List<ClassMetaModel> _allClassMetaModels = [];
  List<Class> _userClasses = [];
  String _searchTerm = "";

  /// Repopulates
  void loadData() async {
    if (kDebugMode) {
      print("Loading all class models");
    }
    _allClassMetaModels = await DataLoader.loadAllClassMetaModels();
    _userClasses = await DataLoader.loadAllClasses();
    if (kDebugMode) {
      print("finished Loading Class Picker Data.");
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();

    // Make sure that LegacyDataLoader has finished its work.
    Future.delayed(const Duration(milliseconds: 300), loadData);

    FirebaseAnalytics.instance.logScreenView(screenName: "Class Picker");
  }

  void onSelectUserClass(Class c) {
    context.read<ClassProvider>().selectClass(c);
    widget.onExit?.call(context);
  }

  void onSelectNewClass(ClassMetaModel classData) {
    context.read<ClassProvider>().createAndSelectClass(classData);
    widget.onExit?.call(context);
  }

  onDeleteClass(Class c) {
    final classProvider = context.read<ClassProvider>();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text('Delete Class ${c.name}?'),
        content: const Text('Data in this class will be lost forever.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              classProvider.deleteClass(context, c.id);
              loadData();
            },
            child: const Text('Delete'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  onCreateOwnClass(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => EditClassPage(
          onSubmit: (metaModel, reportAsError) {
            if (reportAsError) {
              if (kDebugMode) {
                print("Sending created class meta model to server");
              }

              FirebaseFunctions.instanceFor(region: "europe-west3")
                  .httpsCallable('addMissingClassModel')
                  .call(metaModel.toString());
            }

            context
                .read<ClassProvider>()
                .createAndSelectClass(metaModel, isCustomModel: true);

            Navigator.pop(context); // pop EditClasspage
            Navigator.pop(context); // pop Picker
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text(
          "Select Class",
        ),
      ),
      child: CustomCupertinoPageBody(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CupertinoSearchTextField(
                onChanged: (String s) => setState(() {
                  _searchTerm = s.toUpperCase();
                }),
              ),
            ),
            buildUserClasses(context),
            buildPresetClasses(context),
            buildCreateClassButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildUserClasses(BuildContext context) {
    var classes = _userClasses
        .where((c) => c.name.toUpperCase().contains(_searchTerm))
        .toList();
    classes.sort((a, b) => b.name.compareTo(a.name));

    if (classes.isEmpty) return Container();
    final provider = context.watch<ClassProvider>();
    return CustomCupertinoListSection(
      header: "Your Classes",
      children: [
        for (final c in classes)
          CustomSlidable(
            onDelete: (context) => onDeleteClass(c),
            child: CupertinoListTile.notched(
              onTap: () => onSelectUserClass(c),
              title: c.id == provider.selectedClass?.id
                  ? Text(
                      c.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : Text(c.name),
            ),
          ),
      ],
    );
  }

  Widget buildPresetClasses(BuildContext context) {
    var classes = _allClassMetaModels
        .where((c) => c.name.toUpperCase().contains(_searchTerm))
        .toList();
    classes.sort((a, b) => b.name.compareTo(a.name));

    if (classes.isEmpty) return Container();

    return CustomCupertinoListSection(
      header: "Preset Classes",
      children: [
        for (final m in classes)
          CupertinoListTile.notched(
            onTap: () => onSelectNewClass(m),
            title: Text(m.name),
          ),
      ],
    );
  }

  Widget buildCreateClassButton(BuildContext context) {
    return CustomCupertinoListSection(
      header: "Nothing Found?",
      children: [
        CupertinoListTile.notched(
          title: const Text("Create your own"),
          onTap: () => onCreateOwnClass(context),
          trailing: const CupertinoListTileChevron(),
        ),
      ],
    );
  }
}
