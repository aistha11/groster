
import 'package:flutter/material.dart';
import 'package:groster/pages/home/familyChat/search_screen.dart';
import 'package:groster/pages/home/familyGroupChat/familyGroupChat.dart';
import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/home/ourFamily/familySetUp.dart';
import 'package:groster/pages/home/personalList/addPersonalNote.dart';
import 'package:groster/pages/wrapper.dart';
import 'package:groster/provider/image_upload_provider.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (_) => Wrapper(),
          "/addPersonalNote": (_) => AddPersonalNote(),
          "/addMasterNote": (_) => AddMasterNote(),
          '/search_screen': (context) => SearchScreen(),
          "/setUpFamily":(_) => FamilySetUp(),
          "/familyGroupChat" : (_) => FamilyGroupChat(),
        },
      ),
    );
  }
}


