import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';

class LandingPage extends NyStatefulWidget {
  static const path = '/landing';

  LandingPage({super.key}) : super(path, child: () => _LandingPageState());
}

class _LandingPageState extends NyState<LandingPage> {
  @override
  init() async {}

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Landing"),
        leading: SizedBox(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Container(
            child: Text("Landing page"),
          ),
        ),
      ),
    );
  }
}
