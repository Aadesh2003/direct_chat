// ignore_for_file: unnecessary_import, deprecated_member_use, unused_local_variable, non_constant_identifier_names, prefer_const_constructors, avoid_print, prefer_if_null_operators, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, unnecessary_null_comparison

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:direct_chat/helper/db_helper.dart';
import 'package:direct_chat/model/history_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';

class KeyboardScreen extends StatefulWidget {
  const KeyboardScreen({Key? key}) : super(key: key);

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen>
    with WidgetsBindingObserver {
  var _value = "";

  NumberButtonView(value) {
    return Container(
        decoration:
            BoxDecoration(color: themeData.cardColor, shape: BoxShape.circle),
        child: Padding(
          padding: EdgeInsets.all(Get.width / 16),
          child: Text(
            value,
            style: TextStyle(color: themeData.dividerColor, fontSize: 45),
          ),
        ));
  }

  getClipBoardData() async {
    var result = await Clipboard.getData("text/plain");
    var result1 = result!.text!.replaceAll(RegExp(r'[^\w\s]+'), '');
    var finalResult = result1.replaceAll(" ", "");
    if (finalResult.contains(RegExp(r'[A-Z]'))) {
    } else {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(result.text!);
        numberController.text = phoneNumber.nationalNumber;
        countryCodeController.text = "+${phoneNumber.countryCode} ▾";
        _value = numberController.text;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully paste"),
          backgroundColor: Colors.grey.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          duration: Duration(milliseconds: 500
          ),
        ));
        // Get.snackbar(, "",
        //     snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        print(e);
      }
    }
  }

  iconButtonView(value) {
    return Container(
      decoration:
          BoxDecoration(color: themeData.cardColor, shape: BoxShape.circle),
      child: Padding(
          padding: EdgeInsets.all(Get.width / 21),
          child: Icon(
            value,
            color: themeData.dividerColor,
            size: 48,
          )),
    );
  }

  var eraseCheck;

  List<Widget> _getDialerButtons() {
    var rows = <Widget>[];
    var items = <Widget>[];
    for (var i = 0; i < mainTitle.length; i++) {
      if (i % 3 == 0 && i > 0) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
        rows.add(SizedBox(height: 12,));
        items = <Widget>[];
      }
      if (mainTitle[i] == "*" || mainTitle[i] == "＃") {
        items.add(GestureDetector(
          onTap: () async {
            if (mainTitle[i] == "*") {
              var result = await Clipboard.getData("text/plain");
              print(result);
              numberController.text = result!.text!;
            }
            if (mainTitle[i] == "＃") {
              _value.isEmpty
                  ? null
                  : setState(() {
                      _value = _value.substring(0, _value.length - 1);
                      numberController.text = _value;
                    });
            }
            setState(() {});
          },
          onLongPress: () async {
            await Future.delayed(Duration(microseconds: 1200));
            setState(() {
              _value = "";
              numberController.text = "";
            });
          },
          onLongPressStart: (e) {
            eraseCheck = true;
            setState(() {});
            print("=-=-OnLongPressStart");
          },
          onLongPressDown: (e) {
            print(e);
          },
          onLongPressEnd: (e) {
            eraseCheck = false;
            setState(() {});
            print("=-=-OnLongPressEnd");
          },
          child: DialButton(
            icon: mainTitle[i] == "*" ? Icons.copy : Icons.backspace_outlined,
            iconColor: themeData.dividerColor,
            textColor: themeData.dividerColor,
          ),
        ));
      } else {
        items.add(GestureDetector(
          onTap: () {
            print(mainTitle[i]);
            print(_value);
            _value += mainTitle[i];
            numberController.text = _value;
          },
          child: DialButton(
            title: mainTitle[i],
            textColor: themeData.dividerColor,
          ),
        ));
      }
    }
    //To Do: Fix this workaround for last row
    rows.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
    rows.add(SizedBox(
      height: 12,
    ));
    return rows;
  }

  Future<void> _launchUrl(number, isWhatsapp) async {
    var temp = countryCodeController.text.replaceAll(" ▾", "");
    // IOS API
    // "https://api.whatsapp.com/send?phone=9712151416&text=HELLO"
    var url;
    if (isWhatsapp) {
      url =
          "https://api.whatsapp.com/send?phone=${number.toString().contains("+") ? "" : temp.replaceAll("+", "")}$number&text=${message == null ? "" : message}";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch ${url}';
      }
    } else {
      final Uri smsLaunchUri = Uri(
        scheme: 'sms',
        path: '$number',
        queryParameters: <String, String>{
          'body': Uri.encodeComponent('${message == null ? "" : message}'),
        },
      );
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        throw 'Could not launch ${smsLaunchUri}';
      }
    }

    print("URL : $url");
    //

    // if (!await launchUrl(Uri.parse("https://api.whatsapp.com"))) {
    //   throw 'Could not launch $url';+615
    // }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        getClipBoardData();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  var name;
  var message;
  var mainTitle = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "＃"];
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController countryCodeController =
      TextEditingController(text: "+91 ▾");
  TextEditingController messageController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode messageFocusNode = FocusNode();

  buildNameOrMessageDialogue(value) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(value == "name" ? "Enter Name".tr : "Enter Message".tr),
            content: TextField(
              onChanged: (value) {},
              controller: value == "name" ? nameController : messageController,
              focusNode: value == "name" ? nameFocusNode : messageFocusNode,
              decoration: InputDecoration(
                  hintText:
                      value == "name" ? "Enter Name".tr : "Enter Message".tr),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel".tr),
              ),
              MaterialButton(
                onPressed: () {
                  if (value == "name") {
                    if (nameController.text.trim() != null ||
                        nameController.text.trim().isEmpty) {
                      name = nameController.text;
                    }
                  } else {
                    if (messageController.text.trim() != null ||
                        messageController.text.trim().isEmpty) {
                      message = messageController.text;
                    }
                  }
                  Navigator.pop(context);
                },
                child: Text("Ok".tr),
              )
            ],
          );
        });
  }

  storeData(HistoryModel value) async {
    DB.instance.insertInHistory(value);
    var historyData = await DB.instance.getAll();
    print(historyData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getClipBoardData();
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        var _selectedCountry = country;
        // print(_selectedCountry);
        countryCodeController.text =
            "${_selectedCountry.callingCode.toString()} ▾";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: themeData.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            color: themeData.backgroundColor,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          // color: themeData.cardColor,
                          borderRadius: BorderRadius.circular(15)),
                      // height: 50,
                      width: Get.width * 0.35,
                      // alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: AutoSizeTextField(
                          onTap: _showCountryPicker,
                          readOnly: true,
                          controller: countryCodeController,
                          style: TextStyle(
                            color: themeData.dividerColor,
                            fontSize: sizeFactor / 2,
                          ),
                          decoration: InputDecoration(
                              // suffix: Icon(
                              //   Icons.keyboard_arrow_down_rounded,
                              //   color: themeData.dividerColor,
                              // ),
                              border: InputBorder.none,
                              hintText: "+91",
                              hintMaxLines: 2,
                              hintStyle: TextStyle(
                                  fontSize: sizeFactor / 2,
                                  color:
                                      themeData.dividerColor.withOpacity(0.5))),
                          // keyboardType:
                          // TextInputType.phone,
                          // validator: ,
                        ),
                      )),
                  Expanded(
                    child: AutoSizeTextField(
                      // minFontSize: sizeFactor / 3,
                      minFontSize: 25,
                      readOnly: true,
                      style: TextStyle(
                          color: themeData.dividerColor,
                          overflow: TextOverflow.ellipsis,
                          fontSize: sizeFactor / 2),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(border: InputBorder.none),
                      controller: numberController,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                        onPressed: () async {
                          nameFocusNode.requestFocus();
                          await buildNameOrMessageDialogue("name");
                          nameFocusNode.unfocus();
                          setState(() {});
                        },
                        child: Text(
                          name == null ? "Add Name".tr : name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: name == null
                                  ? Colors.blue
                                  : themeData.dividerColor.withOpacity(0.5)),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 10),
                    child: Container(
                      width: 1.5,
                      color: Colors.blue,
                      height: 17,
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () async {
                          messageFocusNode.requestFocus();
                          await buildNameOrMessageDialogue("message");
                          messageFocusNode.unfocus();
                        },
                        child: Text(
                            message == null ? "Add Message".tr : message,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: message == null
                                    ? Colors.blue
                                    : themeData.dividerColor
                                        .withOpacity(0.5)))),
                  )
                ],
              ),
              ..._getDialerButtons(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (numberController.text.isNotEmpty) {
                        HistoryModel model = HistoryModel(
                          name: nameController.text.isEmpty
                              ? null
                              : nameController.text,
                          message: message,
                          phoneNumber: numberController.text,
                          createdDate: DateTime.now().toString(),
                          countryCode:
                              countryCodeController.text.replaceAll(" ▾", ""),
                          type: "textMessage",
                        );
                        await storeData(model);
                        _launchUrl(numberController.text, false);
                      }
                    },
                    child: DialButton(
                      color: Colors.green,
                      icon: Icons.message,
                      iconColor: Colors.white,
                      textColor: themeData.dividerColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (numberController.text.isNotEmpty) {
                        HistoryModel model = HistoryModel(
                          name: nameController.text.isEmpty
                              ? null
                              : nameController.text,
                          message: message,
                          phoneNumber: numberController.text,
                          type: "whatsapp",
                          createdDate: DateTime.now().toString(),
                          countryCode:
                              countryCodeController.text.replaceAll(" ▾", ""),
                        );
                        await storeData(model);
                        _launchUrl(numberController.text, true);
                      }
                    },
                    child: DialButton(
                      color: Colors.green,
                      icon: Icons.whatsapp,
                      iconColor: Colors.white,
                      textColor: themeData.dividerColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print("=-=-=-");
                      if (numberController.text.isNotEmpty) {
                        print("=-=-=-");
                        var temp =
                            countryCodeController.text.replaceAll(" ▾", "");
                        var link =
                            "https://api.whatsapp.com/send?phone=${numberController.text.toString().contains("+") ? "" : temp.replaceAll("+", "")}${numberController.text}&text=${message == null ? "" : message}";
                        print(link);
                        Share.share(link);
                      }
                    },
                    child: DialButton(
                      color: Colors.green,
                      icon: Icons.share,
                      iconColor: Colors.white,
                      textColor: themeData.dividerColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
