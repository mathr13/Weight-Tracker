//MODELS
// abcd
class Weight {
  int timestamp;
  double value;
  String uniqueId;
  double change;
  String metric;

  Weight({this.timestamp, this.uniqueId, this.value, this.change, this.metric});

  factory Weight.fromJson(Map parsedJson) {
    return Weight(
      timestamp: parsedJson["timestamp"],
      value: parsedJson["weight"],
      change: parsedJson["change"],
      metric: parsedJson["metric"],
    );
  }
}
