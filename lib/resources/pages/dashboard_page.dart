import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/reward.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:flutter_app/resources/pages/daily_report_page.dart';
import 'package:flutter_app/resources/pages/profile_page.dart';
import 'package:flutter_app/resources/pages/reward_page.dart';
import 'package:flutter_app/resources/pages/weekly_report_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class DashboardPage extends NyStatefulWidget {
  static const path = '/dashboard';

  DashboardPage({super.key}) : super(path, child: () => _DashboardPageState());
}

class _DashboardPageState extends NyState<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    WeeklyReportPage(),
    DailyReportPage(),
    RewardPage(),
    ProfilePage(),
  ];

  List<Reward> rewards = [
    Reward(
        name: "Coffee Voucher", cost: 1, code: "COFFEE2024", redeemed: false),
    Reward(name: "Movie Ticket", cost: 2, code: "MOVIE2024", redeemed: false),
    Reward(
        name: "Amazon Gift Card", cost: 3, code: "AMAZON2024", redeemed: false),
  ];

  @override
  init() async {
    // await NyStorage.deleteCollection(
    //   StorageKey.test,
    // );

    await NyStorage.saveCollection(StorageKey.test, rewards);
  }

  /// Use boot if you need to load data before the [view] is rendered.
  // @override
  // boot() async {
  //
  // }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'Weekly Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range_outlined),
            label: 'Daily Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Reward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
