// ignore_for_file: avoid_print, prefer_final_fields, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, unused_local_variable, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, prefer_if_null_operators

import 'dart:io';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:direct_chat/main.dart';
import 'package:direct_chat/model/notification_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timezone/data/latest.dart' as tz1;
import 'package:timezone/timezone.dart' as tz;
import '../helper/db_helper.dart';

enum MessageType { whatsApp, textMessage }

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> with AutomaticKeepAliveClientMixin {
  TextEditingController messageController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController countryCodeController =
      TextEditingController(text: "+91");
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  MessageType _site = MessageType.whatsApp;
  Country? _selectedCountry;
  var soundCheck;
  var notificationCheck;
  var language = "en_US";
  var isLoading = true;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<NotificationDataModel>? notificationList;
  var selectedTime;
  double ratingCount = 0;
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  storeData(day, id, time, payLoad, value, title, number, message, type,
      model) async {
    print("SELECTEDDAY : ${selectedDay}");
    if (day is String) {
      print("=-=-=-=-=--");
      if (day == "Weekly") {
        var payLoad =
            "${number}@@@${nameController.text}@@@${message}@@@${type}";
        schedualNotificationOnlyOnGivenDayWeekly(
            day, id, time, title, false, payLoad);
      } else if (day == "Daily") {
        var payLoad =
            "${number}@@@${nameController.text}@@@${message}@@@${type}";
        schedualNotificationOnlyOnGivenDayOfDaily(
            day, id, time, title, true, payLoad);
      } else if (day == "Monthly") {
        schedualNotificationOnlyOnGivenDayOfMonth(day, id, time, title, false);
      } else if (day == "Never") {
        schedualNotificationOnlyOnGivenDayOfYear(day, id, time, title, true);
      } else {
        schedualNotificationOnlyOnGivenDayOfYear(day, id, time, title, false);
      }
    }
    storeDataInDB(model);
  }

  getData() async {
    notificationList = await DB.instance.getAllNotificationData();
    print(notificationList);
    isLoading = false;
    setState(() {});
  }

  storeDataInDB(NotificationDataModel value) async {
    DB.instance.insertInNotification(value);
    notificationList = await DB.instance.getAllNotificationData();
    setState(() {});
  }

  final IOSInitializationSettings initializationSettingsIos =
      const IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  InitializationSettings? initializationSettings;

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
    });
  }

  Future<void> schedualNotificationOnlyOnGivenDayWeekly(
      day, id, time, title, isDaily, payLoad) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(id),
        title == null ? 'weekly scheduled notification title' : title,
        'weekly scheduled notification body',
        isDaily ? _nextInstanceOfDaily(time) : _nextInstanceOfMondayTenAM(time),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        payload: payLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> schedualNotificationOnlyOnGivenDayOfMonth(
      day, id, time, title, isDaily) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(id),
        title == null ? 'monthly scheduled notification title' : title,
        'monthly scheduled notification body',
        _nextInstanceOfMondayTenAMonthly(time),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  }

  Future<void> schedualNotificationOnlyOnGivenDayOfYear(
      day, id, time, title, isOnly) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(id),
        title == null ? 'yearly scheduled notification title' : title,
        'yearly scheduled notification body',
        _nextInstanceOfMondayTenAMYearly(time, isOnly),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  Future<void> schedualNotificationOnlyOnGivenDayOfDaily(
      day, id, time, title, isDaily, payLoad) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        int.parse(id),
        title == null ? 'daily scheduled notification title' : title,
        'daily scheduled notification body',
        isDaily ? _nextInstanceOfDaily(time) : _nextInstanceOfMondayTenAM(time),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly notification channel id',
              'weekly notification channel name',
              channelDescription: 'weekly notificationdescription'),
        ),
        payload: payLoad,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfDaily(utcTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, utcTime.year,
        utcTime.month, utcTime.day, utcTime.hour, utcTime.minute);
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayTenAM(time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    print("DAY :${day}");
    while (scheduledDate.weekday !=
        (day == 'Monday'
            ? DateTime.monday
            : day == 'Tuesday'
                ? DateTime.tuesday
                : day == 'Wednesday'
                    ? DateTime.wednesday
                    : day == "Thursday"
                        ? DateTime.thursday
                        : day == "Friday"
                            ? DateTime.friday
                            : day == "Saturday"
                                ? DateTime.saturday
                                : DateTime.sunday)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayTenAMonthly(DateTime time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    print("DAY :${day}");
    while (scheduledDate.day != time.day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfMondayTenAMYearly(DateTime time, isOnly) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    print("DAY :${day}");
    if (isOnly) {
      while (scheduledDate.day != time.day &&
          scheduledDate.month != time.month &&
          scheduledDate.year != time.year) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    } else {
      while (
          scheduledDate.day != time.day && scheduledDate.month != time.month) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }
  }

  tz.TZDateTime _nextInstanceOfTenAM(time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, time.year, time.month, time.day, time.hour, time.minute);
    print("HOUR :${time.hour}");
    print("MINUTE :${time.minute}");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      print(scrollController.offset);
      scrollValue = scrollController.offset;
    });
    appBar = AppBar(
      backgroundColor: themeData.cardColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Schedule".tr,
        style: TextStyle(
            color: themeData.dividerColor, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () {
              addScheduleNotification(false, NotificationDataModel());
            },
            icon: Icon(
              Icons.add,
              color: themeData.dividerColor,
            ))
      ],
    );
    _getTime();
    initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIos);
    flutterLocalNotificationsPlugin.initialize(initializationSettings!);

    initCountry();
    getData();
  }

  _getTime() async {
    tz1.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  void _showCountryPicker() async {
    final country = await showCountryPickerDialog(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
        print(_selectedCountry);
        countryCodeController.text = _selectedCountry!.callingCode.toString();
      });
    }
  }

  int selectedDay = 0;

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  showDialog1(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }


  var time = DateTime.now();
  var date = DateTime.now();
  var day;

  timePicker() {
    return CupertinoDatePicker(
      initialDateTime: time,
      mode: CupertinoDatePickerMode.time,
      use24hFormat: true,
      // This is called when the user changes the time.
      onDateTimeChanged: (DateTime newTime) {
        setState(() => time = newTime);
      },
    );
  }

  double _kItemExtent = 32.0;
  List<String> dayList = <String>[
    'Daily'.tr,
    'Never'.tr,
    'Weekly'.tr,
    'Monthly'.tr,
    'Yearly'.tr
  ];

  List<String> dayLst = <String>[
    'Daily',
    'Never',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  var scrollValue = 10.0;

  Future<void> _cancelNotification(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  AppBar? appBar;

  addScheduleNotification(isEdit, NotificationDataModel dataModel) {
    if (isEdit) {
      titleController.text = dataModel.title!;
      _site = dataModel.type!.toLowerCase() == "whatsapp"
          ? MessageType.whatsApp
          : MessageType.textMessage;
      countryCodeController.text = dataModel.countryCode!;
      numberController.text = dataModel.number!;
      nameController.text = dataModel.name!;
      date = DateTime.parse(dataModel.date!);
      // print("-=-=-=-=-");
      selectedDay = dayLst.indexWhere((element) =>
          element.toLowerCase() == dataModel.repeatDay!.toLowerCase());
      // DateTime.
      print(dataModel.time);
      time = DateTime.parse(
          '2021-10-04 ${dataModel.time!.split(":").first}:${dataModel.time!.split(":").last}:00.000Z');
      print(time.toString());
      messageController.text = dataModel.message!;
    } else {
      titleController.text = "";
      _site = MessageType.whatsApp;
      countryCodeController.text = "+91";
      numberController.text = "";
      nameController.text = "";
      date = DateTime.now();
      // print("-=-=-=-=-");
      selectedDay = 0;
      // DateTime.
      // print(value.time);/
      time = DateTime.now();
      print(time.toString());
      messageController.text = "";
    }
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      barrierColor: Colors.black38,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      ),
      context: context,
      builder: (context) => SafeArea(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          child: Container(
            height: Get.height - appBar!.preferredSize.height - 50,
            child: Scaffold(
              backgroundColor: themeData.cardColor,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: themeData.cardColor,
                leadingWidth: 100,
                leading: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".tr,
                      style: TextStyle(color: themeData.dividerColor, fontSize: 13),
                    )),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState != null) {
                          if (_formKey.currentState!.validate()) {
                            if (!isEdit) {
                              var payLoad = [];
                              var id =
                                  "${DateTime.now().day.toString()}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                              var title = titleController.text;
                              var value =
                                  "$id ${dayList[selectedDay]} ${time.hour}:${time.minute} ${titleController.text} ${_site} ${countryCodeController.text}${numberController.text} ${nameController.text}";
                              print(dayList[selectedDay]);
                              NotificationDataModel modelValue =
                                  NotificationDataModel(
                                createdTime: DateTime.now().toString(),
                                title: title,
                                type: _site.toString().contains("whatsApp")
                                    ? "whatsApp"
                                    : "textMessage",
                                number: numberController.text,
                                message: messageController.text,
                                countryCode: countryCodeController.text,
                                name: nameController.text,
                                id: 5,
                                time: "${time.hour}:${time.minute}",
                                date: date.toString(),
                                notificationId: id,
                                repeatDay: dayLst[selectedDay],
                              );
                              storeData(
                                  dayLst[selectedDay],
                                  id,
                                  time,
                                  payLoad,
                                  value,
                                  title,
                                  "${countryCodeController.text}${numberController.text}",
                                  messageController.text,
                                  _site.toString().contains("whatsApp")
                                      ? "whatsApp"
                                      : "textMessage",
                                  modelValue);
                              Navigator.pop(context);
                            } else {
                              _cancelNotification(
                                  int.parse(dataModel.notificationId.toString()));
                              deleteData(dataModel.id);
                              var payLoad = [];
                              // var id = DateTime.now().toString().replaceAll(":", "").replaceAll(",", "").replaceAll(".", "").replaceAll("-", "").replaceAll(" ",  "").replaceAll(DateTime.now().year.toString(), "");
                              var id =
                                  "${DateTime.now().day.toString()}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
                              var title = titleController.text;
                              var value =
                                  "$id ${dayList[selectedDay]} ${time.hour}:${time.minute} ${titleController.text} ${_site} ${countryCodeController.text}${numberController.text} ${nameController.text}";
                              print(dayList[selectedDay]);
                              NotificationDataModel modelValue =
                                  NotificationDataModel(
                                createdTime: DateTime.now().toString(),
                                title: title,
                                type: _site.toString().contains("whatsApp")
                                    ? "whatsApp"
                                    : "textMessage",
                                number: numberController.text,
                                message: messageController.text,
                                countryCode: countryCodeController.text,
                                name: nameController.text,
                                id: 5,
                                time: "${time.hour}:${time.minute}",
                                date: date.toString(),
                                notificationId: id,
                                repeatDay: dayLst[selectedDay],
                              );
                              storeData(
                                  dayLst[selectedDay],
                                  id,
                                  time,
                                  payLoad,
                                  value,
                                  title,
                                  "${countryCodeController.text}${numberController.text}",
                                  messageController.text,
                                  _site.toString().contains("whatsApp")
                                      ? "whatsApp"
                                      : "textMessage",
                                  modelValue);
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                      child: Text(
                        "Done".tr,
                        style: TextStyle(color: themeData.dividerColor, fontSize: 13,),
                      ))
                ],
                title: Text("Schedule".tr,
                    style:
                        TextStyle(color: themeData.dividerColor, fontSize: 20,fontWeight: FontWeight.bold)),
              ),
              body: StatefulBuilder(
                builder: (context, state) {
                  return SingleChildScrollView(

                    child: Container(
                      color: themeData.cardColor,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 8, left: 8, bottom: 8, top: 10),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: themeData.backgroundColor,
                                      borderRadius: BorderRadius.circular(15)),
                                  height: 50,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter title'.tr;
                                          }
                                          return null;
                                        },
                                        style: TextStyle(
                                            color: themeData.dividerColor),
                                        controller: titleController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Notification Title".tr,
                                            hintMaxLines: 2,
                                            hintStyle: TextStyle(
                                                color: themeData.dividerColor
                                                    .withOpacity(0.5)))),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: themeData.backgroundColor),
                                  child: Column(
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: Get.width / 2.4,
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    minVerticalPadding: 0,
                                                    minLeadingWidth: 0,
                                                    horizontalTitleGap: 0,
                                                    title: Text(
                                                      "WhatsApp".tr,
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                    ),
                                                    leading: Radio(
                                                      value: MessageType.whatsApp,
                                                      groupValue: _site,
                                                      onChanged:
                                                          (MessageType? value) {
                                                        state(() {
                                                          _site = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: Get.width / 2.4,
                                                  child: ListTile(
                                                    horizontalTitleGap: 0,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    minVerticalPadding: 0,
                                                    title: Text(
                                                      "Text Message".tr,
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                    ),
                                                    minLeadingWidth: 0,
                                                    leading: Radio(
                                                      value:
                                                          MessageType.textMessage,
                                                      groupValue: _site,
                                                      onChanged:
                                                          (MessageType? value) {
                                                        state(() {
                                                          _site = value!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 10, left: 10, top: 5),
                                        child: Container(
                                          color: themeData.dividerColor,
                                          height: 1.5,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: themeData.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                height: 50,
                                                width: Get.width * 0.15,
                                                alignment: Alignment.center,
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: themeData
                                                            .dividerColor),
                                                    onTap: _showCountryPicker,
                                                    readOnly: true,
                                                    controller:
                                                        countryCodeController,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: "+91",
                                                        hintMaxLines: 2,
                                                        hintStyle: TextStyle(
                                                            color: themeData
                                                                .dividerColor
                                                                .withOpacity(
                                                                    0.5))),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    // validator: ,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 5,
                                              width: 10,
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    color: themeData.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                height: 50,
                                                width:
                                                    Get.width - (Get.width * 0.3),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 8),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter number'
                                                            .tr;
                                                      }
                                                      return null;
                                                    },
                                                    style: TextStyle(
                                                        color: themeData
                                                            .dividerColor),
                                                    controller: numberController,
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText: "Add Number".tr,
                                                        hintMaxLines: 2,
                                                        hintStyle: TextStyle(
                                                            color: themeData
                                                                .dividerColor
                                                                .withOpacity(
                                                                    0.5))),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    // validator: ,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              right: 8, left: 8, bottom: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 50,
                                                  width: Get.width * 0.15,
                                                  alignment: Alignment.center,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await FlutterContacts
                                                          .requestPermission();
                                                      final contact =
                                                          await FlutterContacts
                                                              .openExternalPick();
                                                      print(contact!.name);
                                                      print(contact.phones.first);
                                                      nameController.text =
                                                          contact.name.first;
                                                      numberController.text =
                                                          contact.phones.first
                                                              .number;
                                                      countryCodeController.text =
                                                          contact.phones.first
                                                              .normalizedNumber
                                                              .replaceAll(
                                                                  contact
                                                                      .phones
                                                                      .first
                                                                      .number,
                                                                  "");
                                                      state(() {});
                                                    },
                                                    child: Icon(
                                                      Icons
                                                          .account_circle_rounded,
                                                      color: Colors.blue,
                                                      size: 40,
                                                    ),
                                                  )),
                                              SizedBox(
                                                height: 5,
                                                width: 10,
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: themeData.cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  height: 50,
                                                  width: Get.width -
                                                      (Get.width * 0.3),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.only(left: 8),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please enter name'
                                                              .tr;
                                                        }
                                                        return null;
                                                      },
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                      controller: nameController,
                                                      decoration: InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: "Add Name".tr,
                                                          hintMaxLines: 2,
                                                          hintStyle: TextStyle(
                                                              color: themeData
                                                                  .dividerColor
                                                                  .withOpacity(
                                                                      0.5))),
                                                      // keyboardType:
                                                      // TextInputType
                                                      //     .,
                                                      // validator: ,
                                                    ),
                                                  )),
                                            ],
                                          ))
                                    ],
                                  )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 8, left: 8, bottom: 8),
                              child: Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: themeData.backgroundColor),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  // height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.swap_horiz_rounded,
                                                      color: themeData.cardColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Repeat".tr,
                                                  style: TextStyle(
                                                      color:
                                                          themeData.dividerColor),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                FocusManager.instance.primaryFocus?.unfocus();
                                                showDialog1(
                                                  CupertinoPicker(
                                                    magnification: 1.22,
                                                    squeeze: 1.2,
                                                    useMagnifier: true,
                                                    itemExtent: _kItemExtent,

                                                    // This is called when selected item is changed.
                                                    onSelectedItemChanged:
                                                        (int selectedItem) {
                                                      state(() {
                                                        selectedDay =
                                                            selectedItem;
                                                        // final temp = dayList[0];
                                                        // dayList[0] = dayList[selectedDay];
                                                        // dayList[selectedDay] = temp;
                                                        print(selectedDay);
                                                      });
                                                      state(() {});
                                                    },
                                                    children:
                                                        List<Widget>.generate(
                                                            dayList.length,
                                                            (int index) {
                                                      return Center(
                                                        child: Text(
                                                          dayList[index],
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                // height: 35,
                                                decoration: BoxDecoration(
                                                    color: themeData.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      dayList[selectedDay],
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 8, left: 8, bottom: 8),
                              child: Container(
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: themeData.backgroundColor),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  // height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_month_rounded,
                                                      color: themeData.cardColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Date".tr,
                                                  style: TextStyle(
                                                      color:
                                                          themeData.dividerColor),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus?.unfocus();

                                                showDialog1(
                                                  CupertinoDatePicker(
                                                    initialDateTime: date,
                                                    mode: CupertinoDatePickerMode
                                                        .date,
                                                    use24hFormat: true,
                                                    // This is called when the user changes the date.
                                                    onDateTimeChanged:
                                                        (DateTime newDate) {
                                                      state(() {
                                                        date = newDate;
                                                        day = DateFormat('EEEE')
                                                            .format(date);
                                                        print(day);
                                                      });
                                                      state(() {});
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: themeData.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "${date.day}-${date.month}",
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  // height: 35,
                                                  decoration: BoxDecoration(
                                                      color: Colors.orange,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Icon(
                                                      Icons.watch_later_outlined,
                                                      color: themeData.cardColor,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Time".tr,
                                                  style: TextStyle(
                                                      color:
                                                          themeData.dividerColor),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                FocusManager.instance.primaryFocus?.unfocus();

                                                showDialog1(
                                                  CupertinoDatePicker(
                                                    initialDateTime: time,
                                                    mode: CupertinoDatePickerMode
                                                        .time,
                                                    use24hFormat: true,
                                                    // This is called when the user changes the time.
                                                    onDateTimeChanged:
                                                        (DateTime newTime) {
                                                      state(() => time = newTime);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    color: themeData.cardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                alignment: Alignment.center,
                                                child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "${time.hour}-${time.minute}",
                                                      style: TextStyle(
                                                          color: themeData
                                                              .dividerColor),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(right: 8, left: 8, bottom: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: themeData.backgroundColor,
                                    borderRadius: BorderRadius.circular(15)),
                                // height: 50,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: TextFormField(
                                    maxLines: 4,
                                    keyboardType: TextInputType.multiline,
                                    style:
                                        TextStyle(color: themeData.dividerColor),
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Add Message".tr,
                                      hintMaxLines: 5,
                                      hintStyle: TextStyle(
                                        color: themeData.dividerColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  ScrollController scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  deleteData(id) async {
    await DB.instance.deleteSingleFromNotification(id);
    getData();
    // DateTime.parse(formattedString)
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
                    _cancelNotification(int.parse(
                        notificationList![i].notificationId.toString()));
                    deleteData(notificationList![i].id);
                    Navigator.pop(context);
                  },
                  child: Text('Yes'.tr,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'))),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('No'.tr, style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontFamily: 'SFProDisplay'))),
            ],
          );
        });
  }

  buildDeleteDialogueAndroid(i) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete!'.tr),
            content: Text("Sure Delete".tr),
            actions: [
              MaterialButton(
                onPressed: () {
                  _cancelNotification(int.parse(
                      notificationList![i].notificationId.toString()));
                  deleteData(notificationList![i].id);
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
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Text('No'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'SFProDisplay'),),)
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: themeData.backgroundColor,
      appBar: appBar,
      body: Container(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : notificationList!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/noData.png",width: Get.width / 2,),
                        SizedBox(height: 20,),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            "No Schedule".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: themeData.dividerColor),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              addScheduleNotification(
                                  false, NotificationDataModel());
                            },
                            child: Text(
                              "Add Schedule".tr,
                              style: TextStyle(color: Colors.green),
                            ))
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.builder(
                        itemCount: notificationList!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) => Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Slidable(
                              // groupTag: "a",
                              closeOnScroll: true,
                                endActionPane: ActionPane(
                                  extentRatio: 0.25,

                                  motion: ScrollMotion(),
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
                                    addScheduleNotification(
                                        true, notificationList![i]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: themeData.cardColor,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(right: 8, left: 8),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: notificationList![i]
                                                    .type!
                                                    .toLowerCase() ==
                                                "whatsapp"
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
                                              child: Container(
                                                // width: Get.width * 0.25,
                                                child: Text(
                                                  notificationList![i].name! ==
                                                          "null"
                                                      ? "UNKNOWN"
                                                      : notificationList![i]
                                                          .name!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: themeData
                                                          .dividerColor,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                " (${notificationList![i].countryCode!} ${notificationList![i].number!})",
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                    color: themeData
                                                        .dividerColor
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
                                                notificationList![i].message! ==
                                                        "null"
                                                    ? "No message"
                                                    : notificationList![i]
                                                        .message!.trim(),
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
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  notificationList![i]
                                                      .repeatDay!.tr,
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
                                        // Text("${historyData![i].message! == "null" ? "No message": historyData![i].name!}",style: TextStyle(color: themeData.dividerColor.withOpacity(0.5)),),
                                        // trailing:
                                        // IconButton(onPressed: (){
                                        //
                                        // }, icon: Icon(Icons.delete,color: themeData.dividerColor,)),
                                      ),
                                      // child: Row(
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //       historyData![i].number!,
                                      //       style: TextStyle(color: themeData.dividerColor),
                                      //     ),
                                      //     IconButton(onPressed: (){
                                      //
                                      //     }, icon: Icon(Icons.delete,color: themeData.dividerColor,))
                                      //   ],
                                      // )
                                    ),
                                  ),
                                )))),
                  ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
