import 'dart:developer';

import 'package:get/get.dart';

import 'item_model.dart';

class Cart<T extends ItemModel> extends GetxController {
  Cart() : cartItems = <T>[].obs;

  /// List of items added to cart
  RxList<T> cartItems;

  /// Adds the given [item] to the cart represented by the [cartItems] list.
  void addItemToCart(T item) {
    if (containsCartItem(item)) {
      incrementItemQuantity(item);
      return;
    }
    cartItems.add(item);
    log('Item ${item.id} added to the cart');
  }

  /// Removes the given [itemModel] from the [cartItems] list and returns it.
  ///
  /// Throws a [StateError] if [itemModel] is not found in [cartItems].
  void removeItemFromCart(T itemModel) {
    var item = getItemFromCart(itemModel);
    cartItems.remove(item);
    log('Item ${item.id} removed');
  }

  /// Increases the quantity of an item in the cart by one.
  void incrementItemQuantity(T itemModel) {
    var item = getItemFromCart(itemModel);
    item.quantity = item.quantity + 1;
    cartItems.refresh();
  }

  /// decrement the quantity of an item in the cart by one.
  void decrementItemQuantity(T itemModel) {
    var item = getItemFromCart(itemModel);
    if (item.quantity == 1) {
      removeItemFromCart(itemModel);
    } else {
      item.quantity -= 1;
      cartItems.refresh();
    }
  }

  ///Removes all items from the cart.
  ///
  ///The clearCart method clears all items from the cart, which means that the [cartItems] list will be
  ///empty after the execution of this method.
  void clearCart() {
    cartItems.clear();
  }

  /// Returns the item in the cart with the specified ID.
  ///
  /// The `id` parameter is used to specify the ID of the item to find.
  ///
  /// Returns the item with the matching `id`. If the item is not found,
  /// this method throws a `StateError`.
  T findItemById(int id) {
    return cartItems.firstWhere(
      (element) => element.id == id,
      orElse: () => throw StateError('item not found in cart'),
    );
  }

  /// Returns the item from [cartItems] that matches the given [itemModel].
  ///
  /// Throws an [ArgumentError] if [itemModel] or [cartItems] are `null`.
  /// Throws a [StateError] if [itemModel] is not found in [cartItems].
  T getItemFromCart(T itemModel) {
    final matchingItems = cartItems.where((cartItem) => cartItem == itemModel);

    if (matchingItems.isEmpty) {
      throw StateError('item not found in cart');
    }
    if (matchingItems.length == 1) {
      return matchingItems.first;
    }
    return matchingItems.firstWhere(
      (cartITem) => cartITem.createdAt == itemModel.createdAt,
      orElse: () => throw StateError('item not found in cart'),
    );
  }

  /// Update an item in the cart with a new item.
  /// Throws a [StateError] if the old item is not found in the cart.
  ///
  /// If the old and new items are the same and have the same quantity,
  /// no update is performed.
  ///
  /// If the new item's quantity is 0, the old item will be removed from the cart.
  ///
  /// The `cartItems` will be updated and refreshed after the item is updated or removed.
  ///
  /// Parameters:
  ///   - oldItem: The old item in the cart to be updated.
  ///   - newItem: The new item to replace the old item in the cart.
  ///
  void updateItemInCart(T oldItem, T newItem) {
    final index = cartItems.indexWhere((item) => item.id == oldItem.id);
    if (index == -1) {
      throw StateError('item not found in cart');
    }
    if (oldItem == newItem && oldItem.quantity == newItem.quantity) {
      return;
    }
    if (newItem.quantity == 0) {
      removeItemFromCart(oldItem);
      return;
    }
    cartItems[index] = newItem;
    refreshCart();
  }

  /// Refreshes the contents of the cart items list.
  ///
  /// This method calls the `refresh()` method on an instance of [cartItems]
  /// named `cartItems`, which causes the list to emit a new event, triggering
  /// a rebuild of any widgets that depend on the list. This method can be used
  /// when the contents of the cart have changed, and the UI needs to be updated
  /// to reflect the changes.
  void refreshCart() {
    cartItems.refresh();
  }

  /// Returns `true` if an item with the specified [id] is already in the cart.
  ///
  /// Returns `false` otherwise.
  bool hasItemWithId(int id) {
    if (id <= 0) {
      throw ArgumentError('id must be a positive integer');
    }

    return cartItems.any((item) => item.id == id);
  }

  /// Returns true if the [itemModel] is already in the cart.
  ///
  /// Returns false if not
  bool containsCartItem(T itemModel) {
    return cartItems.any((e) => e == itemModel);
  }

  /// Returns the number of items currently in the cart.
  ///
  /// Returns an integer representing the number of items in the cart.
  int get itemCount {
    return cartItems.length;
  }

  /// Calculates the total price of an item with the specified [id] in the cart.
  ///
  /// Returns the total price of the item, which is the product of the item's price and quantity.
  /// Throws an [ArgumentError] if the [id] is not valid.
  double calculateItemTotalPriceById(int id) {
    if (id <= 0) {
      throw ArgumentError('id must be a positive integer');
    }
    final item = findItemById(id);
    return item.price * item.quantity;
  }

  /// Returns the total price of all items in the cart.
  ///
  /// This getter calculates the total price of all items in the cart by iterating through
  /// [cartItems] and adding the price of each item multiplied by its quantity. The result
  /// is returned as a [double] value.
  double get cartTotal {
    return cartItems.fold(
      0,
      (previousValue, e) => previousValue + (e.price * e.quantity),
    );
  }

  /// This getter returns the total price of all items in the cart as an integer.
  int get totalCartPriceInt {
    return cartItems.fold(
      0,
      (previousValue, e) => previousValue + (e.price * e.quantity).toInt(),
    );
  }

  /// A stream of [List<T>] that emits whenever the list of items in the cart changes.
  Stream<List<T>> get cartItemsStream {
    return cartItems.stream;
  }
}
