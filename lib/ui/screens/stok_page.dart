import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/bloc/stok_bloc/stok_bloc.dart';
import 'package:kasir_mri/bloc/stok_bloc/stok_event.dart';
import 'package:kasir_mri/bloc/stok_bloc/stok_state.dart';
import 'package:kasir_mri/models/stok_model.dart';
import 'package:kasir_mri/repo/stok_repository.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/widgets/danger_button.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class StokLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StokBloc(StokRepositoryImpl()),
      child: StokPage(),
    );
  }
}

class StokPage extends StatefulWidget {
  @override
  _StokPageState createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  late StokBloc _bloc;

  final _name = new TextEditingController();
  final _satuan = new TextEditingController();
  final _jumlah = new TextEditingController();
  final _harga = new TextEditingController();
  final _kontak = new TextEditingController();
  final _alamat = new TextEditingController();

  double _loginYOffset = 0.0;
  double _loginHeight = 0;
  double _loginOpacity = 0;
  double _homeOpacity = 1;

  bool keyboardVisibility = false;

  int _pageState = 0;

  String resId = "";

  @override
  void initState() {
    _bloc = BlocProvider.of<StokBloc>(context);
    _bloc.add(FetchStokEvent());

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      keyboardVisibility = visible;
    });

    super.initState();
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
        _loginYOffset = keyboardVisibility ? 50 : 50;
        _loginHeight = keyboardVisibility ? size.height : size.height;
        _loginOpacity = 1;
        _homeOpacity = 0;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Stok"),
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
    );
  }

  Widget _pageBody(Size size) {
    return Container(
        padding: EdgeInsets.all(8),
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Container(
              height: size.height,
              color: Colors.white.withOpacity(_homeOpacity),
              child: _loadStok(size)),
          _formInput(size),
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
              )),
        ]));
  }

  Widget _loadStok(Size size) {
    return BlocListener<StokBloc, StokState>(
      listener: (context, state) {
        if (state is StokErrorState) {
          EasyLoading.showError(state.msg);
          _bloc.add(FetchStokEvent());
        } else if (state is StokSuccessState) {
          EasyLoading.showSuccess(state.msg);
          _bloc.add(FetchStokEvent());
        }
      },
      child: BlocBuilder<StokBloc, StokState>(
        builder: (context, state) {
          print("state $state");

          if (state is StokInitialState || state is StokLoadingState) {
            return _buildLoading();
          } else if (state is StokLoadedState) {
            return Container(
                height: size.height,
                width: size.width,
                child: _buildStok(state.stoks));
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _buildStok(List<Stok> stoks) {
    return ListView.builder(
        itemCount: stoks.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var stok = stoks[index];
          return Container(
            height: 160,
            margin: EdgeInsets.only(bottom: 8),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.orange[50]
                            : Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  stok.nama,
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: "Nunito"),
                                ),
                              ),
                              Text(stok.kontak,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: "Nunito")),
                              Text(stok.alamat,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: "Nunito")),
                            ],
                          ),
                          Column(children: [
                            Center(
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "${stok.jumlah} ${stok.satuan}\n",
                                        style: TextStyle(
                                            fontSize: 34,
                                            fontFamily: "Nunito",
                                            color: index % 2 == 0
                                                ? Colors.orange
                                                : Colors.lightBlue)),
                                    TextSpan(
                                        text: "Rp. " +
                                            NumberFormat("#,##0", "en_US")
                                                .format(int.parse(stok.harga)),
                                        style: TextStyle(color: Colors.black)),
                                  ])),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pageState = 1;
                                    });

                                    resId = stok.id.toString();
                                    _satuan.text = stok.satuan;
                                    _name.text = stok.nama;
                                    _harga.text = stok.harga;
                                    _jumlah.text = stok.jumlah;
                                    _kontak.text = stok.kontak;
                                    _alamat.text = stok.alamat;
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                    _alertConfirm(stok.id.toString());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppTheme.redBackgroundColor),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _formInput(Size size) {
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
              "Tambah Stok",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          InputWithIcon(
            inputText: "Kg / Buah / Liter",
            icon: FontAwesomeIcons.atom,
            controller: _satuan,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Nama",
            icon: FontAwesomeIcons.apple,
            controller: _name,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Jumlah",
            icon: FontAwesomeIcons.moneyBill,
            controller: _jumlah,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Harga",
            icon: FontAwesomeIcons.moneyBill,
            controller: _harga,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Kontak",
            icon: FontAwesomeIcons.phone,
            controller: _kontak,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Alamat",
            icon: FontAwesomeIcons.addressBook,
            controller: _alamat,
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
                      var satuan = _satuan.text.trim();
                      var nama = _name.text.trim();
                      var harga = _harga.text.trim();
                      var jumlah = _jumlah.text.trim();
                      var kontak = _kontak.text.trim();
                      var alamat = _alamat.text.trim();
                      if (satuan.isNotEmpty &&
                          nama.isNotEmpty &&
                          harga.isNotEmpty &&
                          jumlah.isNotEmpty &&
                          kontak.isNotEmpty &&
                          alamat.isNotEmpty) {
                        var stok = Stok(
                            id: resId == "" ? 0 : int.parse(resId),
                            satuan: satuan,
                            nama: nama,
                            jumlah: jumlah,
                            harga: harga,
                            kontak: kontak,
                            alamat: alamat);

                        resId == ""
                            ? _bloc.add(StokStoreEvent(stok: stok))
                            : _bloc.add(StokUpdateEvent(id: resId, stok: stok));
                        clearField();
                        setState(() {
                          _pageState = 0;
                        });
                      } else {
                        EasyLoading.showError("harap mengisi semua kolom");
                      }
                    },
                    child: PrimaryButton(btnText: "Submit")),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void clearField() {
    resId = "";
    _satuan.text = "";
    _name.text = "";
    _jumlah.text = "";
    _kontak.text = "";
    _alamat.text = "";
    keyboardVisibility = false;
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
            type: ArtSweetAlertType.danger, title: "Oops...", text: msg));
  }

  void _alertConfirm(String id) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: "Are you sure?",
            text: "You won't be able to revert this!",
            confirmButtonText: "Yes",
            type: ArtSweetAlertType.warning));

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      _bloc.add(StokDeleteEvent(id: id));
      return;
    }
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
