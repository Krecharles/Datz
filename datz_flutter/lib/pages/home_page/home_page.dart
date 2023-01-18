import 'package:cloud_functions/cloud_functions.dart';
import 'package:datz_flutter/components/buttons.dart';
import 'package:datz_flutter/components/custom_cupertino_page_body.dart';
import 'package:datz_flutter/components/custom_sliver.dart';
import 'package:datz_flutter/model/class_meta_model.dart';
import 'package:datz_flutter/pages/edit_class_page/class_creation_model.dart';
import 'package:datz_flutter/pages/edit_class_page/edit_class_page.dart';
import 'package:datz_flutter/pages/class_picker_page/class_picker_page.dart';
import 'package:datz_flutter/pages/home_page/home_page_sliver_header.dart';
import 'package:datz_flutter/pages/home_page/subject_list.dart';
import 'package:datz_flutter/pages/settings_page/settings_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logScreenView(screenName: "HomePage");
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

    provider.applyMetaModelChanges(metaModel);

    FirebaseAnalytics.instance.logEvent(name: "EditClass", parameters: {
      "EditClass_oldClassName": provider.selectedClass!.name,
      "EditClass_newClassName": metaModel.name,
      "EditClass_reportAsError": reportAsError,
    });

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    if (provider.failedToLoadClass) {
      return const ClassPickerPage();
    }
    Locale activeLocale = Localizations.localeOf(context);
    debugPrint(activeLocale.languageCode); // => fr
    debugPrint(activeLocale.countryCode); // => CA

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
    return CustomCupertinoPageBody(
      needsSafeArea: false,
      child: Column(
        children: <Widget>[
          const SubjectList(),
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (provider.selectedClass != null) buildEditClassButton(context),
              buildSettingsButton(context),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget buildEditClassButton(BuildContext context) {
    final provider = context.watch<ClassProvider>();
    return Button(
      text: AppLocalizations.of(context)!.edit,
      // leadingIcon: CupertinoIcons.pen,
      type: ButtonType.plain,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: ((context) => EditClassPage(
                  classCreationModel: ClassCreationModel.fromClassModel(
                    provider.selectedClass!,
                  ),
                  onSubmit: (ClassMetaModel metaModel, bool reportAsError) =>
                      onEditClassMetaModel(context, metaModel, reportAsError),
                )),
          ),
        );
      },
    );
  }

  Widget buildSettingsButton(BuildContext context) {
    return Button(
      text: AppLocalizations.of(context)!.settings,
      type: ButtonType.tinted,
      leadingIcon: CupertinoIcons.gear_solid,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const SettingsPage()),
        );
      },
    );
  }
}
