import 'package:flutter/material.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/ui/screens/splash/splash_body.dart';

class SplashScreen extends StatelessWidget {

  final CartDAO dao;

  const SplashScreen({Key? key, required this.dao}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SplashBody(dao: dao),
    );
  }
}
