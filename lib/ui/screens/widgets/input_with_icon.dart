import 'package:flutter/material.dart';
import 'package:kasir_mri/res/styling.dart';

class InputWithIcon extends StatefulWidget {
  final String inputText;
  final IconData icon;
  final TextEditingController controller;

  const InputWithIcon(
      {key,
        required this.inputText,
        required this.icon,
        required this.controller})
      : super(key: key);

  @override
  _InputWithIconState createState() => _InputWithIconState();
}

class _InputWithIconState extends State<InputWithIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.hintTextColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            child: Icon(
              widget.icon,
              size: 20,
              color: AppTheme.hintTextColor,
            ),
          ),
          Expanded(
              child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                    hintText: widget.inputText),
              ))
        ],
      ),
    );
  }
}