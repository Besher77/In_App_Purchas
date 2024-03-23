import 'dart:async';
import 'dart:convert';
import 'package:purchases/model/purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/web.dart'; // Import logger package

class PurchaseController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription _streamSubscription;
  final _productsIds = {'10_coins','50_coins','100_coins'}; // Product IDs
  final RxList<ProductDetails> products = RxList(); // List of products
  final RxBool isAv = false.obs; // Boolean to indicate availability
  final RxInt currentBalance = RxInt(0); // Current balance
  late SharedPreferences _preferences; // SharedPreferences instance

  @override
  void onInit() async {
    super.onInit();
    _isAvailable();
    _preferences = await SharedPreferences.getInstance(); // Initialize SharedPreferences
    _getCurrentBalance(); // Get current balance from SharedPreferences
    _streamSubscription = _inAppPurchase.purchaseStream.listen((event) {
      listenToPurchases(event); // Listen to purchase events
    });
  }

  void _getCurrentBalance() {
    currentBalance.value = _preferences.getInt('balance') ?? 0; // Get current balance from SharedPreferences
  }

  @override
  void onClose() {
    _streamSubscription.cancel(); // Cancel subscription
    super.onClose();
  }

  void _isAvailable() async {
    isAv(await _inAppPurchase.isAvailable()); // Check if in-app purchases are available
  }

  Future<bool> buyProduct(ProductDetails productDetails) async {
    return await _inAppPurchase.buyConsumable(purchaseParam: PurchaseParam(productDetails: productDetails)); // Buy a product
  }

  void getProducts() async {
    ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_productsIds); // Query product details
    if (response.productDetails.isNotEmpty) {
      products(response.productDetails); // Update products list
    } else {
      Logger().e('No Products Found'); // Log error if no products found
    }
  }

  void listenToPurchases(List<PurchaseDetails> event) {
    for (final purchase in event) {
      if (purchase.status == PurchaseStatus.purchased) {
        Purchase purchased = Purchase.fromJson(jsonDecode(purchase.verificationData.localVerificationData)); // Decode purchase details
        int purchasedBalance = getPurchasedBalance(purchased.productId); // Get purchased balance
        final balanceTotal = purchasedBalance * purchased.quantity; // Calculate total balance
        increaseBalance(balanceTotal); // Increase balance
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle purchase error
      }
    }
  }

  int getPurchasedBalance(String productId) {
    if (productId == '10_coins') {
      return 10;
    } else if (productId == '50_coins') {
      return 50;
    } else if (productId == '100_coins') {
      return 100;
    }
    return 0; // Return 0 if product ID is not recognized
  }

  void increaseBalance(int balance) {
    _preferences.setInt('balance', (currentBalance.value + balance)); // Increase balance in SharedPreferences
    _getCurrentBalance(); // Update current balance
  }

  void decreaseBalance(int balance) {
    if (currentBalance.value > 9) {
      _preferences.setInt('balance', (currentBalance.value - balance)); // Decrease balance in SharedPreferences
      _getCurrentBalance(); // Update current balance
    } else {
      Logger().e('Not enough balance'); // Log error if not enough balance
    }
  }
}
