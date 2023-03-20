import 'package:cart_example/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/shopping_cart.dart';

import 'catalog_item_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final instance = ShoppingCart.getInstance<FoodModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: 'Confirm Clearing Cart',
                middleText:
                    'Are you sure you want to remove all items from your cart? This action cannot be undone.',
                textConfirm: 'Yes',
                onConfirm: () => instance.clearCart(),
                textCancel: 'No',
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            final item = instance.cartItems[index];
            return CartListItem(item);
          }),
          itemCount: instance.itemCount,
        );
      }),
      bottomNavigationBar: const _BottomBar(),
    );
  }
}

class CartListItem extends StatelessWidget {
  const CartListItem(this.cartItem, {super.key});

  final FoodModel cartItem;

  @override
  Widget build(BuildContext context) {
    final instance = ShoppingCart.getInstance<FoodModel>();

    return ListTile(
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Image.network(cartItem.urlPhoto),
      ),
      title: Text(cartItem.name),
      subtitle: Text(
          '\$${cartItem.calculateTotalItemPrice} ${cartItem.specialInstruction}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => instance.decrementItemQuantity(cartItem),
            icon: const Icon(Icons.remove),
          ),
          Text('${cartItem.quantity}'),
          IconButton(
            onPressed: () => instance.incrementItemQuantity(cartItem),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      onTap: () => _openItemBottomSheet(cartItem),
    );
  }

  void _openItemBottomSheet(FoodModel cartItem) async {
    await Get.bottomSheet(
      Builder(
        builder: (context) {
          Get.put(CatalogItemPageController(cartItem));
          return const CatalogItemPage();
        },
      ),
      clipBehavior: Clip.antiAlias,
      backgroundColor: Get.theme.colorScheme.surface,
      elevation: 1,
      settings: RouteSettings(arguments: cartItem),
    ).whenComplete(
      () => Get.find<CatalogItemPageController>().dispose(),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final instance = ShoppingCart.getInstance<FoodModel>();

    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Row(
        children: [
          Obx(
            () => Text.rich(
              TextSpan(
                text: '\$${instance.cartTotal}',
                children: [
                  TextSpan(
                    text: '\ntotal',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text('Checkout'),
            ),
          )
        ],
      ),
    );
  }
}

class CartController extends GetxController {
  final instance = ShoppingCart.getInstance<FoodModel>();
  @override
  void onReady() {
    ever(instance.cartItems, (callback) {
      if (callback.isEmpty) {
        Get.until((route) => Get.currentRoute == '/menu');
      }
    });
    super.onReady();
  }
}

