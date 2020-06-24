import 'package:groster/constants/styles.dart';
import 'package:groster/pages/home/masterList/stream_masterLists.dart';
import 'package:flutter/material.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/utils/universal_variables.dart';

class MasterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // leading: Icon(MASTER_ICON, color: Colors.black),
        title: Text(
          "Master List",
          style: APP_TITLE_STYLE,
        ),
        centerTitle: true,
      ),
      body: StreamMasterList(),
      floatingActionButton: FloatingActionButton(
        tooltip: "ADD TO MASTER LIST",
        backgroundColor: UniversalVariables.secondCol,
        child: Icon(
          Icons.add,
          color: UniversalVariables.backgroundCol,
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/addMasterNote");
        },
      ),
    );
  }
}
