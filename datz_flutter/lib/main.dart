import 'package:datz_flutter/model/data_loader.dart';
import 'package:datz_flutter/pages/home_page/home_page.dart';
import 'package:datz_flutter/providers/class_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DataLoader.loadAllClassMetaModels();

    return ChangeNotifierProvider<ClassProvider>(
      create: (_) => ClassProvider(),
      child: const CupertinoApp(
        title: 'Datz!',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
        ),
        home: HomePage(),
      ),
    );
  }
}
