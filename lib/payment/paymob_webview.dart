import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymobWebView extends StatefulWidget {
  final String paymentUrl;

  const PaymobWebView({super.key, required this.paymentUrl});

  @override
  State<PaymobWebView> createState() => _PaymobWebViewState();
}

class _PaymobWebViewState extends State<PaymobWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            // هنا المراقب السري بتاعنا!
            if (request.url.contains('success=true')) {
              // الدفع نجح! نقفل الشاشة ونرجع true
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            } else if (request.url.contains('success=false')) {
              // الدفع فشل! نقفل الشاشة ونرجع false
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع الآمن')),
      body: WebViewWidget(controller: controller),
    );
  }
}
