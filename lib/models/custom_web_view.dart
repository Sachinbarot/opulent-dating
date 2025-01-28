// // ignore_for_file: library_private_types_in_public_api

// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// class CustomWebView extends StatefulWidget {
//   final String ? selectedUrl;

//   const CustomWebView({super.key, this.selectedUrl});

//   @override
//   _CustomWebViewState createState() => _CustomWebViewState();
// }

// class _CustomWebViewState extends State<CustomWebView> {
//   final flutterWebviewPlugin =  FlutterWebviewPlugin();

//   @override
//   void initState() {
//     super.initState();

//     flutterWebviewPlugin.onUrlChanged.listen((String url) {
//       if (url.contains("#access_token")) {
//         succeed(url);
//       }

//       if (url.contains(
//           "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
//         denied();
//       }
//     });
//   }

//   denied() {
//     Navigator.pop(context);
//   }

//   succeed(String url) {
//     var params = url.split("access_token=");

//     var endparam = params[1].split("&");

//     Navigator.pop(context, endparam[0]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//         url: widget.selectedUrl!,
//         appBar:  AppBar(
//           backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
//           title:  const Text("Facebook login"),
//         ));
//   }
// }
