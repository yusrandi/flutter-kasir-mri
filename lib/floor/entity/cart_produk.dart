
import 'package:floor/floor.dart';

@entity
class Cart{
  @primaryKey
  final int productId;

  final String uid, name, image;

  double price;
  int quantity;

  Cart(
      {required this.productId,
      required this.uid,
      required this.name,
      required this.image,
      required this.price,
      required this.quantity});
}