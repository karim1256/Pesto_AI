import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key, required this.url});
  final String url;

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late WebViewController _controller;

  @override
  void initState() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(BackGroundColor)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onHttpError: (HttpResponseError error) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('success')) {
           var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
               cubit.premiumAccount(true);
                  buildSnackBar(
                    context,
                    'Payment Successful',
                    MainColor, // Add the missing third argument, adjust as needed
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);

                } else if 
                (request.url.contains('fail')) {
                  buildSnackBar(
                    context,
                    'Payment Failed',
                    Colors.red, // Add the missing third argument, adjust as needed
                  );
                  Navigator.pop(context);
                  // Handle error.
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
