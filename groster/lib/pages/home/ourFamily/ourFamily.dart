// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groster/constants/strings.dart';
import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/quiet_box.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';
import 'package:groster/pages/home/ourFamily/famMembers.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/func.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OurFamily extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    userRepository.refreshUser();
    final User user = userRepository.getUser;

    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: CustomAppBar(
        leading: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        appCol: UniversalVariables.blackColor,
        title: Text("Family Profile"),
      ),
      body: user.familyId == null
          ? Container(
              child: QuietBox(
                  title: "Set Up Your Family Profile",
                  subtitle: "After this you can add the family list",
                  buttonText: "SetUp Now",
                  navRoute: "/setUpFamily"),
            )
          : Container(
              margin: EdgeInsets.only(top: 5),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Container(
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushReplacementNamed("/familyGroupChat");
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              // color: Colors.green,
                              child: Stack(
                                overflow: Overflow.clip,
                                alignment: Alignment.topRight,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: CachedImage(
                                        BLANK_IMAGE,
                                        isRound: true,
                                        radius: 45.0,
                                      )),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: CachedImage(
                                        userRepository.getUser.profilePhoto,
                                        isRound: true,
                                        radius: 45.0,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Family Group",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  FamilyMembers(),
                  Divider(
                    height: 10,
                    color: UniversalVariables.separatorColor,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        ListTile(
                          leading: Text(
                            "Id : ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                          title: Row(
                            children: [
                              Text(
                                user.familyId,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.content_copy,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    final data =
                                        ClipboardData(text: user.familyId);
                                    Clipboard.setData(data);
                                    Fluttertoast.showToast(
                                        msg: "Id copied to clipboard",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1);
                                  }),
                            ],
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                        ),
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.white),
                          title: Text(
                            "Edit",
                            style: TextStyle(color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                          onTap: () {
                            TextEditingController _familyId =
                                TextEditingController();
                            showDialog(
                              context: context,
                              child: Container(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val.isEmpty)
                                      return "*This can't be empty.";
                                    return null;
                                  },
                                  controller: _familyId,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.person),
                                    labelText: "Family Id",
                                    hintText: 'Family Id',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            // Navigator.of(context).pushNamed("/setUpFamily");
                          },
                        ),

                        ListTile(
                          leading: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          title: Text(
                            "Share",
                            style: TextStyle(color: Colors.white),
                          ),
                          contentPadding: EdgeInsets.only(left: 70.0),
                          onTap: () {
                            Func.share(
                              context,
                              "Our Family Id is ${user.familyId}",
                              "Join Family",
                            );
                          },
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 55.0),
                        //   child: ExpansionTile(
                        //     // backgroundColor: Colors.white,
                        //     leading: Icon(
                        //       FontAwesomeIcons.peopleArrows,
                        //       color: Colors.white,
                        //     ),
                        //     title: Text(
                        //       "Members",
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //     initiallyExpanded: false,
                        //     childrenPadding: EdgeInsets.only(left: 60),
                        //     children: [
                        //       Container(
                        //         child: Column(children: [
                        //           ListTile(
                        //             title: Text("Hello"),
                        //           ),
                        //         ],),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
