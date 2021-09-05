import 'package:flutter/material.dart';
import 'package:kasir_mri/res/styling.dart';

class DangerButton extends StatefulWidget {
  final String btnText;
  const DangerButton({required this.btnText});

  @override
  _DangerButtonState createState() => _DangerButtonState();
}

class _DangerButtonState extends State<DangerButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(widget.btnText,
            style: Theme.of(context).primaryTextTheme.headline6),
      ),
    );
  }
}