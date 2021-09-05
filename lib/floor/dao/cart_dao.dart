import 'package:floor/floor.dart';
import 'package:kasir_mri/floor/entity/cart_produk.dart';


@dao
abstract class CartDAO{

  @Query('SELECT * FROM Cart WHERE uid=:uid')
  Stream<List<Cart>> getAllItemInCartByUid(String uid);
  
  @Query('SELECT * FROM Cart WHERE uid=:uid and productId=:id')
  Future<Cart?> getItemInCartByUid(String uid, int id);

  @Query('DELETE FROM Cart WHERE uid=:uid')
  Future<List<Cart>> clearCartByUid(String uid);
  
  @Query('Update Cart set uid=:uid')
  Future<void> updateUidCart(String uid);

  @insert
  Future<void> insertCart(Cart cart);
  
  @update
  Future<int> updateCart(Cart cart);
  
  @delete
  Future<int> deleteCart(Cart cart);

}