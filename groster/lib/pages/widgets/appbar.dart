import 'package:groster/utils/universal_variables.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;
  final Color appCol;

  const CustomAppBar({
    Key key,
    @required this.title,
    this.actions,
    this.leading,
    @required this.centerTitle,
    this.appCol,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: appCol == null ? UniversalVariables.appBarColor : appCol,
        border: Border(
          bottom: BorderSide(
            color: appCol == null ? UniversalVariables.separatorColor : Colors.white,
            width: 1.4,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor:
            appCol == null ? UniversalVariables.appBarColor : appCol,
        elevation: 0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
