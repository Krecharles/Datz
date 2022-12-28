import 'package:cloud_functions/cloud_functions.dart';
import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_sliver.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/pages/class_edit_page/class_creation_model.dart';
import 'package:datz_flutter/pages/class_edit_page/class_edit_page.dart';
import 'package:datz_flutter/pages/class_picker_page/class_picker_page.dart';
import 'package:datz_flutter/pages/home_page/home_page_sliver_header.dart';
import 'package:datz_flutter/pages/home_page/subject_list.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // void checkIfClassIsNone(BuildContext context) {
  //   final provider = context.watch<ClassProvider>();
  //   if (provider.selectedClass == null) {
  //     Navigator.push(
  //       context,
  //       CupertinoPageRoute(
  //           builder: (BuildContext context) => const ClassPickerPage()),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(
    //     const Duration(milliseconds: 50), () => checkIfClassIsNone(context));

    return CupertinoPageScaffold(
      child: CustomSliver(
        minExtent: 100,
        maxExtent: 300,
        buildHeader: (BuildContext context, double shrinkOffset) =>
            HomePageSliverHeader(shrinkOffset: shrinkOffset),
        body: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SubjectList(),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (provider.selectedClass != null) buildEditClassButton(context),
              buildChangeClassButton(context),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  void editClassMetaModel(
      BuildContext context, ClassMetaModel metaModel, bool reportAsError) {
    final provider = context.read<ClassProvider>();

    if (reportAsError) {
      if (kDebugMode) {
        print("Sending modified class meta model to server");
      }

      FirebaseFunctions.instanceFor(region: "europe-west3")
          .httpsCallable('addModifiedClassModel')
          .call(metaModel.toString());
    }

    provider.selectedClass!.applyMetaModelChanges(metaModel);
    provider.notifyListeners();
    Navigator.pop(context); // pop dialog
    Navigator.pop(context); // pop class edit page
  }

  void onEditClassMetaModel(
      BuildContext context, ClassMetaModel metaModel, bool reportAsError) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Edit class?'),
        content: const Text("This action cannot be undone."),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () =>
                editClassMetaModel(context, metaModel, reportAsError),
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget buildEditClassButton(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Button(
      text: "Edit",
      leadingIcon: CupertinoIcons.pen,
      type: ButtonType.tinted,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: ((context) => ClassEditPage(
                  classCreationModel: ClassCreationModel.fromClassModel(
                    provider.selectedClass!,
                  ),
                  allowClassMetaModelErrorReporting: true,
                  onSubmit: (ClassMetaModel metaModel, bool reportAsError) =>
                      onEditClassMetaModel(context, metaModel, reportAsError),
                )),
          ),
        );
      },
    );
  }

  Widget buildChangeClassButton(BuildContext context) {
    return Button(
      text: "Change Class",
      type: ButtonType.plain,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: ((context) => const ClassPickerPage()),
          ),
        );
      },
    );
  }
}
