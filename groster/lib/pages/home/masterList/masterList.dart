// import 'package:groster/models/note.dart';
// import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
// import 'package:groster/pages/home/familyChat/chats/widgets/user_circle.dart';
// import 'package:groster/pages/home/masterList/addMasterNote.dart';
import 'package:groster/pages/home/masterList/stream_masterLists.dart';
// import 'package:groster/pages/widgets/appbar.dart';
// import 'package:groster/pages/widgets/notesItem.dart';
// import 'package:groster/provider/user_provider.dart';
// import 'package:groster/services/db_service.dart';
// import 'package:groster/utils/func.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class MasterList extends StatelessWidget {
  // CustomAppBar customMasterAppBar(BuildContext context) {
  //   // final UserProvider userProvider = Provider.of<UserProvider>(context);
  //   return CustomAppBar(
  //     leading: UserCircle(),
  //     title: Text('Master List'),
  //     centerTitle: false,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // appBar: customMasterAppBar(context),
      body: StreamMasterList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, "/addMasterNote");
        },
      ),
    );
  }

  
}
