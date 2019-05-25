import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading(
      {@required this.isLoading,
      @required this.isFull,
      this.child,
      Key key})
      : super(key: key);
  final bool isLoading;
  final bool isFull;
  final Widget child;

  Widget get _loadingView{
    return Center(child: CircularProgressIndicator(),);
  }
  @override
  Widget build(BuildContext context) {
    return !isFull
      ?isLoading?child:_loadingView:
      Stack(
        children: <Widget>[
          isLoading?_loadingView:null
        ],
      );
  }
}
