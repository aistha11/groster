import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:groster/enum/user_state.dart';
import 'package:groster/models/user.dart';
// import 'package:groster/resources/auth_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/utilities.dart';
import 'package:flutter/material.dart';

class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final UserRepository _authMethods = UserRepository.instance();

  OnlineDotIndicator({@required this.uid});

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(uid: uid),
        builder: (context, snapshot) {
          Muser _user;
          if (snapshot.hasData && snapshot.data.data != null) {
            _user = Muser.fromMap(snapshot.data.data());
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 8, top: 8),
            decoration: BoxDecoration(
              color: getColor(_user?.state),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}
