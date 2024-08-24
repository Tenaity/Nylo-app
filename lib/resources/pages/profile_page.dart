import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/reward.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:nylo_framework/nylo_framework.dart';

class ProfilePage extends NyStatefulWidget {
  static const path = '/profile';

  ProfilePage({super.key}) : super(path, child: () => _ProfilePageState());
}

class _ProfilePageState extends NyState<ProfilePage> {
  final String profileImage =
      'https://www.rainforest-alliance.org/wp-content/uploads/2021/06/capybara-square-1.jpg.optimal.jpg';
  final String userName = 'Ten Capy';
  final String userEmail = 'tenaiti.150320@gmail.com';
  int points = 0;

  List<Reward> rewards = [];
  List<Reward> redeemedRewards = [];

  @override
  init() async {
    points = await NyStorage.read<int>(StorageKey.points) ?? 0;
    List<dynamic> jsonList = await NyStorage.readCollection(StorageKey.test);
    rewards = jsonList.map((json) => Reward.fromJson(json)).toList();
    redeemedRewards = rewards.where((reward) => reward.redeemed).toList();
    setState(() {});
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        leading: Center(
          child: Text("Points: $points"),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(profileImage),
                ),
              ),
              SizedBox(height: 16),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                userEmail,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Redeemed Rewards',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: redeemedRewards.length,
                  itemBuilder: (context, index) {
                    Reward reward = redeemedRewards[index];
                    return Card(
                      child: ListTile(
                        title: Text(reward.name),
                        subtitle: Text("Code: ${reward.code}"),
                        trailing: Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
