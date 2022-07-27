
import 'package:direct_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  String? payLoad;

  SettingScreen({this.payLoad});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: "rateMyApp_",
    minDays: 3,
    minLaunches: 7,
    remindDays: 2,
    remindLaunches: 5,
    googlePlayIdentifier: "com.sunraylabs.socialtags",
    // appStoreIdentifier: ‘1491556149’,
  );

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListOfNotification();
  }

  getListOfNotification() async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.backgroundColor,

      appBar: AppBar(
        backgroundColor: themeData.cardColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Setting",
          style: TextStyle(
              color: themeData.dividerColor, fontWeight: FontWeight.bold),
        ),
      ),
      body:Column(
        children: [
          Padding(
          padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: themeData.cardColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _rateMyApp.launchStore();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.favorite,color: Colors.red[900],),),
                          ),
                          SizedBox(width: 15,),
                          Text("Rate Us",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Container(height: 0.5,color: themeData.dividerColor,),),

                  GestureDetector(
                    onTap: (){
                         var link = "https://www.google.com";
                     print(link);
                     Share.share(link);
                    },
                    child: Container(
                      child: Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.orangeAccent
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.share,color: Colors.white,),),
                          ),
                          SizedBox(width: 15,),
                          Text("Share App",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                      color: Colors.transparent,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Container(height: 0.5,color: themeData.dividerColor,),),
                  GestureDetector(
                    onTap: (){
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: 'codixel.ios@gmail.com',
                        query: encodeQueryParameters(<String, String>{
                          'subject': '',
                        }),
                      );
                      launchUrl(emailLaunchUri);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.deepPurpleAccent
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.question_mark_rounded,color: Colors.white,),),
                          ),
                          SizedBox(width: 15,),
                          Text("Help",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Container(height: 0.5,color: themeData.dividerColor,),),
                  GestureDetector(
                    onTap: (){
                      var url = Uri.parse("https://play.google.com/store/apps/dev?id=6577204690045492686");
                      launchUrl(url);
                    },
                    child: Container(
                      child: Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.teal
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.category_rounded,color: Colors.white,),),
                          ),
                          SizedBox(width: 15,),
                          Text("More App",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
          padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: themeData.cardColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      var url = Uri.parse("https://www.google.com");
                      launchUrl(url);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child:   Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.lightBlue
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.back_hand_rounded,color: Colors.white),),
                          ),
                          SizedBox(width: 15,),
                          Text("Privacy Policy",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 10,right: 10),child: Container(height: 0.5,color: themeData.dividerColor,),),
                  GestureDetector(
                    onTap: (){
                      var url = Uri.parse("https://www.google.com");
                      launchUrl(url);
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(padding: EdgeInsets.all(10),child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red[500]
                            ),
                            child: Padding(padding: EdgeInsets.all(3),child: Icon(Icons.description,color: Colors.white,),),
                          ),
                          SizedBox(width: 15,),
                          Text("Terms of use",style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 17
                          ),)
                        ],
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
