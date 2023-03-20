
import 'package:equatable/equatable.dart';
import 'package:shopping_cart/shopping_cart.dart';

class FoodModel extends ItemModel with EquatableMixin {
  final String name;
  final String urlPhoto;
  String specialInstruction;

  FoodModel({
    required this.name,
    required this.urlPhoto,
    this.specialInstruction = '',
    required super.id,
    required super.price,
    super.quantity = 1,
  });

  FoodModel.copy(FoodModel original)
      : name = original.name,
        urlPhoto = original.urlPhoto,
        specialInstruction = original.specialInstruction,
        super(
          quantity: original.quantity,
          id: original.id,
          price: original.price,
        );

  @override
  List<Object?> get props => [ name, urlPhoto, specialInstruction];
}
