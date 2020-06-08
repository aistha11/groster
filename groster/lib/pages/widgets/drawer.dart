
// // import 'package:groster/resources/auth_methods.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:groster/resources/user_repository.dart';
// import 'package:provider/provider.dart';

// class CustomDrawer extends StatelessWidget {

//   // final AuthMethods _auth = AuthMethods();
  
//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserRepository>(context);
//     return Drawer(
//       child: ListView(
//         children: [
//           UserAccountsDrawerHeader(
//             accountName: Text('User Name'),
//             accountEmail: Text('apar.firebase@gmail.com'),
//           ),
//           ListTile(
//             title: Text('Settings'),
//             onTap: () {},
//           ),
//           ListTile(
//             title: Text('Profile'),
//             onTap: () {},
//           ),
//           ListTile(
//             title: Text('Rate Us'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: Icon(FontAwesomeIcons.signOutAlt),
//             title: Text('Log Out'),
//             onTap: () {
//               user.signOut();
//             },
//           )
//         ],
//       ),
//     );
//   }
// }
