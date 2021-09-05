import 'package:flutter/material.dart';

class PesananScreen extends StatefulWidget {
  const PesananScreen({ Key? key }) : super(key: key);

  @override
  _PesananScreenState createState() => _PesananScreenState();
}

class _PesananScreenState extends State<PesananScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Pesanan'),),
    );
  }
}