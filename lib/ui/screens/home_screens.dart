import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/absensi/absensi_screen.dart';
import 'package:kasir_mri/ui/screens/kategori/kategori_page.dart';
import 'package:kasir_mri/ui/screens/pegawai_page.dart';
import 'package:kasir_mri/ui/screens/pengeluaran_page.dart';
import 'package:kasir_mri/ui/screens/produk/produk_page.dart';
import 'package:kasir_mri/ui/screens/stok_page.dart';
import 'package:kasir_mri/ui/screens/transaksi/transaksi_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                        Image.asset(
                          Images.logoImage,
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      top: 220,
                      child: Container(
                        width: size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25))),
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(16)),
              child: TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search,
                        color: AppTheme.selectedTabBackgroundColor),
                    hintText: "What are u looking for",
                    fillColor: AppTheme.selectedTabBackgroundColor,
                    focusColor: AppTheme.selectedTabBackgroundColor,
                    border: InputBorder.none),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text("Ongoing Promo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              margin: EdgeInsets.all(16),
              width: size.width,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [
                  Colors.yellowAccent,
                  AppTheme.selectedTabBackgroundColor,
                ]),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(16),
                            child: Image.asset(
                              Images.logoImage,
                              width: 100,
                            )),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                              height: size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            'baru datang gaes ,\n sudahkah anda absensi ?',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ])),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => AbsensiScreen()));
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text("Oke, Let's Go"),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 16),
              child: Text("Featured Service",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              gotoAnotherPage(KategoriLandingPage());
                            },
                            child: CategoryTab(
                                icon: Icons.category, title: "Kategori")),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            gotoAnotherPage(ProdukLandingPage());
                          },
                          child: CategoryTab(
                              icon: FontAwesomeIcons.archive, title: "Produk"),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            gotoAnotherPage(PegawaiLandingPage());
                          },
                          child: CategoryTab(
                              icon: FontAwesomeIcons.users, title: "Pegawai"),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            gotoAnotherPage(StokLandingPage());
                          },
                          child: CategoryTab(
                              icon: FontAwesomeIcons.box, title: "Stok"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              gotoAnotherPage(PengeluaranLandingPage());
                            },
                            child: CategoryTab(
                                icon: FontAwesomeIcons.dropbox,
                                title: "Pengeluaran")),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                            onTap: () {
                              gotoAnotherPage(TransaksiLandingPage());
                            },
                            child: CategoryTab(
                                icon: FontAwesomeIcons.firstOrder,
                                title: "Transaksi")),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      )
                    ],
                  ),
                  SizedBox(height: 60),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gotoAnotherPage(Widget landingPage) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return landingPage;
    }));
  }
}

class CategoryTab extends StatelessWidget {
  final IconData icon;
  final String title;

  CategoryTab({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange[50]),
            child: Icon(
              icon,
              color: AppTheme.selectedTabBackgroundColor,
            ),
          ),
          SizedBox(height: 8),
          Text(title,
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        ],
      ),
    );
  }
}
