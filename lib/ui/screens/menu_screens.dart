import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_bloc.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_event.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_state.dart';
import 'package:kasir_mri/bloc/produk_bloc/ProdukEvent.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_bloc.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_state.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/models/kategori_model.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/repo/kategori_repository.dart';
import 'package:kasir_mri/repo/produk_repository.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/cart/cart_page.dart';
import 'package:kasir_mri/ui/screens/menus/card_menu.dart';
import 'package:kasir_mri/ui/screens/menus/new_card_menu.dart';

class MenuScreensLandingPage extends StatelessWidget {
  final CartDAO dao;

  const MenuScreensLandingPage({Key? key, required this.dao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KategoriBloc(KategoriRepositoryImpl()),
      child: BlocProvider(
        create: (context) => ProdukBloc(ProdukRepositoryImpl()),
        child: MenuScreensPage(dao: dao),
      ),
    );
  }
}

class MenuScreensPage extends StatefulWidget {
  final CartDAO dao;

  const MenuScreensPage({Key? key, required this.dao}) : super(key: key);

  @override
  _MenuScreensPageState createState() => _MenuScreensPageState(dao: dao);
}

class _MenuScreensPageState extends State<MenuScreensPage> {
  int _index = 0;

  late KategoriBloc _kategoriBloc;
  late ProdukBloc _bloc;

  List<Kategori> listKategori = [];
  List<Produk> listProduk = [];
  List<Produk> newListProduk = [];

  final CartDAO dao;

  _MenuScreensPageState({required this.dao});

  @override
  void initState() {
    _bloc = BlocProvider.of<ProdukBloc>(context);
    _kategoriBloc = BlocProvider.of<KategoriBloc>(context);

    _bloc.add(FetchProdukEvent());
    _kategoriBloc.add(FetchKategoriEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.selectedTabBackgroundColor,
                  Colors.yellowAccent,
                ]),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 40, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: RichText(
                                text: TextSpan(children: [
                          TextSpan(
                              text: "Good Morning\n\n",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'how are u today manager,\n thx God to see u again',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ]))),
                        Image.asset(Images.homeImage),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 100,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                          height: 40,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(16)),
                          child: _kategoriBlocBuilder()),
                      SizedBox(height: 16),
                      _loadProduk(dao),
                    ],
                  ),
                ),
              )),
          Positioned(
              left: 10,
              right: 10,
              bottom: 70,
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CartLandingPage(dao: dao);
                  }));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.orange),
                  child: Center(
                    child: Text(
                      "CheckOut",
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _loadProduk(CartDAO dao) {
    return BlocListener<ProdukBloc, ProdukState>(
      listener: (context, state) {
        if (state is ProdukErrorState) {
          _alertError(state.msg);
        } else if (state is ProdukSuccessState) {
          _alertSuccess();
          _bloc.add(FetchProdukEvent());
        }
      },
      child: BlocBuilder<ProdukBloc, ProdukState>(
        builder: (context, state) {
          print("state $state");
          if (state is ProdukLoadedState) {
            listProduk = state.produks;
            newListProduk = state.produks;
            return CardMenu(listProduk, dao);
          } else if (state is ProdukInitialState ||
              state is ProdukLoadingState) {
            return _buildLoading();
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _kategoriBlocBuilder() {
    return BlocListener<KategoriBloc, KategoriState>(
      listener: (context, state) {
        if (state is KategoriErrorState) {
          _alertError(state.msg);
        }
      },
      child: BlocBuilder<KategoriBloc, KategoriState>(
        builder: (context, state) {
          print("state $state");
          if (state is KategoriLoadedState) {
            listKategori = state.kategoris;
            return _buildKategori(listKategori);
          }
          if (state is KategoriInitialState || state is KategoriLoadingState) {
            return _buildLoading();
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _listMenuTab(String title, int index, Kategori kategori) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _index = index;
          _bloc.add(FetchProdukEventByIdKategori(id: kategori.id));
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: _index == index
                ? AppTheme.selectedTabBackgroundColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16)),
        child: Text(title,
            style: TextStyle(
                color: _index == index
                    ? Colors.white
                    : AppTheme.selectedTabBackgroundColor,
                fontSize: 18,
                fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _buildKategori(List<Kategori> kategoris) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: kategoris.length,
        itemBuilder: (context, index) {
          var kategori = kategoris[index];
          return _listMenuTab(kategori.name, index, kategori);
        });
  }

  void _alertSuccess() {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs:
            ArtDialogArgs(type: ArtSweetAlertType.success, title: "Saved!"));
  }

  void _alertError(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Oops...",
            text: "There is a problem :("));
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
