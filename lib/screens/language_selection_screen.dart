import 'package:direct_chat/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
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
        selectionValue = language.toString();
        Get.updateLocale(Locale(languageCode!));
      });
    }
  }

  @override
  List<String> languageList = [
    "English",
    "Hindi",
    "Russian",
    "Spanish",
    "French",
    "German",
    "Portuguese",
    "italian"
  ];

  List<String> languageCodeList = [
    "en_US",
    "hi_IN",
    "ru-RU",
    "es-ES",
    "fr-FR",
    "de-DE",
    "pt-PT",
    "it-IT",
  ];

  String selectionValue = "English";

  _gridContainer(int index, String lanName, String lanText, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            selectionValue = languageList[index];
          });
          Get.updateLocale(Locale(languageCodeList[index]));
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString("language", languageList[index]);
          await preferences.setString("languageCode", languageCodeList[index]);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: themeData.cardColor,
                boxShadow: [
                  BoxShadow(
                      color: themeData.shadowColor.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(4, 4))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          lanText.tr,
                          style: TextStyle(
                              color: themeData.dividerColor,
                              fontSize: 25,
                              fontFamily: "openSans"),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          lanName,
                          style: TextStyle(
                              color:themeData.dividerColor,
                              fontSize: 16,
                              fontFamily: "openSans"),
                        )),
                  )
                ],
              ),
            ),
            languageList[index] == selectionValue ? Container(
              // height: 30,
              // width: 30,
              // decoration: BoxDecoration(
              //     // color: themeData.dividerColor,
              //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(10))
              // ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.check_circle_outline_rounded,color: themeData.dividerColor,),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeData.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeData.cardColor,
        foregroundColor: themeData.dividerColor,
        title: Text("Choose Language".tr),
        elevation: 0,
      ),
      body: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 2 / 1.5,
        children: [
          _gridContainer(0, languageList[0], "Hello", Colors.red),
          _gridContainer(1, languageList[1], "नमस्ते", Colors.green),
          _gridContainer(2, languageList[2], "привет", Colors.deepPurple),
          _gridContainer(3, languageList[3], "Hola", Colors.blue),
          _gridContainer(
              4, languageList[4], "bonjour", Colors.deepOrangeAccent),
          _gridContainer(5, languageList[5], "hallo", Colors.teal),
          _gridContainer(6, languageList[6], "olá", Colors.lightGreen),
          _gridContainer(7, languageList[7], "ciao", Colors.cyan),
        ],
      ),
    );
  }
}
