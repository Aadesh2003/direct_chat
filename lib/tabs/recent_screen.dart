// ignore_for_file: avoid_print

import 'dart:io';

import 'package:direct_chat/const.dart';
import 'package:direct_chat/helper/db_helper.dart';
import 'package:direct_chat/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../model/history_model.dart';

class RecentScreen extends StatefulWidget {
  const RecentScreen({Key? key}) : super(key: key);

  @override
  State<RecentScreen> createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
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
    print(historyData);
    isLoading = false;
    setState(() {});
  }

  buildDeleteDialogueIos(i) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Delete !'),
            content: const Text("Are You Sure ?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    deleteData(historyData![i].id);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  buildDeleteDialogueAndroid(i) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete !'),
            content: const Text("Are You Sure ?"),
            actions: [
              TextButton(
                  onPressed: () async {
                    deleteData(historyData![i].id);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }

  deleteData(id) async {
    await DB.instance.deleteSingle(id);
    getHistoryData();
    // DateTime.parse(formattedString)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: themeData.cardColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Recent",
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
                            Image.asset("assets/images/noData.png",width: Get.width,),
                            Text(
                              "No Data",
                              style: TextStyle(color: themeData.dividerColor),
                            ),
                            TextButton(
                                onPressed: () {
                                  pageController.jumpToPage(0);
                                },
                                child: const Text(
                                  "Add data",
                                  style: TextStyle(color: Colors.green),
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
                                  // dismissible: Container(
                                  //   height: 50,
                                  //   width: 50,
                                  //   color: Colors.blue,
                                  // ),
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
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: themeData.cardColor,
                                      borderRadius: BorderRadius.circular(15)),
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
                                          Container(
                                            width: historyData![i].name! == "null" ? 0.001 : Get.width * 0.25,
                                            child: Text(
                                              historyData![i].name! == "null"
                                                  ? ""
                                                  : historyData![i].name!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: themeData.dividerColor,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          Expanded(

                                            child: Text(
                                              historyData![i].name! == "null" ? "${historyData![i].countryCode!} ${historyData![i].phoneNumber!}" : " (${historyData![i].countryCode!} ${historyData![i].phoneNumber!})",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: themeData.dividerColor
                                                      .withOpacity(0.5),
                                                  fontSize: 14),
                                            ),
                                          )
                                        ],
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              historyData![i].message! == "null"
                                                  ? "No message"
                                                  : historyData![i].message!,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: themeData.dividerColor
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
                                ))),
                      )));
  }
}
