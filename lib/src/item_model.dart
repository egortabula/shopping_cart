/// Abstract class for item model used in cart.
abstract class ItemModel {
  /// The unique identifier of the item.
  int id;

  /// The price of the item.
  double price;

  /// The quantity of the item in the cart.
  int quantity;

  /// The datetime when the item was created.
  DateTime createdAt;

  /// The total price of the item calculated by multiplying price with quantity.
  double get calculateTotalItemPrice {
    return price * quantity;
  }

  /// Constructor for ItemModel.
  /// [quantity] is set to 1 by default.
  ItemModel({
    this.quantity = 1,
    required this.id,
    required this.price,
  }) : createdAt = DateTime.now();
}
