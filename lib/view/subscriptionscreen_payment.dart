import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_tutor/model/config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../model/user.dart';

class SubscriptionPaymentScreen extends StatefulWidget {
  final User user;
  final double totalpayable;

  const SubscriptionPaymentScreen(
      {Key? key, required this.user, required this.totalpayable})
      : super(key: key);

  @override
  State<SubscriptionPaymentScreen> createState() =>
      _SubscriptionPaymentScreenState();
}

class _SubscriptionPaymentScreenState extends State<SubscriptionPaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    '${Config.server}/mytutor/mobile/php/payment.php?email=${widget.user.email}&mobile=${widget.user.phone}&name=${widget.user.name}&amount=${widget.totalpayable}',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            )
          ],
        ));
  }
}
