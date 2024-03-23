import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purchases/controller/binding/purchase_binding.dart';
import 'package:purchases/controller/purchase_controller.dart';
import 'package:purchases/view/balance_page.dart';

void main() {
  runApp(const PurchasesApp());
}

class PurchasesApp extends StatelessWidget {
  const PurchasesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      getPages: [
        GetPage(
          name: '/', // Define the route name
          binding: PurchaseBinding(), // Binding for dependency injection
          page: () {
            return  BalancePage(); // The main page of the application
          },
        )
      ],
      initialRoute: '/', // Set the initial route
    );
  }
}
