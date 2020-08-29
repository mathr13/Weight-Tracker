//MODELS

class Weight {
  int timestamp;
  double value;
  String uniqueId;
  double change;

  Weight({this.timestamp, this.uniqueId, this.value, this.change});

  factory Weight.fromJson(Map parsedJson) {
    return Weight(
      timestamp: parsedJson["timestamp"],
      value: parsedJson["weight"],
      change: parsedJson["change"],
    );
  }
}
