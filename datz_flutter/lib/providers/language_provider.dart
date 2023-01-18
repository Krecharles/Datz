import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  // de -> luxembourgish
  // en -> english
  String languageCode;

  LanguageProvider({this.languageCode = "de"}) {
    loadLanguageCode();
  }

  @override
  void notifyListeners() {
    saveLanguageCode();
    super.notifyListeners();
  }

  void setLanguageCode(String newLanguageCode) {
    languageCode = newLanguageCode;
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
}
