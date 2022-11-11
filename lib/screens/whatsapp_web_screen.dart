// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, unnecessary_null_comparison, avoid_print, prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_equal_for_default_values

import 'package:direct_chat/main.dart';
import 'package:direct_chat/screens/whatsapp_web_inner_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WhatsAppWebScreen extends StatefulWidget {
  const WhatsAppWebScreen({Key? key}) : super(key: key);

  @override
  State<WhatsAppWebScreen> createState() => _WhatsAppWebScreenState();
}

class _WhatsAppWebScreenState extends State<WhatsAppWebScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: themeData.backgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: MaterialButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WhatsappWebInnerScreen()));
                  },
                  child: Text("open whatsapp web".tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              )
            ],
          )),
    );
  }
}
