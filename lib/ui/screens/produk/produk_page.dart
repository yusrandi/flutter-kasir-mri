import 'dart:convert';
import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_bloc.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_event.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_state.dart';
import 'package:kasir_mri/bloc/produk_bloc/ProdukEvent.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_bloc.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_state.dart';
import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/kategori_model.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/repo/kategori_repository.dart';
import 'package:kasir_mri/repo/produk_repository.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/menus/card_menu.dart';
import 'package:kasir_mri/ui/screens/produk/card_produk.dart';
import 'package:kasir_mri/ui/screens/widgets/danger_button.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class ProdukLandingPage extends StatelessWidget {
  const ProdukLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ProdukBloc(ProdukRepositoryImpl()),
        child: BlocProvider(
          create: (context) => KategoriBloc(KategoriRepositoryImpl()),
          child: ProdukPage(),
        ));
  }
}

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  double _loginYOffset = 0.0;
  double _loginHeight = 0;
  double _loginOpacity = 0;
  double _homeOpacity = 1;

  bool keyboardVisibility = false;

  int _pageState = 0;

  final _name = new TextEditingController();
  final _harga = new TextEditingController();
  final _modal = new TextEditingController();

  File? _imageFile = null;
  final ImagePicker _picker = ImagePicker();

  late ProdukBloc _bloc;
  late KategoriBloc _kategoriBloc;

  int _index = 0;
  List<Kategori> _listKategori = [];

  late String resId = "",
      resImage = "",
      resKategoriId = "",
      resNama = "",
      resModal = "",
      resHarga = "";
  late File? resFile = null;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<ProdukBloc>(context);
    _kategoriBloc = BlocProvider.of<KategoriBloc>(context);

    _bloc.add(FetchProdukEvent());
    _kategoriBloc.add(FetchKategoriEvent());

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      keyboardVisibility = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _loginHeight = size.height - (size.height / 2);

    switch (_pageState) {
      case 0:
        print("_ProdukPageState $keyboardVisibility");
        _loginYOffset = size.height;
        _loginHeight =
            keyboardVisibility ? size.height : size.height - (size.height / 2);
        _loginOpacity = 1;
        _homeOpacity = 1;
        break;
      case 1:
        print("_ProdukPageState $keyboardVisibility");
        _loginYOffset = keyboardVisibility ? 30 : 30;
        _loginHeight = keyboardVisibility ? size.height : size.height;
        _loginOpacity = 1;
        _homeOpacity = 0;
        break;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Produk"),
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
        body: Container(
            height: size.height,
            width: size.width,
            child: Stack(children: [
              Container(
                  color: Colors.white.withOpacity(_homeOpacity),
                  child: _pageBody()),
              _loginContainer(size),
              Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton(
                    backgroundColor: AppTheme.selectedTabBackgroundColor,
                    onPressed: () {
                      setState(() {
                        _pageState = 1;
                      });
                    },
                    child: Icon(Icons.add),
                  ))
            ])));
  }

  Widget _pageBody() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 40,
            child: _loadKategori(),
          ),
          // SizedBox(height: 16),
          // CardMenu(),
          SizedBox(height: 16),
          _loadProduk()
        ],
      ),
    );
  }

  Widget _loadProduk() {
    return BlocListener<ProdukBloc, ProdukState>(
      listener: (context, state) {
        if (state is ProdukErrorState) {
          EasyLoading.showError(state.msg);
        } else if (state is ProdukSuccessState) {
          EasyLoading.showSuccess("Success");
          _bloc.add(FetchProdukEvent());
        }
      },
      child: BlocBuilder<ProdukBloc, ProdukState>(
        builder: (context, state) {
          print("state $state");
          if (state is ProdukLoadedState) {
            return _cardProduk(state.produks);
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

  Widget _loginContainer(Size size) {
    return AnimatedContainer(
      height: _loginHeight,
      width: size.width,
      padding: EdgeInsets.all(26),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(0, _loginYOffset, 1),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(_loginOpacity),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          )),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              "Tambah Produk",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Center(
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: AppTheme.hintTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _imageFile == null
                        ? Image.asset(Images.imagePlaceholderProduk)
                        : Image.file(File(_imageFile!.path)),
                  ),
                ),
                Positioned(
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((builder) => _bottomSheet()));
                      },
                      child: Icon(Icons.camera_alt, size: 50),
                    )),
              ],
            ),
          ),
          SizedBox(height: 16),
          _dropDownItems(_listKategori, "Silahkan Pilih Kategori"),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Nama Produk",
            icon: Icons.category,
            controller: _name,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Harga Modal",
            icon: Icons.money_off,
            controller: _modal,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Harga Produk",
            icon: Icons.money,
            controller: _harga,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                      clearField();
                    });
                  },
                  child: DangerButton(btnText: "Cancel")),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      resNama = _name.text.trim();
                      resModal = _modal.text.trim();
                      resHarga = _harga.text.trim();

                      if (resNama.isNotEmpty &&
                          resModal.isNotEmpty &&
                          resHarga.isNotEmpty) {
                        setState(() {
                          _bloc.add(ProdukStoreEvent(
                              file: _imageFile == null ? null : _imageFile!,
                              produk: Produk(
                                  id: resId == "" ? 0 : int.parse(resId),
                                  kategoriId: int.parse(resKategoriId),
                                  foto: resImage,
                                  nama: resNama,
                                  modal: resModal,
                                  harga: resHarga)));

                          _pageState = 0;
                          clearField();
                        });
                      } else {
                        EasyLoading.showError("harap mengisi semua kolom");
                      }
                    },
                    child: PrimaryButton(btnText: "Submit")),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _loadKategori() {
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
            _listKategori = state.kategoris;
            return _buildKategori(_listKategori);
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

  Widget _bottomSheet() {
    return Container(
      height: 100,
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Choose Profile Photo"),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                  onPressed: () {
                    _takePhotos(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("Camera")),
              FlatButton.icon(
                  onPressed: () {
                    _takePhotos(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Galery")),
            ],
          ),
        ],
      ),
    );
  }

  void _takePhotos(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      File? cropped = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1),
          compressQuality: 70,
          compressFormat: ImageCompressFormat.jpg);

      setState(() {
        _imageFile = cropped!;
        resFile = _imageFile!;
      });
    }
  }

  Widget _dropDownItems(List<Kategori> items, String msg) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.hintTextColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        hint: Text(msg),
        items: items.map((Kategori value) {
          return DropdownMenuItem<String>(
            value: value.id.toString(),
            child: new Text(value.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            resKategoriId = value.toString();
          });
        },
      ),
    );
  }

  Widget _listMenuTab(String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _index = index;
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
          return _listMenuTab(kategori.name, index);
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
            type: ArtSweetAlertType.danger, title: "Oops...", text: msg));
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void selectedProduk(Produk produk) {
    resId = produk.id.toString();
    resKategoriId = produk.kategoriId.toString();
    resImage = produk.foto;
    _name.text = produk.nama;
    _modal.text = produk.modal;
    _harga.text = produk.harga;
  }

  void clearField() {
    _name.text = "";
    _harga.text = "";
    _modal.text = "";
    resId = "";

    _imageFile = null;
    resFile = null;
    resKategoriId = "";
  }

  Widget _cardProduk(List<Produk> _listProduk) {
    return Container(
      height: 230,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _listProduk.length,
          itemBuilder: (context, index) {
            var produk = _listProduk[index];
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
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _pageState = 1;
                                          });

                                          selectedProduk(produk);
                                        },
                                        child: Container(
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
                                      ),
                                      SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () {
                                          _bloc.add(ProdukDeleteEvent(
                                              id: produk.id.toString()));
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  AppTheme.redBackgroundColor),
                                          child: Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.white,
                                          ),
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
