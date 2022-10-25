import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

class WebApp extends StatefulWidget {
  const WebApp({Key? key, required this.widgetChild}) : super(key: key);
  final Widget widgetChild;
  @override
  State<WebApp> createState() => WebAppState();
}

class WebAppState extends State<WebApp> {
  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (context) {
        return widget.widgetChild;
      },
      maximumSize: Size(475.0, 812.0),
      enabled: kIsWeb,
      backgroundColor: Colors.grey,
    );
  }
}
