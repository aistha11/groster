import 'package:groster/pages/home/masterList/stream_masterLists.dart';
import 'package:flutter/material.dart';

class MasterList extends StatelessWidget {
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
