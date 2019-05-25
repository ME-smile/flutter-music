import 'package:flutter/material.dart';
import 'package:music/utils/config.dart';
import 'package:provider/provider.dart';

import 'pages/main.dart';
import 'store/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<SongStore>(
      builder: (BuildContext context) => SongStore(),
      dispose: (context,value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'music',
        theme: ThemeData(
          primarySwatch: AppColorStyle.ThemeColor,
        ),
        home: MainPage(),
      ),
    );
  }
}
