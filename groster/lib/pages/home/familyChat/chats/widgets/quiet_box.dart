
import 'package:flutter/material.dart';
import 'package:groster/utils/universal_variables.dart';

class QuietBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String navRoute;
  const QuietBox({
    @required this.title,
    @required this.subtitle,
    @required this.buttonText,
    @required this.navRoute,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          color: UniversalVariables.separatorColor,
          padding: EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 25),
              FlatButton(
                color: UniversalVariables.lightBlueColor,
                child: Text(buttonText),
                onPressed: () => Navigator.of(context).pushNamed(navRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
