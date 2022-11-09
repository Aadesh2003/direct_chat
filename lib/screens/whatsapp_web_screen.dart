// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors, unnecessary_null_comparison, avoid_print, prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names, prefer_equal_for_default_values

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WhatsAppWebScreen extends StatefulWidget {
  const WhatsAppWebScreen({Key? key}) : super(key: key);

  @override
  State<WhatsAppWebScreen> createState() => _WhatsAppWebScreenState();
}

class _WhatsAppWebScreenState extends State<WhatsAppWebScreen> {
  Completer<InAppWebViewController> _controller =
      Completer<InAppWebViewController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: InAppWebView(
            // zoomEnabled: false,
            onWebViewCreated: (InAppWebViewController InAppWebViewController) {
              _controller.complete(InAppWebViewController);
            },
            onLoadStart: (controller, url) async {
              setState(() {});
              // var response = await _controller.getHtml();
              _controller.future.then((value)  async {
                var response = await value.getHtml();
                // InAppWebViewHitTestResult;
                debugPrint("Response :-=-=-=-= ${response.toString()}");
              });
            },
            onLoadResource: (con,url) async {
              print("load resource :- ${con.getHtml()}");
            },
            onProgressChanged: (_controller,url) async {
              print("PROCESS :- $url");
            },
            // windowId: 1,
            // contextMenu: ContextMenu(menuItems: [ContextMenuItem(title: "demo")]),
            initialUrlRequest:
            URLRequest(url: Uri.parse('https://web.whatsapp.com'),),
            // URLRequest(url: Uri.parse('https://www.amazon.in')),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                userAgent:
                    "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
                preferredContentMode: UserPreferredContentMode.RECOMMENDED,
                // disableHorizontalScroll: true,
                // disableVerticalScroll: true
              ),
            ),
            // userAgent:
            //     "Mozilla/5.0 (Macintosh; Intel Mac OS X 12_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15",
            //   // User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 12_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.3 Safari/605.1.15
            // javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
        bottomNavigationBar: NavigationControls(_controller.future),
        // bottomNavigationBar: Container(
        //   child: Row(
        //     children: [
        //       IconButton(onPressed: (){
        //
        //       }, icon: Icon(Icons.arrow_back,color: _controller.canGoBack(),)),
        //       IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_rounded)),
        //     ],
        //   ),
        // )
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._InAppWebViewControllerFuture)
      : assert(_InAppWebViewControllerFuture != null);

  final Future<InAppWebViewController> _InAppWebViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InAppWebViewController>(
      future: _InAppWebViewControllerFuture,
      builder: (BuildContext context,
          AsyncSnapshot<InAppWebViewController> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final InAppWebViewController controller = snapshot.data!;
          return Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder(
                    future: controller.canGoBack(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return IconButton(
                        onPressed: () {
                          navigate(context, controller, goBack: true);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: snapshot.hasData && snapshot.data == true
                              ? Colors.black
                              : Colors.grey,
                        ),
                      );
                    }),
                FutureBuilder(
                    future: controller.canGoForward(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      return IconButton(
                        onPressed: () {
                          navigate(context, controller, goBack: false);
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: snapshot.hasData && snapshot.data == true
                              ? Colors.black
                              : Colors.grey,
                        ),
                      );
                    }),
                IconButton(
                  onPressed: () async {
                    await controller.reload();
                  },
                  icon: Icon(
                    Icons.refresh_rounded,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    for (var i = 0; i < 10000; i++) {
                      if (await controller.canGoBack()) {
                        controller.goBack();
                      } else {
                        return;
                      }
                    }
                  },
                  icon: Icon(
                    Icons.home,
                    size: 30,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            height: 10,
          );
        }
      },
    );
  }

  navigate(BuildContext context, InAppWebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    }
  }
}
