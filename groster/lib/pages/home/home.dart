import 'package:groster/enum/user_state.dart';
import 'package:groster/pages/home/familyChat/chats/chat_list_screen.dart';
import 'package:groster/pages/home/familyChat/chats/widgets/user_circle.dart';
import 'package:groster/pages/home/masterList/masterList.dart';
import 'package:groster/pages/home/personalList/personalList.dart';
import 'package:groster/pages/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  // var currentIndex = 0;

  PageController pageController;
  int _page = 0;
  UserRepository userProvider;

  final UserRepository _authMethods = UserRepository.instance();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserRepository>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.user.uid,
        userState: UserState.Online,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Widget getTitle() {
    if (_page == 0)
      return Text('Master List');
    else if (_page == 1)
      return Text('Personal List');
    else
      return Text('Chat');
  }

  final List<PopupMenuItem<String>> _popUpMenuItems = [
    PopupMenuItem(
      child: Text("Logout"),
      value: "Logout",
    )
  ];

  CustomAppBar customAppBar(BuildContext context) {
    // final UserRepository userProvider = Provider.of<UserRepository>(context);
    return CustomAppBar(
      leading: UserCircle(),
      title: getTitle(),
      centerTitle: false,
      actions: [
        // IconButton(
        //   icon: Icon(Icons.more_vert),
        //   onPressed: () {},
        // ),
        PopupMenuButton<String>(
          itemBuilder: (_) => _popUpMenuItems,
          onSelected: (String value){
            if(value == "Logout"){
              _authMethods.signOut();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      // appBar: CustomAppBar(
      //   leading: UserCircle(),
      //   title: getTitle(),
      //   centerTitle: false,
      // ),
      backgroundColor: Colors.grey[200],
      body: PageView(
        children: [
          MasterList(),
          PersonalList(),
          ChatListScreen(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.view_list,
              color: (_page == 0) ? Colors.lightBlue : Colors.grey,
            ),
            title: Text(
              'Master List',
              style: TextStyle(
                color: (_page == 0) ? Colors.lightBlue : Colors.grey,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_list,
              color: (_page == 1) ? Colors.lightBlue : Colors.grey,
            ),
            title: Text(
              'Personal List',
              style: TextStyle(
                color: (_page == 1) ? Colors.lightBlue : Colors.grey,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat,
              color: (_page == 2) ? Colors.lightBlue : Colors.grey,
            ),
            title: Text(
              'Family Chat',
              style: TextStyle(
                color: (_page == 2) ? Colors.lightBlue : Colors.grey,
              ),
            ),
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
