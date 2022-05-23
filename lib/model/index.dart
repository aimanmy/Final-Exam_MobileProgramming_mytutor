import 'package:flutter/material.dart';

import 'package:my_tutor/view/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        title: 'MyTutor',
        home: const Scaffold(
          body: SplashPage(),
        ));
  }
}
