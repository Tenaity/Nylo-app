import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/reward.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RewardPage extends NyStatefulWidget {
  static const path = '/reward';

  RewardPage({super.key}) : super(path, child: () => _RewardPageState());
}

class _RewardPageState extends NyState<RewardPage> {
  int points = 0;

  List<Reward> rewards = [];

  @override
  init() async {
    points = await NyStorage.read<int>(StorageKey.points) ?? 0;
    List<dynamic> jsonList = await NyStorage.readCollection(StorageKey.test);
    rewards = jsonList.map((json) => Reward.fromJson(json)).toList();
    setState(() {});
  }

  Future<void> _exchangeReward(int index) async {
    Reward reward = rewards[index];
    if (points >= reward.cost) {
      // NyStorage.updateCollectionWhere<Reward>(
      //     (value) {
      //       value as Reward;
      //       return value.code == reward.code;
      //     },
      //     key: StorageKey.test,
      //     update: (value) {
      //       value as Reward;
      //       value.redeemed = true;
      //       return value;
      //     });

      setState(() {
        points -= reward.cost;
        reward.redeemed = true;
      });
      await NyStorage.deleteCollection(StorageKey.test);
      await NyStorage.saveCollection(StorageKey.test, rewards);
      await NyStorage.store(StorageKey.points, points);
      showToastSuccess(description: "Redeem successfully!");
    } else {
      _showErrorDialog("Not enough points to redeem this reward.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            ElevatedButton(
              child: Text("OK"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget view(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reward"),
        leading: Center(
          child: Text("Points: $points"),
        ),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            Reward reward = rewards[index];
            return Card(
              child: ListTile(
                title: Text(reward.name),
                subtitle: reward.redeemed
                    ? Text("Code: ${reward.code}")
                    : Text("Cost: ${reward.cost} points"),
                trailing: reward.redeemed
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : ElevatedButton(
                        onPressed: () => _exchangeReward(index),
                        child: Text("Redeem"),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}
