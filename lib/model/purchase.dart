class Purchase {
  // Properties representing various attributes of a purchase
  String orderId;
  String packageName;
  String productId;
  int purchaseTime;
  int purchaseState;
  String purchaseToken;
  int quantity;
  bool acknowledged;

  // Constructor for creating a Purchase object
  Purchase({
    required this.orderId,
    required this.packageName,
    required this.productId,
    required this.purchaseTime,
    required this.purchaseState,
    required this.purchaseToken,
    required this.quantity,
    required this.acknowledged,
  });

  // Factory constructor to deserialize JSON data into a Purchase object
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      orderId: json['orderId'],
      packageName: json['packageName'],
      productId: json['productId'],
      purchaseTime: json['purchaseTime'],
      purchaseState: json['purchaseState'],
      purchaseToken: json['purchaseToken'],
      quantity: json['quantity'],
      acknowledged: json['acknowledged'],
    );
  }
}
