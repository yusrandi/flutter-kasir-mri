import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_bloc.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_event.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_state.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/floor/entity/cart_produk.dart';
import 'package:kasir_mri/repo/transaksi_repo.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/menu_screens.dart';

class CartLandingPage extends StatelessWidget {
  final CartDAO dao;

  const CartLandingPage({Key? key, required this.dao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TransaksiBloc(TransaksiRepositoryImpl()),
        child: CartPage(
          dao: dao,
        ));
  }
}

class CartPage extends StatefulWidget {
  final CartDAO dao;

  const CartPage({Key? key, required this.dao}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late TransaksiBloc _bloc;

  final _etUang = new TextEditingController();
  double total = 0;
  double kembalian = 0.0;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TransaksiBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        if (state is TransaksiErrorState) {
          _alertError(state.msg);
        } else if (state is TransaksiSuccessState) {
          // _alertSuccess(state.msg);
          Navigator.pop(context);
        } else if (state is TransaksiLoadingState) {
          _alertLoading();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pesanan"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  AppTheme.selectedTabBackgroundColor,
                  Colors.yellow
                ])),
          ),
        ),
        body: _pageBody(size),
      ),
    );
  }

  Widget _pageBody(Size size) {
    return Container(
        padding: EdgeInsets.all(8),
        height: size.height,
        width: size.width,
        child: _buildCart());
  }

  Widget _buildCart() {
    return StreamBuilder(
        stream: widget.dao.getAllItemInCartByUid('NOT_SIGN_IN'),
        builder: (context, snapshot) {
          var items = snapshot.data as List<Cart>;
          print(items.length);
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      Cart cart = items[index];
                      print(cart.name);

                      return Container(
                        margin: EdgeInsets.only(bottom: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.selectedTabBackgroundColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            Container(
                              height: 105,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        Api.imageURL + "/" + cart.image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cart.name,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Text(
                                  "Rp. " +
                                      NumberFormat("#,##0", "en_US")
                                          .format(cart.price),
                                  style: TextStyle(color: Colors.orange),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () async {
                                          if (cart.quantity > 1) {
                                            cart.quantity -= 1;
                                            await widget.dao.updateCart(cart);
                                          }
                                        },
                                        child: Icon(FontAwesomeIcons.minus,
                                            size: 15)),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(cart.quantity.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          cart.quantity += 1;
                                          await widget.dao.updateCart(cart);
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.plus,
                                          size: 15,
                                        )),
                                  ],
                                ),
                              ],
                            )),
                            GestureDetector(
                              onTap: () async {
                                await widget.dao.deleteCart(cart);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppTheme.redBackgroundColor),
                                child: Icon(
                                  FontAwesomeIcons.trash,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                Divider(
                  thickness: 1,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Total",
                          style: (Theme.of(context).textTheme.headline6)),
                      Text(
                          items.length > 0
                              ? "Rp. " +
                                  NumberFormat("#,##0", "en_US").format(items
                                      .map((e) => e.price * e.quantity)
                                      .reduce(
                                          (value, element) => value + element))
                              : '0',
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Uang Diterima",
                          style: (Theme.of(context).textTheme.headline6)),
                      Expanded(
                          child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        margin: EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.hintTextColor, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              kembalian = double.parse(value) -
                                  items.map((e) => e.price * e.quantity).reduce(
                                      (value, element) => value + element);
                            });
                          },
                          controller: _etUang,
                          textAlign: TextAlign.end,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 16),
                              hintText: 'Uang Diterima'),
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Kembalian",
                          style: (Theme.of(context).textTheme.headline6)),
                      Text(
                          items.length > 0
                              ? "Rp. " +
                                  NumberFormat("#,##0", "en_US")
                                      .format(kembalian)
                              : '0',
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
                SizedBox(height: 26),
                GestureDetector(
                  onTap: () async {
                    String productId = "";
                    String qty = "";
                    items.asMap().forEach((index, element) {
                      if (index > 0) {
                        productId += ",";
                        qty += ",";
                      }
                      productId += element.productId.toString();
                      qty += element.quantity.toString();
                    });

                    double total = items
                        .map((e) => e.price * e.quantity)
                        .reduce((value, element) => value + element);

                    print(
                        "qty $qty , productId $productId , total $total, length ${items.length}");
                    if (_etUang.text.trim().isNotEmpty) {
                      _bloc.add(TransaksiStoreEvent(
                          total: total.toString(),
                          productId: productId,
                          qty: qty));
                      await widget.dao.clearCartByUid('NOT_SIGN_IN');
                    } else {
                      EasyLoading.showError("Isi Uang yg diterima!");
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              AppTheme.selectedTabBackgroundColor,
                              Colors.orange
                            ])),
                    child: Center(
                        child: Text("Selesai Transaksi",
                            style:
                                Theme.of(context).primaryTextTheme.headline6)),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _alertLoading() {
    CircularProgressIndicator();
  }

  void _alertSuccess(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs:
            ArtDialogArgs(type: ArtSweetAlertType.success, title: msg));
  }

  void _alertError(String msg) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.danger, title: "Oops...", text: msg),
    );
  }

  void gotoHomePage() {
    Navigator.of(context).pushReplacement(//new
        new MaterialPageRoute(
            //new
            settings: const RouteSettings(name: '/menu'), //new
            builder: (context) =>
                new MenuScreensLandingPage(dao: widget.dao)) //new
        //new
        );
  }
}
