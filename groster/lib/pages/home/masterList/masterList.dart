import 'package:groster/pages/home/masterList/stream_masterLists.dart';
import 'package:flutter/material.dart';
import 'package:groster/utils/universal_variables.dart';

class MasterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: customMasterAppBar(context),
      body: StreamMasterList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: UniversalVariables.secondCol,
        child: Icon(Icons.add, color: UniversalVariables.backgroundCol,),
        onPressed: () {
          Navigator.pushNamed(context, "/addMasterNote");
        },
      ),
    );
  }
}
