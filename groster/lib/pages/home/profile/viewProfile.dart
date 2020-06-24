import 'package:flutter/material.dart';
import 'package:groster/constants/icons.dart';
import 'package:groster/pages/home/ourFamily/ourFamily.dart';
import 'package:groster/pages/home/profile/profile.dart';
import 'package:groster/pages/widgets/appbar.dart';

class ViewProfile extends StatefulWidget {
  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  PageController pageController;
  int _page;

  @override
  void initState() {
    pageController = PageController();
    _page = 0;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    setState(() {
      pageController.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[Profile(), OurFamily()];
    return Scaffold(
      appBar: CustomAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: "PROFILE",
                icon: Icon(
                  PROFILE_ICON,
                  color: (_page == 0) ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  navigationTapped(0);
                }),
            Icon(Icons.swap_horiz, color: Colors.black,),
            IconButton(
              tooltip: "GROUP",
                icon: Icon(
                  FAMILY_ICON,
                  color:(_page == 1) ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  navigationTapped(1);
                }),
          ],
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        children: _kTabPages,
        // physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
    );
  }
}
