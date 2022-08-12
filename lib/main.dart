// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_final_fields, prefer_const_constructors, avoid_print, unused_local_variable, deprecated_member_use, prefer_typing_uninitialized_variables, avoid_unnecessary_containers

import 'package:auto_size_text/auto_size_text.dart';
import 'package:direct_chat/tabs/keyboard_screen.dart';
import 'package:direct_chat/tabs/recent_screen.dart';
import 'package:direct_chat/tabs/schedule_screen.dart';
import 'package:direct_chat/tabs/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/multi_language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageController pageController = PageController();

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
var brightness = widgetsBinding.window.platformBrightness;
var isLightTheme = brightness == Brightness.light ? true : false;
final darkTheme = ThemeData(
  fontFamily: "NotoSans",
  backgroundColor: const Color(0XFF14151a),
  cardColor: const Color(0XFF282A35),
  shadowColor: const Color(0XFF666A81),
  primaryColor: const Color(0XFF0E111F),
  dividerColor: Colors.white,
);

Color buttonColor = const Color(0XFF1916ab);

final lightTheme = ThemeData(
  fontFamily: "NotoSans",
  shadowColor: Colors.grey,
  backgroundColor: Colors.grey[100],
  primaryColor: const Color(0XFF0E111F),
  cardColor: Colors.white,
  dividerColor: const Color(0XFF14151a),
);

var themeData = isLightTheme ? lightTheme : darkTheme;
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  var payLoad = "";
  var details =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  if (details != null) {
    if (details.didNotificationLaunchApp) {
      print(details.payload);
      payLoad = details.payload!;
    }
  }
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp(payLoad: payLoad));
  });
}

class MyApp extends StatefulWidget {
  String? payLoad;

  MyApp({this.payLoad});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: "rateMyApp_",
    minDays: 3,
    minLaunches: 7,
    remindDays: 2,
    remindLaunches: 5,
    googlePlayIdentifier: "com.sunraylabs.socialtags",
    // appStoreIdentifier: ‘1491556149’,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLanguageCode();
  }

  _getLanguageCode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString("language") != null) {
      var language = preferences.getString("language");
      var languageCode = preferences.getString("languageCode");
      setState(() {
        var selectionValue = language.toString();
        Get.updateLocale(Locale(languageCode!));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MultiLanguageModel(),
      // showPerformanceOverlay: true,
      locale: Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(rateMyApp: _rateMyApp, payLoad: widget.payLoad),
    );
  }
}

class MyHomePage extends StatefulWidget {
  RateMyApp? rateMyApp;
  String? payLoad;

  MyHomePage({this.rateMyApp, this.payLoad});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var notification = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pageController = PageController(initialPage: _bottomNavIndex);
    if (widget.payLoad == null || widget.payLoad == "") {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        widget.rateMyApp!.init().then((_) {
          // if (widget.rateMyApp!.shouldOpenDialog) {
          widget.rateMyApp!.showStarRateDialog(
            context,
            title: "Rate this app".tr,
            // The dialog title.
            message: "Rating Content".tr, // The dialog message.
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            actionsBuilder: (context, stars) {
              return [
                TextButton(
                  child: Text("Ok".tr),
                  onPressed: () async {
                    print("Thanks for the " +
                        (stars == null ? "0" : stars.round().toString()) +
                        " star(s) !");
                    if (stars != null) {
                      widget.rateMyApp!
                          .save()
                          .then((value) => Navigator.pop(context));
                      if (stars <= 3) {
                        print("3 or less");
                      } else if (stars <= 5) {
                        print("4 or 5 ");
                        widget.rateMyApp!.launchStore();
                      }
                    } else {
                      Navigator.pop(context);
                    }
                    // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                    // This allows to mimic the behavior of the default “Rate” button. See “Advanced > Broadcasting events” for more information :
                    // await widget.rateMyApp!
                    //     .callEvent(RateMyAppEventType.rateButtonPressed);
                    // Navigator.pop<RateMyAppDialogButton>(
                    //     navKey.currentContext!, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            // ignoreNativeDialog: Platform
            //     .isAndroid, // Set to false if you want to show the Apple’s native app rating dialog on iOS or Google’s native app rating dialog (depends on the current Platform).
            dialogStyle: const DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions:
                const StarRatingOptions(), // Custom star bar rating options.
            onDismissed: () => widget.rateMyApp!.callEvent(RateMyAppEventType
                .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the “back” button).
          );
        });
      });
    } else {
      setState(() {});
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
        await Future.delayed(Duration(seconds: 2));
        var value = widget.payLoad;
        androidDialog(value);
      });
    }
  }

  Future<void> _launchUrl(number, isWhatsapp, message) async {
    // IOS API
    // "https://api.whatsapp.com/send?phone=9712151416&text=HELLO"
    var url;
    if (isWhatsapp) {
      url =
          "https://api.whatsapp.com/send?phone=91$number&text=${message ?? ""}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: '$number',
        queryParameters: <String, String>{
          'body': Uri.encodeComponent('${message ?? ""}'),
        },
      );
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        throw 'Could not launch $smsLaunchUri';
      }
    }

    print("URL : $url");
    //

    // if (!await launchUrl(Uri.parse("https://api.whatsapp.com"))) {
    //   throw 'Could not launch $url';+615
    // }
  }

  androidDialog(value1) async {
    var value = value1;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Text(
                "Welcome Back",
                style: TextStyle(color: themeData.dividerColor),
              ),
              content: Container(
                  child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      value.split("@@@").last == "whatsApp"
                          ? Image.asset(
                              "assets/images/whatsapp.png",
                              height: 50,
                              width: 50,
                            )
                          : Image.asset(
                              "assets/images/textMessage.png",
                              height: 50,
                              width: 50,
                            )
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value.split("@@@").first,
                        style: TextStyle(color: themeData.dividerColor),
                      ),
                      Text(
                        value.split("@@@")[1],
                        style: TextStyle(color: themeData.dividerColor),
                      ),
                    ],
                  )
                ],
              )),
              actions: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: themeData.dividerColor),
                  ),
                  color: themeData.backgroundColor,
                ),
                MaterialButton(
                  onPressed: () {
                    _launchUrl(
                        value.split("@@@").first,
                        value.split("@@@").last == "whatsApp" ? true : false,
                        value.split("@@@")[2]);
                  },
                  child: Text(
                    "Direct message",
                    style: TextStyle(color: themeData.dividerColor),
                  ),
                  color: themeData.backgroundColor,
                )
              ],
            ));
  }

  final autoSizeGroup = AutoSizeGroup();

  var _bottomNavIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeData.backgroundColor,
      body: PageView(
        onPageChanged: (i) {
          setState(() => _bottomNavIndex = i);
        },
        controller: pageController,
        children: [
          KeyboardScreen(),
          RecentScreen(),
          ScheduleScreen(),
          SettingScreen(payLoad: widget.payLoad)
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: Container(
            color: themeData.cardColor,
            child: SalomonBottomBar(
              currentIndex: _bottomNavIndex,
              onTap: (i) {
                setState(() => _bottomNavIndex = i);
                pageController.jumpToPage(_bottomNavIndex);
              },
              items: [
                SalomonBottomBarItem(
                  unselectedColor: themeData.dividerColor,
                  icon: Icon(Icons.keyboard_alt_outlined),
                  title: Container(
                    width: Get.width * 0.2,
                    child: FittedBox(
                        fit: BoxFit.scaleDown, child: Text("Keyboard".tr)),
                  ),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  unselectedColor: themeData.dividerColor,
                  icon: Icon(Icons.history),
                  title: Container(
                    width: Get.width * 0.2,
                    child: FittedBox(
                        fit: BoxFit.scaleDown, child: Text("Recent".tr)),
                  ),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  unselectedColor: themeData.dividerColor,
                  icon: Icon(Icons.calendar_month_outlined),
                  title: Container(
                    width: Get.width * 0.2,
                    child: FittedBox(
                        fit: BoxFit.scaleDown, child: Text("Schedule".tr)),
                  ),
                  selectedColor: Colors.green,
                ),
                SalomonBottomBarItem(
                  unselectedColor: themeData.dividerColor,
                  icon: Icon(
                    Icons.settings_outlined,
                  ),
                  title: Container(
                    width: Get.width * 0.2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text("Setting".tr),
                    ),
                  ),
                  selectedColor: Colors.green,
                ),
              ],
            )),
      ),
    );
  }
}
