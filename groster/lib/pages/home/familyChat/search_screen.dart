import 'package:groster/models/user.dart';
import 'package:groster/pages/home/familyChat/chatscreens/chat_screen.dart';
import 'package:groster/pages/widgets/custom_tile.dart';
// import 'package:groster/resources/auth_methods.dart';
import 'package:groster/resources/user_repository.dart';
import 'package:groster/utils/universal_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final UserRepository _userRepository = UserRepository.instance();

  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _userRepository.getCurrentUser().then((FirebaseUser user) {
      _userRepository.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: UniversalVariables.mainCol,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text('Search'),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 15),
        child: Container(
          padding:
              EdgeInsets.only(left: 20, top: 10.0, right: 20.0, bottom: 10.0),
          color: Colors.grey[300],
          child: TextField(
            controller: searchController,
            onSubmitted: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.blackColor,
            autofocus: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 19,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: UniversalVariables.iconCol,
                size: 30,
              ),
              contentPadding: EdgeInsets.all(5),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: UniversalVariables.iconCol),
                onPressed: () {
                  setState(() {
                    WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                      query = "";
                  });
                },
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              hintText: "enter email address",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: Colors.black38,
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggestions(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList != null
            ? userList.where((User user) {
                //Search By UserName or Name 
                // String _getUsername = user.username.toLowerCase();
                // String _getName = user.name.toLowerCase();
                // bool matchesUsername = _getUsername.contains(_query);
                // bool matchesName = _getName.contains(_query);
                String _getEmail = user.email.toLowerCase();
                String _query = query.toLowerCase();
                bool matchesEmail = _getEmail == _query ? true : false;
                // return (matchesUsername || matchesName);
                return (matchesEmail);
              }).toList()
            : [];

    if (suggestionList.isEmpty) {
      if (query.isNotEmpty) {
        return Container(
          child: Center(
            child: Text("Sorry! Searched User Not Found"),
          ),
        );
      } else {
        return Container(
          child: Center(
            child: Text("Search User"),
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          receiver: searchedUser,
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: UniversalVariables.titCol,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.lastMsgCol),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.backgroundCol,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestions(query),
      ),
    );
  }
}
