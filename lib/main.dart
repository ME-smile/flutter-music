import 'package:flutter/material.dart';
import 'package:music/utils/config.dart';
import 'package:provide/provide.dart';

import 'pages/main.dart';
import 'store/store.dart';

void main() {
  AudioModel audioModel = AudioModel();
  Providers providers = Providers()..provide(Provider<AudioModel>.value(audioModel));
  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'music',
      theme: ThemeData(
        primarySwatch: AppColorStyle.ThemeColor,
      ),
      home: MainPage(),
    );
  }
}
