import 'package:flutter/material.dart';

// 控制app颜色
class AppColorStyle {
  //主体颜色
  static const ThemeColor = Colors.blue;

  // 歌手页面标题背景颜色
  static const TitleBgColor = 0xffebebeb;

  static const Color accentColor = const Color(0xFFf08f8f);
  static const Color lightAccentColor = const Color(0xFFFFAFAF);
  static const Color darkAccentColor = const Color(0xFFD06F6F);
}

// 控制app字体
class AppTextStyle {
  // 导航条夜色
  static const TextStyle NavigationTitle =
      TextStyle(fontWeight: FontWeight.w100, fontSize: 18.0);
  static const TextStyle TTILE_3 =
      TextStyle(fontWeight: FontWeight.w300, fontSize: 18.0);
  //短描字体
  static const TextStyle BrifeDesc = TextStyle(fontSize: 12.0);

  //歌手页面标题
  static const TextStyle SingerGroupTitle =
      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600);
  // 歌手名字样式
  static const TextStyle SingerName = TextStyle(fontSize: 14.0);
  //字母表样式
  static const TextStyle Alphabet = TextStyle(fontSize: 16.0);
}
