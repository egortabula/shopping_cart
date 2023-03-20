![](https://img.shields.io/github/stars/egortabula/shopping_cart?style=social) ![](https://img.shields.io/github/checks-status/egortabula/shopping_cart/main) ![](https://img.shields.io/badge/Support-Android%20%7C%20IOS%20%7C%20Mac%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-brightgreen)
![](https://i.ibb.co/fdzqFyR/shopping-cart-flutter-package.jpg)

* 1. [About ShoppingCart](#AboutShoppingCart)
* 2. [Installing](#Installing)
	* 2.1. [Additional dependencies](#Additionaldependencies)
* 3. [Usage](#Usage)
	* 3.1. [Creating custom item class](#Creatingcustomitemclass)
	* 3.2. [Initialisation](#Initialisation)
	* 3.3. [Get instance](#Getinstance)
	* 3.4. [Getters](#Getters)
		* 3.4.1. [CartItems](#CartItems)
		* 3.4.2. [CartTotal](#CartTotal)
		* 3.4.3. [TotalCartPriceInt](#TotalCartPriceInt)
		* 3.4.4. [itemCount](#itemCount)
		* 3.4.5. [cartItemsStream](#cartItemsStream)
	* 3.5. [Methods](#Methods)
		* 3.5.1. [Get item from cart](#Getitemfromcart)
		* 3.5.2. [Finding an item by ID](#FindinganitembyID)
		* 3.5.3. [Has item with id](#Hasitemwithid)
		* 3.5.4. [Contains cart item](#Containscartitem)
		* 3.5.5. [Adding items to the cart](#Addingitemstothecart)
		* 3.5.6. [Removing items from the cart](#Removingitemsfromthecart)
		* 3.5.7. [Increment item quantity](#Incrementitemquantity)
		* 3.5.8. [Decrement item quantity](#Decrementitemquantity)
		* 3.5.9. [Calculate item total price by ID](#CalculateitemtotalpricebyID)
		* 3.5.10. [Update item](#Updateitem)
		* 3.5.11. [Refresh cart](#Refreshcart)
		* 3.5.12. [Clear all items](#Clearallitems)
	* 3.6. [Rebuild ui](#Rebuildui)
		* 3.6.1. [Use Get](#UseGet)
		* 3.6.2. [Use StreamBuilder](#UseStreamBuilder)
* 4. [Conclusion](#Conclusion)


##  1. <a name='AboutShoppingCart'></a>About ShoppingCart
ShoppingCart is a Flutter library that simplifies the creation and management of a shopping cart in your Flutter applications.
##  2. <a name='Installing'></a>Installing
Add the following dependency to your pubspec.yaml file:
```yaml
dependencies:
  shopping_cart: ^0.0.1
```
Then, import the library in your Dart code:
```dart
import 'package:food_cart/food_cart.dart';
```
###  2.1. <a name='Additionaldependencies'></a>Additional dependencies
I also recommend adding the following 2 packages, they are necessary for the full functioning of the library.
```yaml
dependencies:
  get:
  equatable:
```
- "[Get](https://pub.dev/packages/get)" is an excellent state management tool. The **ShoppingCart** is made using it. You will need it if you want to make the values of the shopping cart observable (_like items in cart screen or total cart price for example_). But it's not mandatory, as I've added the ability to use Streams if you don't want to use Get.
- The package "[Equatable](https://pub.dev/packages/equatable)" is necessary to compare the models of your products in the cart and find the necessary one.


##  3. <a name='Usage'></a>Usage
###  3.1. <a name='Creatingcustomitemclass'></a>Creating custom item class
Firstly you need to create a model of your product, this is a mandatory step!

Simply create a class with any name and extend it from the **ItemModel** class, which is part of this package, and also, if you added the equatable package, add the **EquatableMixin** mixin.


```dart
import 'package:equatable/equatable.dart';
import 'package:food_cart/food_cart.dart';

class FoodModel extends ItemModel with EquatableMixin {
    // Create all the fields of the class 
    // that you need for your specific case.
  final String name;
  final String urlPhoto;
  String specialInstruction;

  FoodModel({
    required this.name,
    required this.urlPhoto,
    this.specialInstruction = '',

    // this field come from ItemModel class
    required super.id, 

    // This field come from ItemModel class
    required super.price,

    // This field come from ItemModel class
    super.quantity = 1,
  });
  

  // This line of code comes from equatable package, 
  // and it is required! In square brackets pass all fields
  // from your model, but don't pass 'id', 'price' and 'quantity'!!!
  @override
  List<Object?> get props => [ name, urlPhoto, specialInstruction]; 
}
```

The abstract class ItemModel already has 3 mandatory fields without which nothing will work:

- Unique id (`id`)
- Quantity of goods (`quantity`)
- Cost of goods (`price`)
  
Therefore, please do not recreate these fields in your class!

###  3.2. <a name='Initialisation'></a>Initialisation
After you have created your item model, it is necessary to initialize the shopping cart. This should be done before you start using the API of this package.

To get started, call the `ShoppingCart.init<T>()` method to initialize a new instance of Cart<T> and register it. Replace <T> with the type of item that you want to add to the cart. For example, to add FoodModel objects to the cart:
```dart
ShoppingCart.init<FoodModel>();
```

###  3.3. <a name='Getinstance'></a>Get instance
One of the great advantages of my package is that you can get the cart instance anywhere in your code and you don't need to save and pass it from screen to screen on your own.

To retrieve the current instance of Cart<T> call the ShoppingCart.getInstance<T>() method. For example:
```dart
final cart = ShoppingCart.getInstance<FoodModel>();
```
Make sure to pass your item model class that you created at the beginning of this guide in <> brackets, in my case it's FoodModel. If you don't pass it, you will get an error!

###  3.4. <a name='Getters'></a>Getters
####  3.4.1. <a name='CartItems'></a>CartItems
To get the list of items in the cart, simply access the cartItems getter.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final items = instance.cartItems;
```

The `cartItems` object is already observable and has the type `RxList<T>` since I used Get package.

####  3.4.2. <a name='CartTotal'></a>CartTotal

Returns the total price of all items in the cart.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final cartTotal = instance.cartTotal;
```

This getter calculates the total price of all items in the cart by iterating through `cartItems` and adding the price of each item multiplied by its quantity. The result is returned as a `double`.

####  3.4.3. <a name='TotalCartPriceInt'></a>TotalCartPriceInt
This getter returns the total price of all items in the cart as an integer. This is simmilar to `cartTotal`, but it return `int`

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final totalCartPriceInt = instance.totalCartPriceInt;
```

####  3.4.4. <a name='itemCount'></a>itemCount
 Returns the number of items currently in the cart.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final cartLength = instance.itemCount;
```

This is same as `instance.cartItems.length`

####  3.4.5. <a name='cartItemsStream'></a>cartItemsStream
A stream of `cartItems` that emits whenever the list of items in the cart changes.
```dart
class CartITemsStreamWidgetExample extends StatelessWidget {
  const CartITemsStreamWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {

    // Get cart instance
    final cartInstance = ShoppingCart.getInstance<FoodModel>();

    // Stream will return List<YOUR ITEM MODEL>
    return StreamBuilder<List<FoodModel>>(

    // pass getter cartITemsStream
      stream: cartInstance.cartItemsStream,

      // Pass the cartItems as initialData
      // to the stream builder, otherwise, the stream builder will
      // initially return an empty list.
      initialData: cartInstance.cartItems,
      builder: (context, AsyncSnapshot<List<FoodModel>> snap) {

        // retrive data from snaphot and use it
        final List<FoodModel> items = snap.data!;
        
        return; /// return any widget you need
      },
    );
  }
}
```

###  3.5. <a name='Methods'></a>Methods

####  3.5.1. <a name='Getitemfromcart'></a>Get item from cart
Returns the item from `cartItems` that matches the given `itemModel`.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final item = instance.getItemFromCart(yourItemModel);
```
This method is mainly used for all other methods, such as increasing the quantity of an item, decreasing it, deleting it, updating it. But in some cases, you may also need it.

####  3.5.2. <a name='FindinganitembyID'></a>Finding an item by ID

To find an item in the cart by ID, call the `findItemById` method on the Cart instance:

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

final item = instance.findItemById(1);
```

####  3.5.3. <a name='Hasitemwithid'></a>Has item with id
Returns `true` if an item with the specified `id` is already in the cart. Returns `false` otherwise.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// return true if item with the specified `id` is already in the cart
// return false if item with the specified `id is is not added to the cart
// Throw ArgumentError if id <= 0
final bool result = instance.hasItemWithId(1);
```

####  3.5.4. <a name='Containscartitem'></a>Contains cart item
This method checks if the item is already in the cart.

This is like method `getItemFromCart`, but this method will return a bool value

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// Returns true if the [itemModel] is already in the cart.
// Returns false if not
final bool result = instance.containsCartItem(yourItemModel);
```

####  3.5.5. <a name='Addingitemstothecart'></a>Adding items to the cart
To add an item to the cart, simply call the `addItemToCart` method on the Cart instance:

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// create your item model
final item = FoodModel(
  id: 1,
  name: 'Cheeseburger',
  price: 8.99,
  urlPhoto: 'https://example.org/Cheeseburger',
);

// add item to the cart
instance.addItemToCart(item);
```
If the item already exists in the cart, its quantity will be **increased by one**.

####  3.5.6. <a name='Removingitemsfromthecart'></a>Removing items from the cart
To remove an item from the cart, call the removeItemFromCart method on the Cart instance:

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// Pass your item model as argument
// This method will find the right model in cart items and it will remove it
instance.removeItemFromCart(item); 
```

####  3.5.7. <a name='Incrementitemquantity'></a>Increment item quantity
Increases the quantity of an item in the cart by one.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// It will fint the right item in cartItem and it will
// increment quantity by 1.
instance.incrementItemQuantity(yourItem);
```

####  3.5.8. <a name='Decrementitemquantity'></a>Decrement item quantity
Decrement the quantity of an item in the cart by one.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// It will fint the right item in cartItem and it will
// decrement quantity by 1.
instance.decrementItemQuantity(yourItem);
```
**if the quantity of item is equal to 1, it will remove your item from cart!**

####  3.5.9. <a name='CalculateitemtotalpricebyID'></a>Calculate item total price by ID
Calculates the total price of an item with the specified `id` in the cart.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// Returns the total price of the item, 
// which is the product of the item's price and quantity.
/// Throws an [ArgumentError] if the [id] is not valid.
final double totalPrice = instance.calculateItemTotalPriceById(1);
```

But you can also use the getter `calculateTotalItemPrice` from `ItemModel`. It will do the same.

For example

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

// get your item instance
final item = instance.findItemById(1);

 /// The total price of the item calculated 
 /// by multiplying price with quantity.
final double totalItemPrice = item.calculateTotalItemPrice;
```

####  3.5.10. <a name='Updateitem'></a>Update item
In some case you may need to update your item model values.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

instance.updateItemInCart(oldModel, updatedModel);
```
Throws a `StateError` if the old item is not found in the cart.

If the old and new items are the same and have the same quantity, no update is performed.

If the new item's quantity is 0, the old item will be removed from the cart.

The `cartItems` will be updated and refreshed after the item is updated or removed.

**Parameters**:
- oldItem: The old item in the cart to be updated.
- newItem: The new item to replace the old item in the cart.

The full example of using this method will be shown below.

####  3.5.11. <a name='Refreshcart'></a>Refresh cart
Use this method to update the UI after updating the values in your product model.

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

instance.refreshCart();
```

But do not use this method with other methods of this package as they already use it by default.

####  3.5.12. <a name='Clearallitems'></a>Clear all items
To clear all items from the cart, call the clearCart method on the Cart instance:

```dart
final instance = ShoppingCart.getInstance<FoodModel>();

instance.clearCart();
```

###  3.6. <a name='Rebuildui'></a>Rebuild ui
Most likely, you will want to update (redraw) the ui, for example, when a new item is added to the cart, or when the total cost of all items in the cart is updated.

As I mentioned before, `cartItems` is observable and uses Get for this purpose. Below, I will show two ways to rebuild the ui when performing any manipulations with `cartItems`. 

And for this, you won't need to use `StatefulWidgets` and `SetState`!

####  3.6.1. <a name='UseGet'></a>Use Get
For example, let's say we need to display the total price of items in the cart on the screen, but we also need the widget with the total price to be redrawn every time the user, for example, removes an item from the cart or changes its quantity.


```dart
class TotalCartPriceWidget extends StatelessWidget {
  const TotalCartPriceWidget({super.key});

  @override
  Widget build(BuildContext context) {

    // get cart instance
    final cartInstance = ShoppingCart.getInstance<FoodModel>();

    // get cart total
    final cartTotal = cartInstance.cartTotal;

    // text widget with cart total
    return Text('Cart total $cartTotal');
  }
}
```
If you will try to use it, you will see, that when you try for example remove one item from cart, your ui will not rebuild.

For make it rebuild you need to wrap your `Text` widget with `Obx` widget witch come from Get package and it will work fine

```dart
class TotalCartPriceWidget extends StatelessWidget {
  const TotalCartPriceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartInstance = ShoppingCart.getInstance<FoodModel>();
    final cartTotal = cartInstance.cartTotal;

    return Obx(
      () => Text('Cart total $cartTotal');
    );
  }
}
```
All you need to redraw your ui, is to wrap any getter of this package with the `Obx` widget, and then every time cartItems is updated, your UI will be redrawn! It's really easy!
___

Lets look for another example. For example we will display all items in cart in list and by long tap we will remove item from cart and it will rebuild ui automatically!

```dart
class ItemsListWidget extends StatelessWidget {
  const ItemsListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    // get cart instance
    final instance = ShoppingCart.getInstance<FoodModel>();

    // Use Obx widget for make ui rebuild any time 
    // when cartItems is updated
    return Obx(
      () => ListView.builder(
        itemBuilder: (context, int index) {

          // get single item from cartItems by index
          final item = instance.cartItems[index];

          return ListTile(
            title: Text(item.name),
            leading: Image.network(item.urlPhoto),
            trailing: Text('${item.calculateTotalItemPrice}'),

            // remove item from cart onLongPressEvent
            // it will rebuild your ui automatically
            onLongPress: () => instance.removeItemFromCart(item),
          );
        },
        // pass cart items length by using getter `itemCount`
        itemCount: instance.itemCount,
      ),
    );
  }
}
```
About how Obx works, you can read on the [Get package page](https://pub.dev/packages/get).

You can check out a complete example of using this package by downloading the example project from [Github repo](https://github.com/egortabula/shopping_cart) and running it on your machine. Everything is already set up and working there. I tried to use all the features of this package in that project!
____

####  3.6.2. <a name='UseStreamBuilder'></a>Use StreamBuilder
If for some reason you don't want to use Get, I have also created a stream that returns the `cartItems`.

**Example of usage**

```dart
class ItemsListStreamWidget extends StatelessWidget {
  const ItemsListStreamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // get cart instance
    final instance = ShoppingCart.getInstance<FoodModel>();

    return StreamBuilder(
      // pass cartItemsStream
      stream: instance.cartItemsStream,

      // pass cartItems as initialData, it will return the current state of cartItems.
      initialData: instance.cartItems,
      // snapshot will return you a List<YOUR ITEM MODEL>, in my case FoodModel
      builder: (context, AsyncSnapshot<List<FoodModel>> snap) {

        // get data from snapshot
        final List<FoodModel> data = snap.data!;

        // Next return any widget you want and ui will rebuild automatically 
        //when cartITems was updated
        return ListView.builder(
          itemBuilder: (context, int index) {
            // get single item from cartItems by index
            final item = data[index];

            return ListTile(
              title: Text(item.name),
              leading: Image.network(item.urlPhoto),
              trailing: Text('${item.calculateTotalItemPrice}'),

              // remove item from cart onLongPressEvent
              // it will rebuild your ui automatically
              onLongPress: () => instance.removeItemFromCart(item),
            );
          },
          itemCount: instance.itemCount,
        );
      },
    );
  }
}
```
##  4. <a name='Conclusion'></a>Conclusion
Thank you for watching until the end! I hope I was able to explain how this package works. But if you still have any questions, you can write to me on [Telegram](https://t.me/egor_tabula) or [GitHub](https://github.com/egortabula/shopping_cart), and I will try to help as much as possible.

I created this package for myself, as I often develop applications with a shopping cart. This package speeds up my work, and I hope it will help you too.


[![Buy me a coffe](https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png "Buy me a coffe")](https://www.buymeacoffee.com/egortabula "Buy me a coffe")