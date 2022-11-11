// ignore_for_file: avoid_print, must_call_super, deprecated_member_use, prefer_if_null_operators, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:direct_chat/const.dart';
import 'package:direct_chat/helper/db_helper.dart';
import 'package:direct_chat/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/history_model.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key}) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen>
    with AutomaticKeepAliveClientMixin {
  List<HistoryModel>? historyData;
  var isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHistoryData();
  }

  getHistoryData() async {
    historyData = await DB.instance.getAll();
    isLoading = false;
    setState(() {});
  }

  buildDeleteDialogueIos(i) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Delete!'.tr),
          content: Text("Sure Delete".tr),
          actions: [
            TextButton(
              onPressed: () async {
                deleteData(historyData![i].id);
                Navigator.pop(context);
              },
              child: Text(
                'Yes'.tr,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SFProDisplay'),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'SFProDisplay'))),
          ],
        );
      },
    );
  }

  buildDeleteDialogueAndroid(i) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('Delete!'.tr),
            content: Text("Sure Delete".tr),
            actions: [
              MaterialButton(
                onPressed: () {
                  deleteData(historyData![i].id);
                  Navigator.pop(context);
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Text('Yes'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SFProDisplay')),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No'.tr,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontFamily: 'SFProDisplay'),
                ),
              )
            ],
          );
        });
  }

  buildClearDialogueIos() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Sure'.tr),
          content: Text("Sure clear".tr),
          actions: [
            TextButton(
              onPressed: () async {
                if (historyData!.isNotEmpty) {
                  for (var i = 0; i < historyData!.length; i++) {
                    await DB.instance.deleteSingle(historyData![i].id);
                  }
                  historyData!.clear();
                }
                Navigator.pop(context);
              },
              child: Text(
                'Yes'.tr,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'SFProDisplay'),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'SFProDisplay'))),
          ],
        );
      },
    );
  }

  buildClearDialogueAndroid() {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text('Sure'.tr),
            content: Text("Sure clear".tr),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (historyData!.isNotEmpty) {
                    for (var i = 0; i < historyData!.length; i++) {
                      await DB.instance.deleteSingle(historyData![i].id);
                    }
                    historyData!.clear();
                  }
                  Navigator.pop(context);
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Text('Yes'.tr,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'SFProDisplay')),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No'.tr,
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontFamily: 'SFProDisplay'),
                ),
              )
            ],
          );
        });
  }

  deleteData(id) async {
    await DB.instance.deleteSingle(id);
    getHistoryData();
  }

  Future<void> _launchUrl(number, isWhatsapp, countryCode, message) async {
    var temp = countryCode;
    var url;
    if (isWhatsapp) {
      url =
          "https://api.whatsapp.com/send?phone=${number.toString().contains("+") ? "" : temp.replaceAll("+", "")}$number&text=${message == null ? "" : message}";
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
          'body': Uri.encodeComponent('${message == null ? "" : message}'),
        },
      );
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        throw 'Could not launch $smsLaunchUri';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: themeData.cardColor,
          elevation: 0,
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () async {
                  Platform.isAndroid
                      ? buildClearDialogueAndroid()
                      : buildClearDialogueIos();
                  setState(() {});
                },
                child: Text("Clear".tr))
          ],
          title: Text(
            "Recent".tr,
            style: TextStyle(
                color: themeData.dividerColor, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: themeData.backgroundColor,
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : historyData!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/chat.png",
                              width: Get.width / 2,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "No Recent".tr,
                              style: TextStyle(color: themeData.dividerColor),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Add Recent".tr,
                                  style: const TextStyle(color: Colors.green),
                                ))
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: historyData!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 4, top: 4),
                            child: Slidable(
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (e) {
                                        Platform.isIOS
                                            ? buildDeleteDialogueIos(i)
                                            : buildDeleteDialogueAndroid(i);
                                      },
                                      icon: Icons.delete,
                                      backgroundColor: Colors.red,
                                    )
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    _launchUrl(
                                        historyData![i].phoneNumber,
                                        historyData![i].type == "whatsapp"
                                            ? true
                                            : false,
                                        historyData![i].countryCode,
                                        historyData![i].message == "null"
                                            ? ""
                                            : historyData![i].message);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: themeData.cardColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, left: 8),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading:
                                            historyData![i].type == "whatsapp"
                                                ? Image.asset(
                                                    "assets/images/whatsapp.png",
                                                    height: 40,
                                                    width: 40,
                                                  )
                                                : Image.asset(
                                                    "assets/images/textMessage.png",
                                                    height: 40,
                                                    width: 40,
                                                  ),
                                        title: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  minWidth: 0.001,
                                                  maxWidth: Get.width * 0.25),
                                              child: Text(
                                                historyData![i].name! == "null"
                                                    ? ""
                                                    : historyData![i].name!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color:
                                                        themeData.dividerColor,
                                                    fontSize: 15),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                historyData![i].name! == "null"
                                                    ? "${historyData![i].countryCode!} ${historyData![i].phoneNumber!}"
                                                    : " (${historyData![i].countryCode!} ${historyData![i].phoneNumber!})",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: historyData![i]
                                                                .name! !=
                                                            "null"
                                                        ? themeData.dividerColor
                                                            .withOpacity(0.5)
                                                        : themeData
                                                            .dividerColor,
                                                    fontSize: 14),
                                              ),
                                            )
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                historyData![i].message! ==
                                                        "null"
                                                    ? "No Message".tr
                                                    : historyData![i].message!,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: themeData
                                                        .dividerColor
                                                        .withOpacity(0.5),
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.watch_later_outlined,
                                                  color: themeData.dividerColor
                                                      .withOpacity(0.5),
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  timeAgo(DateTime.parse(
                                                      historyData![i]
                                                          .createdDate!)),
                                                  style: TextStyle(
                                                      color: themeData
                                                          .dividerColor
                                                          .withOpacity(0.5),
                                                      fontSize: 12),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ))),
                      )));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
