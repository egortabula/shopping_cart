import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/cart_page.dart';
import 'pages/menu_page.dart';

void main() {
  runApp(const ShoppingCartDemoApp());
}

class ShoppingCartDemoApp extends StatelessWidget {
  const ShoppingCartDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shopping cart demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      initialRoute: '/menu',
      routes: {
        '/menu': (context) =>  const MenuPage(),
        '/cart':  (context) => const CartPage(),
      },
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
