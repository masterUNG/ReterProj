import 'package:flutter/material.dart';
import 'package:peteproj/main_home.dart';
import 'package:peteproj/show_ads.dart';

final Map<String, WidgetBuilder> map = {
  '/mainHome': (BuildContext context) => const MainHome(),
  '/showAds': (BuildContext context) => const ShowAds(),
};

String? firstState;

void main() {
  firstState = '/mainHome';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: firstState,
    );
  }
}
