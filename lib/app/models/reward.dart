import 'dart:convert';

class Reward {
  final String name;
  final int cost;
  final String code;
  bool redeemed;

  Reward({
    required this.name,
    required this.cost,
    required this.code,
    this.redeemed = false,
  });

  // Convert Reward to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cost': cost,
      'code': code,
      'redeemed': redeemed,
    };
  }

  factory Reward.fromMap(Map<String, dynamic> map) {
    return Reward(
      name: map['name'],
      cost: map['cost'],
      code: map['code'],
      redeemed: map['redeemed'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reward.fromJson(String source) => Reward.fromMap(json.decode(source));
}
