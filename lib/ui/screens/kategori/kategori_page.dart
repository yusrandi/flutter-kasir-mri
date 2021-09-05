import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_bloc.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_event.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_state.dart';
import 'package:kasir_mri/models/kategori_model.dart';
import 'package:kasir_mri/repo/kategori_repository.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/widgets/danger_button.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class KategoriLandingPage extends StatelessWidget {
  const KategoriLandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KategoriBloc(KategoriRepositoryImpl()),
      child: KategoriPage(),
    );
  }
}

class KategoriPage extends StatefulWidget {
  @override
  _KategoriPageState createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final _kategori = new TextEditingController();

  late KategoriBloc _bloc;

  double _loginYOffset = 0.0;
  double _loginHeight = 0;
  double _loginOpacity = 0;
  double _homeOpacity = 1;

  bool keyboardVisibility = false;

  int _pageState = 0;

  String _resId = "", _resName = "";

  final _name = new TextEditingController();

  @override
  void initState() {
    print("init");

    super.initState();
    _bloc = BlocProvider.of<KategoriBloc>(context);
    // _bloc.add(KategoriStoreEvent(name: "Percobaan"));
    _bloc.add(FetchKategoriEvent());

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _loginHeight = size.height - (size.height / 2);

    switch (_pageState) {
      case 0:
        print("_KategoriPageState $keyboardVisibility");
        _loginYOffset = size.height;
        _loginHeight =
            keyboardVisibility ? size.height : size.height - (size.height / 2);
        _loginOpacity = 1;
        break;
      case 1:
        print("_KategoriPageState $keyboardVisibility");
        _loginYOffset = keyboardVisibility ? 30 : (size.height / 2);
        _loginHeight =
            keyboardVisibility ? size.height : size.height - (size.height / 2);

        _loginOpacity = 1;

        break;
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Kategori"),
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
    return BlocListener<KategoriBloc, KategoriState>(
      listener: (context, state) {
        if (state is KategoriErrorState) {
          EasyLoading.showError(state.msg);
        } else if (state is KategoriSuccessState) {
          EasyLoading.showSuccess("success!");
          _resId = "";
          _resName = "";
          _bloc.add(FetchKategoriEvent());
        }
      },
      child: BlocBuilder<KategoriBloc, KategoriState>(
        builder: (context, state) {
          print("state $state");
          if (state is KategoriLoadedState) {
            return _buildKategori(state.kategoris);
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

  Widget _buildKategori(List<Kategori> kategoris) {
    return ListView.builder(
        itemCount: kategoris.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: AppTheme.hintTextColor, width: 1),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kategoris[index].name,
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 1;
                          _name.text = kategoris[index].name;
                          _resName = kategoris[index].name;
                          _resId = kategoris[index].id.toString();
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.selectedTabBackgroundColor),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        _bloc.add(KategoriDeleteEvent(
                            id: kategoris[index].id,
                            name: kategoris[index].name));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.redBackgroundColor),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Tambah Kategori",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              InputWithIcon(
                inputText:
                    _resName == "" ? "Silahkan Masukkan Kategori" : _resName,
                icon: Icons.category,
                controller: _name,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          _pageState = 0;
                          _resId = "";
                          _resName = "";
                        });
                      },
                      child: DangerButton(btnText: "Cancel")),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                        onTap: () {
                          String name = _name.text.trim();
                          if (name.isNotEmpty) {
                            setState(() {
                              _resId == ""
                                  ? _bloc.add(KategoriStoreEvent(name: name))
                                  : _bloc.add(KategoriUpdateEvent(
                                      id: int.parse(_resId), name: name));
                              _pageState = 0;
                              _resId = "";
                              _resName = "";
                              _name.text = "";
                            });
                          } else {
                            EasyLoading.showError("Harap Mengisi Kolom");
                          }
                        },
                        child: PrimaryButton(btnText: "Submit")),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
