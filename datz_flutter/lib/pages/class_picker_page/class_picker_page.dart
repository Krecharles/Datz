import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/model/class_model.dart';
import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/pages/class_edit_page/class_edit_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ClassPickerPage extends StatefulWidget {
  const ClassPickerPage({super.key});

  @override
  State<ClassPickerPage> createState() => _ClassPickerPageState();
}

class _ClassPickerPageState extends State<ClassPickerPage> {
  List<ClassMetaModel> _allClassMetaModels = [];
  List<Class> _userClasses = [];
  String _searchTerm = "";

  void loadData() async {
    _allClassMetaModels = await DataLoader.loadAllClassMetaModels();
    _userClasses = await DataLoader.loadAllClasses();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void onSelectUserClass(Class c) {
    Provider.of<ClassProvider>(context, listen: false).selectClass(c);
    Navigator.pop(context);
  }

  void onSelectNewClass(ClassMetaModel classData) {
    Class newClass = Class.fromMetaModel(classData);
    DataLoader.addClassId(newClass.id);
    DataLoader.saveActiveClassId(newClass.id);
    DataLoader.saveClass(newClass);

    Provider.of<ClassProvider>(context, listen: false).selectClass(newClass);
    Navigator.pop(context);
  }

  onDeleteClass(Class c) {
    final classProvider = Provider.of<ClassProvider>(context, listen: false);
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: "Back",
        middle: Text(
          "Select Class",
        ),
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
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
      ),
    );
  }

  Widget buildUserClasses(BuildContext context) {
    var classes =
        _userClasses.where((c) => c.name.contains(_searchTerm)).toList();
    classes.sort((a, b) => b.name.compareTo(a.name));
    if (classes.isEmpty) return Container();
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Your Classes",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      children: [
        for (final c in classes)
          Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => onDeleteClass(c),
                  backgroundColor: CupertinoColors.systemRed,
                  label: 'Delete',
                ),
              ],
            ),
            child: CupertinoListTile.notched(
              onTap: () => onSelectUserClass(c),
              title: Text(c.name),
            ),
          ),
      ],
    );
  }

  Widget buildPresetClasses(BuildContext context) {
    var classes =
        _allClassMetaModels.where((c) => c.name.contains(_searchTerm)).toList();
    classes.sort((a, b) => b.name.compareTo(a.name));
    if (classes.isEmpty) return Container();
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Preset Classes",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
      children: [
        for (final m in classes)
          CupertinoListTile.notched(
            onTap: () => onSelectNewClass(m),
            title: Text(m.name),
          ),
      ],
    );
  }

  onCreateOwnClass(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ClassEditPage(
          onSubmit: (metaModel) {
            Class newClass = Class.fromMetaModel(metaModel);
            DataLoader.addClassId(newClass.id);
            DataLoader.saveActiveClassId(newClass.id);
            DataLoader.saveClass(newClass);

            Provider.of<ClassProvider>(context, listen: false)
                .selectClass(newClass);
            Navigator.pop(context); // pop to class picker
            Navigator.pop(context); // pop to homepage
          },
        ),
      ),
    );
  }

  Widget buildCreateClassButton(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      header: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Nothing Found?",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
        ),
      ),
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
