import 'package:datz_flutter/model/legacy_data_loader.dart';
import 'package:datz_flutter/pages/home_page/home_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:datz_flutter/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  runApp(
    ChangeNotifierProvider<SettingsProvider>(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // DataLoader.deleteAllData();
    LegacyDataLoader.checkPreferences();

    initFirebase();

    return ChangeNotifierProvider<ClassProvider>(
      create: (_) => ClassProvider(),
      child: CupertinoApp(
        title: 'Datz!',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
        ],
        locale: Locale.fromSubtags(
          languageCode: context.watch<SettingsProvider>().languageCode,
        ),
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
          brightness: context.watch<SettingsProvider>().getBrightness(),
        ),
        home: const HomePage(),
      ),
    );
  }

  void initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // FirebaseFunctions.instanceFor(region: 'europe-west3')
    //     .useFunctionsEmulator('localhost', 5001);
  }
}
