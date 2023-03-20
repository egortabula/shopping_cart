import 'package:cart_example/models/menu_demo_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:safe_int_id/safe_int_id.dart';
import 'package:shopping_cart/shopping_cart.dart';

import '../models/food_model.dart';
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    //TODO: add documentation
    ShoppingCart.init<FoodModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping cart demo'),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: add documentation
              Get.put(CartController());
              Get.toNamed('/cart');
            },
            icon: Obx(
              () {
                final instance = ShoppingCart.getInstance<FoodModel>();

                return Badge.count(
                  count: instance.itemCount,
                  isLabelVisible: instance.itemCount > 0 ? true : false,
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
          ),
        ],
      ),
      body: const SafeArea(
        minimum: EdgeInsets.all(16),
        child: CatalogList(),
      ),
    );
  }
}

class CatalogList extends StatelessWidget {
  const CatalogList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: (demoData.length / 2).ceil(),
      itemBuilder: (BuildContext context, int index) {
        final firstItem = demoData[index * 2];
        final secondItem = demoData[(index  * 2) + 1];
        return Row(
          children: [
            Flexible(
              child: _CatalogCard(catalogItem: firstItem),
            ),
            const SizedBox(width: 16),
            Flexible(
              child: _CatalogCard(catalogItem: secondItem),
            ),
          ],
        );
      },
      separatorBuilder: (context, int index) {
        return const SizedBox(height: 16);
      },
    );
  }
}

class _CatalogCard extends StatelessWidget {
  const _CatalogCard({required this.catalogItem});

  final MenuItem catalogItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Image.network(
              catalogItem.photoUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(catalogItem.name, style: Get.textTheme.titleLarge),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              //TODO: add documentation
              final instance = ShoppingCart.getInstance<FoodModel>();

              final FoodModel model = FoodModel(
                price: catalogItem.price,
                name: catalogItem.name,
                urlPhoto: catalogItem.photoUrl,
                id: SafeIntId().getId(),
              
              );
              instance.addItemToCart(model);
            },
            label: Text('\$${catalogItem.price}'),
            icon: const Icon(Icons.add_shopping_cart),
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}


