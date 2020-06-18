import 'package:groster/enum/auth_state.dart';
import 'package:groster/pages/auth/loginPage.dart';
import 'package:groster/pages/home/home.dart';
import 'package:groster/pages/widgets/shimmering/shimmerHome.dart';
import 'package:groster/pages/widgets/splash.dart';
import 'package:flutter/material.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserRepository userRepository, _) {
      switch (userRepository.status) {
        case Status.Uninitialized:
          return Splash();
        case Status.Unauthenticated:
        case Status.Authenticating:
          return Login();
        case Status.Authenticated:
          return Home();
        default:
          return ShimmerHome();
      }
    });
  }
}
