import 'package:shared_preferences/shared_preferences.dart';

class NotificationListPref{
  void addList(String string) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("NotificationList", string);
  }

  getString() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("NotificationList");
  }
}