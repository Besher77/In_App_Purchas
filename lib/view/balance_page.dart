
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import the Get package
import 'package:purchases/controller/purchase_controller.dart'; // Import your purchase controller

class BalancePage extends StatelessWidget {
  BalancePage({super.key}); // Constructor

  // Initialize your PurchaseController and fetch products
  final PurchaseController controller = Get.find()..getProducts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases App'), // App title
      ),
      body:controller.isAv.isFalse? const Center(
        child: Text('Purchases are not available on your device.'),
      ): Column(
        children: [
          // Display current balance using Obx
          Center(
            child: Obx(() {
              return Text('Current Balance : ${controller.currentBalance.value}');
            }),
          ),
          const SizedBox(height: 20,),
          // Button to use balance
          ElevatedButton(
              onPressed: () {
                controller.decreaseBalance(10);
              },
              child: const Text('Use 10 Balance')
          ),
          const SizedBox(height: 20,),
          // Display list of products
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final product = controller.products[index];
                  return InkWell(
                    onTap: () {
                      controller.buyProduct(product);
                    },
                    child: Card(
                      child: ListTile(
                        leading: const Icon(Icons.add_card, size: 30),
                        title: Text(product.title),
                        subtitle: Text(product.price.toString()),
                      ),
                    ),
                  );
                },
                itemCount: controller.products.length,
              );
            }),
          )
        ],
      ),
    );
  }
}

// These comments provide clarity on the purpose of each section in your code.