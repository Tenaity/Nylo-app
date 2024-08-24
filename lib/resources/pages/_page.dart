import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class Page extends NyStatefulWidget {
  static const path = '/';
  
  Page({super.key}) : super(path, child: () => _PageState());
}

class _PageState extends NyState<Page> {

  @override
  init() async {

  }
  
  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("")
      ),
      body: SafeArea(
         child: Container(),
      ),
    );
  }
}
