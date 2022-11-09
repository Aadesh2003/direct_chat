import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectedPref{
  void addList(String string) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("languageSelectedOrNot", string);
  }

  getString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("languageSelectedOrNot");
  }
}