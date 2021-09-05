import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/res/styling.dart';

class NewCardMenu extends StatefulWidget {
  List<Produk> listProduk;

  NewCardMenu({required this.listProduk});

  @override
  _NewCardMenuState createState() => _NewCardMenuState();
}

class _NewCardMenuState extends State<NewCardMenu> {
  int state = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.listProduk.isEmpty) return Center(child: Text("Menu Belum Tersedia"));
    return Container(
      height: 260,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.listProduk.length,
          itemBuilder: (context, index) {
            var produk = widget.listProduk[index];
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

                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        print(produk.nama);
                                        state++;

                                      });
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
                                        FontAwesomeIcons.plus,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(state.toString(), style: Theme.of(context).textTheme.headline6,),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        print(produk.nama);
                                        if (state > 0)
                                        state--;
                                      });
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
                                        FontAwesomeIcons.minus,
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
}
