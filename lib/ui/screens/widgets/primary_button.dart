import 'package:flutter/material.dart';
import 'package:kasir_mri/res/styling.dart';

class PrimaryButton extends StatefulWidget {
  final String btnText;
  const PrimaryButton({required this.btnText});

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.selectedTabBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(widget.btnText,
            style: Theme.of(context).primaryTextTheme.headline6),
      ),
    );
  }
}