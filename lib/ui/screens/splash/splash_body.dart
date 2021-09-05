import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/auth_bloc/authentication_bloc.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/home_page.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/ui/screens/auth_page.dart';

class SplashBody extends StatefulWidget {
  final CartDAO dao;

  const SplashBody({Key? key, required this.dao}) : super(key: key);

  @override
  _SplashBodyState createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody> {
  late AuthenticationBloc authenticationBloc;

  @override
  void initState() {
    super.initState();
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    authenticationBloc.add(CheckLoginEvent());
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, state) {
        print(state);
        if (state is AuthLoggedInState)
          gotoAnotherPage(HomeLandingPage(dao: widget.dao));
        else if (state is AuthLoggedOutState)
          gotoAnotherPage(AuthPage(dao: widget.dao));
      },
      child: Center(
        child: Image.asset(Images.logoImage, height: 200),
      ),
    );
  }

  void gotoAnotherPage(Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }
}
