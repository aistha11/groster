import 'package:flutter/material.dart';
import 'package:groster/pages/widgets/shimmering/myShimmer.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          // child: MyShimmer.shimText("G R O S T E R",40.0),
          child: MyShimmer.shimText(". . .",50.0),
        ),
      ),
    );
  }
}