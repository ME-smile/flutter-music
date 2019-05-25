import 'package:flutter/material.dart';
import 'package:music/components/alphabet_slider.dart';
import 'package:music/components/loading.dart';
import 'package:music/dao/SingerDAO.dart';
import 'package:music/model/singer.dart';
import 'package:music/utils/config.dart';

import 'singer_detail.dart';

class SingerTabView extends StatefulWidget {
  @override
  _SingerTabViewState createState() => _SingerTabViewState();
}

class _SingerTabViewState extends State<SingerTabView> {
  static const int ALPHABET_LEN = 27;
  Map<String,double> _lettersPosMap;
  List result;
  List singerGroups;
  double _listTileLength;
  ScrollController _scrollController;
  int selectedIndex = 0;
  String selectedLetter = '';
  static const List<String> alphabets = [
    '🔥',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z'
  ];
  @override
  void initState() {
    super.initState();
    setState(() {
      _scrollController = ScrollController(initialScrollOffset: 0.0);
    });
  }

  static const double GROUP_TITLE_HEIGHT = 24.0;
  static const double PADDING_VERTICAL = 5.0;
  static const double AVATAR_WIDTH = 50.0;
  static const double DIVIDER_WIDTH = 1.0;
  // 存取每个标题的位置
  double _totalHeight;
  // 计算每个TIle的高度
  double get _listTileHeight {
    return PADDING_VERTICAL * 2 + AVATAR_WIDTH + DIVIDER_WIDTH;
  }

  @override
  void dispose() {
    super.dispose();
    _totalHeight = null;
    _scrollController = ScrollController(initialScrollOffset: 0.0);
  }

  void onVerticalDragDownHandler(DragDownDetails details) {
    setState(() {
      selectedIndex = getIndex(context, details.globalPosition, letterHeight);
      selectedLetter = alphabets[selectedIndex];
      _jumpTo(selectedIndex);
    });
  }

  void onVerticalDragEndHandler(DragEndDetails details) {}
  void onVerticalDragCancelHandler() {}

  Widget _buildSeparator(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        Container(
          height: GROUP_TITLE_HEIGHT,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          color: const Color(AppColorStyle.TitleBgColor),
          alignment: Alignment.centerLeft,
          child: Text(singerGroups[index + 1]['title'],
              style: AppTextStyle.SingerGroupTitle),
        ),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    Widget _buildSingerItem(singerModel) {
      return ListTile(
        title: Container(
          padding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: PADDING_VERTICAL),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: DIVIDER_WIDTH,
                  color: const Color(AppColorStyle.TitleBgColor)),
            ),
          ),
          child: Row(
            children: <Widget>[
              ClipOval(
                child: new FadeInImage.assetNetwork(
                  placeholder: 'lib/assets/imgs/default.jpg', //预览图
                  fit: BoxFit.fitHeight,
                  image: singerModel.avatar,
                  width: AVATAR_WIDTH,
                  height: AVATAR_WIDTH,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                singerModel.name,
                style: AppTextStyle.SingerName,
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingerDetail(id: singerModel.id)));
        },
      );
    }

    List temp = singerGroups[index]['items'];
    List<Widget> ret = temp.map((item) {
      return _buildSingerItem(item);
    }).toList();
    return Column(children: ret);
  }

  Widget _buildListView(context, snapshot) {
    if (snapshot.hasData) {
      _lettersPosMap = {alphabets[0]:0.0};
      _totalHeight = 0.0;
      result = snapshot.data['list']['artists'];
      singerGroups = SingerModel.normalizeSinger(result)
        ..insert(0, {'title': '🔥', 'items': []});
      int _len = singerGroups.length;
      String _title;
      int _itemsLen;
      for (int i = 1; i < _len; i++) {
        _itemsLen = singerGroups[i]['items'].length;
        _listTileLength = _itemsLen * _listTileHeight + GROUP_TITLE_HEIGHT;
        _totalHeight += _listTileLength;
        _title = singerGroups[i]['title'];
        _lettersPosMap[_title] = _totalHeight;
      }
      return ListView.separated(
        controller: _scrollController,
        itemCount: singerGroups.length,
        separatorBuilder: _buildSeparator,
        itemBuilder: _buildListTile,
      );
    } else {
      return Loading(isLoading: true,isFull: true,);
    }
  }

  // 获取字母索引
  int getIndex(BuildContext context, Offset globalPos, double letterHeight) {
    RenderBox _box = context.findRenderObject();
    var local = _box.globalToLocal(globalPos);
    int _currentIndex = (local.dy ~/ letterHeight).clamp(0, ALPHABET_LEN - 1);
    return _currentIndex;
  }

  void _jumpTo(int index) {
    if (_lettersPosMap.containsKey(alphabets[index])) {
      setState(() {
        _scrollController.animateTo(_lettersPosMap[alphabets[index]],
            curve: Curves.easeInOut, duration: Duration(microseconds: 100));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          FutureBuilder(
            future: getSingerData('hotSinger'),
            builder: _buildListView,
          ),
          Positioned(
            right: 2.0,
            top: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(20, 0, 0, 0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: AlphabetSilder(
                  onVerticalDragDown: onVerticalDragDownHandler,
                  onVerticalDragEnd: onVerticalDragEndHandler,
                  onVerticalDragCancel: onVerticalDragCancelHandler),
            ),
          ),
          Positioned(
            top: 50.0,
            left: 150.0,
            child: Offstage(
                offstage: false,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.black26,
                    ),
                    child: Text(selectedLetter),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
