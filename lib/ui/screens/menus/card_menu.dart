import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/floor/entity/cart_produk.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';

class CardMenu extends StatelessWidget {
  List<Produk> listProduk;
  CartDAO dao;

  CardMenu(this.listProduk, this.dao);
  int state = 0;

  @override
  Widget build(BuildContext context) {
    if (listProduk.isEmpty) return Center(child: Text("Menu Belum Tersedia"));
    return Container(
      height: 230,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listProduk.length,
          itemBuilder: (context, index) {
            var produk = listProduk[index];
            return Row(
              children: [
                Container(
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Container(
                        height: 135,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  Api.imageURL + "/" + produk.foto),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                produk.nama,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Rp. " +
                                            NumberFormat("#,##0", "en_US")
                                                .format(
                                                    int.parse(produk.harga)),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      )
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        Cart? cartProduk =
                                            await dao.getItemInCartByUid(
                                                'NOT_SIGN_IN', produk.id);

                                        // ignore: unnecessary_null_comparison
                                        if (cartProduk != null) {
                                          print('not null');
                                          cartProduk.quantity += 1;
                                          await dao.updateCart(cartProduk);
                                          showSnackBar(
                                              context,
                                              'Update Item Success ' +
                                                  cartProduk.quantity
                                                      .toString());

                                          print('Update');
                                        } else {
                                          print('null');
                                          Cart cart = new Cart(
                                              productId: produk.id,
                                              uid: 'NOT_SIGN_IN',
                                              name: produk.nama,
                                              image: produk.foto,
                                              price: double.parse(produk.harga),
                                              quantity: 1);
                                          await dao.insertCart(cart);

                                          showSnackBar(
                                              context,
                                              'Insert Item Success '
                                                  .toString());
                                          print('Insert');

                                        }
                                        
                                      } catch (e) {
                                        print('Error ${e.toString()}');

                                        showSnackBar(context, e.toString());
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppTheme
                                              .selectedTabBackgroundColor),
                                      child: Icon(
                                        state == 0 ? Icons.add : Icons.close,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
              ],
            );
          }),
    );
  }

  void showSnackBar(BuildContext context, String e) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('$e'),
      action: SnackBarAction(
        label: 'View Bag',
        onPressed: () {},
      ),
    ));
  }
}
