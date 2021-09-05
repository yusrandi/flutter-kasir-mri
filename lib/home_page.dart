
import 'package:flutter/material.dart';
import 'package:kasir_mri/floor/dao/cart_dao.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/home_screens.dart';
import 'package:kasir_mri/ui/screens/menu_screens.dart';
import 'package:kasir_mri/ui/screens/order_screen.dart';
import 'package:kasir_mri/ui/screens/pesanan_screens.dart';

class HomeLandingPage extends StatelessWidget {
  final CartDAO dao;

  const HomeLandingPage({Key? key, required this.dao}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: HomePage(dao: dao),
    );
  }
}

class HomePage extends StatefulWidget {
  final CartDAO dao;

  HomePage({required this.dao});

  @override
  _HomePageState createState() => _HomePageState(dao: dao);
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final CartDAO dao;
  _HomePageState({required this.dao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _index == 0
              ? HomeScreen()
              : _index == 1
                  ? MenuScreensLandingPage(dao: dao)
                  : OrderLandingPage(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(16)
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: _listMenu(Icons.home, "Home", 0)),
                    
                    Expanded(flex: 1, child: _listMenu(Icons.menu_book, "Menu", 1)),
                   
                    Expanded(flex: 1, child: _listMenu(Icons.list, "Order", 2)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listMenu(IconData icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _index = index;
        });
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: _index == index
                ? Colors.orange
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: _index == index ? Colors.white : Colors.orange,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(
                    color: _index == index ? Colors.white : Colors.orange),
              )
            ],
          ),
        ),
      ),
    );
  }
}
