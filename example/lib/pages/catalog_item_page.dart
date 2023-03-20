import 'package:cart_example/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_cart/shopping_cart.dart';

class CatalogItemPage extends GetView<CatalogItemPageController> {
  const CatalogItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItem = Get.arguments as FoodModel;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.network(cartItem.urlPhoto, fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cartItem.name, style: Get.textTheme.titleLarge),
              Text('\$${cartItem.price}', style: Get.textTheme.titleMedium),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: controller.specialInstruction,
            onChanged: (val) => controller.updateSpecialInstruction(),
            decoration: const InputDecoration(
              labelText: 'Special instructions',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => controller.updateQuantity(
                          controller.updatedModel.value.quantity - 1),
                      icon: const Icon(Icons.remove),
                    ),
                    Text('${controller.updatedModel.value.quantity}'),
                    IconButton(
                      onPressed: () => controller.updateQuantity(
                          controller.updatedModel.value.quantity + 1),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    controller.updateItemInCart();
                  },
                  icon: const Icon(Icons.update),
                  label: const Text('Update item'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CatalogItemPageController extends GetxController {
  final FoodModel oldModel;
  CatalogItemPageController(this.oldModel);

  late Rx<FoodModel> updatedModel;
  late TextEditingController specialInstruction;

  @override
  void onInit() {
    updatedModel = FoodModel.copy(oldModel).obs;

    specialInstruction =
        TextEditingController(text: updatedModel.value.specialInstruction);
    super.onInit();
  }

  void updateQuantity(int quantity) {
    updatedModel.update((val) {
      val!.quantity = quantity;
    });
  }

  void updateSpecialInstruction() {
    updatedModel.update((val) {
      val!.specialInstruction = specialInstruction.text;
    });
  }

  void updateItemInCart() {
    final instance = ShoppingCart.getInstance<FoodModel>();

    instance.updateItemInCart(oldModel, updatedModel.value);
    // instance.refreshCart();

    Get.back();
  }

  @override
  void onClose() {
    specialInstruction.dispose();
    super.onClose();
  }
}


