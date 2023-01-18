import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsProvider with ChangeNotifier, WidgetsBindingObserver {
  // de -> luxembourgish
  // en -> english
  String languageCode;
  Brightness? brightness;

  SettingsProvider({this.languageCode = "de"}) {
    loadLanguageCode();
    loadBrightness();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void setLanguageCode(String newLanguageCode) {
    languageCode = newLanguageCode;
    saveLanguageCode();
    notifyListeners();
  }

  void loadLanguageCode() async {
    final userDefaults = await SharedPreferences.getInstance();
    languageCode = userDefaults.getString("languageCode") ?? "de";
    notifyListeners();
  }

  void saveLanguageCode() async {
    final userDefaults = await SharedPreferences.getInstance();
    userDefaults.setString("languageCode", languageCode);
  }

  String getLanguageDescription() {
    return getLanguageDescriptionOfCode(languageCode);
  }

  static List<String> languageCodes = const ["de", "en"];
  static List<String> languageDescriptions = const [
    "Lëtzebuergesch",
    "English"
  ];

  static String getLanguageDescriptionOfCode(String languageCode) {
    try {
      int index = languageCodes.indexOf(languageCode);
      return languageDescriptions[index];
    } catch (e) {
      return "";
    }
  }

  void loadBrightness() async {
    final userDefaults = await SharedPreferences.getInstance();
    final b = userDefaults.getBool("brightness");
    if (b == null) {
      brightness = null;
    } else if (b) {
      brightness = Brightness.light;
    } else {
      brightness = Brightness.dark;
    }
  }

  @override
  void didChangePlatformBrightness() {
    notifyListeners();
  }

  Brightness getBrightness() {
    var systemBrightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness ?? systemBrightness;
  }

  String getBrightnessDescription(BuildContext context) {
    if (brightness == null) {
      return AppLocalizations.of(context)!.system;
    }
    if (brightness == Brightness.light) {
      return AppLocalizations.of(context)!.light;
    }
    return AppLocalizations.of(context)!.dark;
  }

  void setBrightness(Brightness? b) {
    brightness = b;
    saveBrightness();
    notifyListeners();
  }

  void saveBrightness() async {
    final userDefaults = await SharedPreferences.getInstance();
    if (brightness == null) {
      userDefaults.remove("brightness");
    } else {
      userDefaults.setBool("brightness", brightness == Brightness.light);
    }
  }
}
