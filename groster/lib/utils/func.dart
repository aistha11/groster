import 'package:flutter/material.dart';

class Func {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static toImplement(context,String msg) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(msg),
      ),
    );
  }
}
