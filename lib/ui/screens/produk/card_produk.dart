import 'package:flutter/material.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_bloc.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/res/styling.dart';

class CardProduk extends StatelessWidget {

  List<Produk> listProduk;
  ProdukBloc bloc;

  CardProduk(this.listProduk, this.bloc);

  @override
  Widget build(BuildContext context) {
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
                                        "Rp. ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      ),
                                      Text(
                                        produk.harga,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppTheme
                                                .selectedTabBackgroundColor),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppTheme.redBackgroundColor),
                                        child: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
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
}
