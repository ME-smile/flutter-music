import 'package:flutter/material.dart';

import 'pages/recommend.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecommendPage(),
    );
  }
}