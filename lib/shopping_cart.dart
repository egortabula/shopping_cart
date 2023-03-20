library shopping_cart;

import 'package:get/instance_manager.dart';

import 'shopping_cart.dart';

export 'src/cart.dart';
export 'src/item_model.dart';

class ShoppingCart {
  /// Initializes a new instance of `Cart<T>` and registers it with GetX.
  ///
  /// Use this method to initialize and register a new instance of `Cart<T>`
  /// with GetX. This is necessary to enable GetX to inject this instance
  /// of `Cart<T>` into any widget that depends on it.
  ///
  /// **Generic type parameter:**
  ///
  /// - `T`: The type of item in the cart.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// ShoppingCart.init<MenuItem>();
  /// ```
  static void init<T extends ItemModel>() {
    Get.put(Cart<T>());
  }

  /// Returns the current instance of `Cart<T>` registered with GetX.
  ///
  /// Use this method to retrieve the current instance of `Cart<T>` registered
  /// with GetX. This is useful when you need to access the `Cart<T>` instance
  /// from a widget that depends on it.
  ///
  /// **Generic type parameter:**
  ///
  /// - `T`: The type of item in the cart.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final instance = ShoppingCart.getInstance<MenuItem>();
  /// ```
  static Cart<T> getInstance<T extends ItemModel>() {
    return Get.find<Cart<T>>();
  }
}
