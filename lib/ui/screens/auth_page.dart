import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kasir_mri/bloc/auth_bloc/authentication_bloc.dart';
import 'package:kasir_mri/config/shared_info.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/home_page.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/ui/screens/helper/keyboard.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class AuthPage extends StatefulWidget {
  final CartDAO dao;

  const AuthPage({Key? key, required this.dao}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _userEmail = new TextEditingController();
  final _userPass = new TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late AuthenticationBloc authenticationBloc;

  late SharedInfo _sharedInfo;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _sharedInfo = SharedInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: _authScreens(size),
    );
  }

  Widget _authScreens(Size size) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print(state);
        if (state is AuthenticationInitialState || state is AuthLoadingState) {
          EasyLoading.show(status: 'loading...');
        } else if (state is AuthGetFailureState) {
          EasyLoading.dismiss();
          EasyLoading.showError("maaf email atau password salah");
        } else if (state is AuthGetSuccess) {
          EasyLoading.dismiss();
          EasyLoading.showSuccess('welcome');
          _sharedInfo.sharedLoginInfo(state.user.id, state.user.email);
          gotoHomePage();
        }
      },
      child: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.yellow.shade50, Colors.orange.shade50]),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(Images.logoImage),
                    height: 100,
                  ),
                  Text("Selamat Datang",
                      style: Theme.of(context).textTheme.headline6),
                  Text("Login Untuk Melanjutkan Pemesanan",
                      style: Theme.of(context).textTheme.caption),
                  SizedBox(height: 16),
                  InputWithIcon(
                    inputText: "Enter Email",
                    icon: Icons.email,
                    controller: _userEmail,
                  ),
                  SizedBox(height: 8),
                  InputWithIcon(
                    inputText: "Enter Password",
                    icon: Icons.lock,
                    controller: _userPass,
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                      onTap: () {
                        // gotoHomePage();

                        var email = _userEmail.text.trim();
                        var pass = _userPass.text.trim();

                        if (email.isNotEmpty && pass.isNotEmpty) {
                          authenticationBloc
                              .add(LoginEvent(email: email, password: pass));
                        } else {
                          EasyLoading.showError("gak boleh kosong bro");
                        }
                        KeyboardUtil.hideKeyboard(context);
                      },
                      child: PrimaryButton(btnText: 'Login')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void gotoHomePage() {
    Navigator.of(context).pushReplacement(//new
        new MaterialPageRoute(
            //new
            settings: const RouteSettings(name: '/form'), //new
            builder: (context) => new HomeLandingPage(dao: widget.dao)) //new
        //new
        );
  }
}
