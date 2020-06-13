
import 'package:flutter/material.dart';
import 'package:groster/pages/home/familyChat/search_screen.dart';
import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/home/ourFamily/ourFamily.dart';
import 'package:groster/pages/home/personalList/addPersonalNote.dart';
import 'package:groster/pages/home/profile/profile.dart';
import 'package:groster/pages/wrapper.dart';
import 'package:groster/provider/image_upload_provider.dart';
// import 'package:groster/provider/user_provider.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        theme: ThemeData(
          // brightness: Brightness.dark,
          primaryColor: Colors.indigoAccent,
          primarySwatch: Colors.grey,
        ),
        routes: {
          "/": (_) => Wrapper(),
          "/addPersonalNote": (_) => AddPersonalNote(),
          "/addMasterNote": (_) => AddMasterNote(),
          '/search_screen': (context) => SearchScreen(),
          "/profile": (_) => Profile(),
          "/ourFamily": (_) => OurFamily(),
        },
      ),
    );
  }
}


