import 'package:shared_preferences/shared_preferences.dart';

class LanguagePref{
  void addList(String string) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("language", string);
  }

  getString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("language");
  }
}