import 'package:flutter/material.dart';
import 'package:share/share.dart';

class Func {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static toImplement(context, String msg) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(msg),
      ),
    );
  }

  static showError(context, String msg) {
    showDialog(
      context: context,
      child: AlertDialog(
        title: Text(msg),
      ),
    );
  }

  static share(BuildContext context, String text, String subject) {
    final RenderBox box = context.findRenderObject();
    Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
  static showKeyboard(textFieldFocus) => textFieldFocus.requestFocus();

  static hideKeyboard(textFieldFocus) => textFieldFocus.unfocus();

  static showSnackBar(context, String text){
    var snackbar = SnackBar(content: Text(text));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
