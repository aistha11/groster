// import 'package:flutter/material.dart';
// import 'package:groster/pages/widgets/appbar.dart';
// import 'package:groster/pages/widgets/shimmering/myShimmer.dart';

// class ShimmerHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(
//         leading: MyShimmer.userCircle(50.0),
//         title: MyShimmer.appTitle(),
//         centerTitle: false,
//         appCol: Colors.white,
//         actions: [
//           MyShimmer.shimIcon(Icons.people),
//           SizedBox(
//             width: 20.0,
//           ),
//           MyShimmer.shimIcon(Icons.more_vert),
//         ],
//       ),
//       body: Container(
//         width: double.infinity,
//         child: ListView.separated(
//           separatorBuilder: (_,i){
//             return MyShimmer.shimDivider(height: 10.0);
//           },
//           itemCount: 7,
//           itemBuilder: (_,i){
//             return MyShimmer.shimMasterTile();
//           },
//         ),
//       ),
//       // bottomNavigationBar: Container(),
//     );
//   }
// }
