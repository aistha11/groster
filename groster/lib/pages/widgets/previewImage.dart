import 'package:flutter/material.dart';
import 'package:groster/pages/home/familyChat/chatscreens/widgets/cached_image.dart';

class PreviewImage extends StatelessWidget {
  final String imgUrl;
  PreviewImage({@required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            CachedImage(imgUrl,height: double.infinity,width: double.infinity,),
            Positioned(
              top: 40,
              left: 30,
              child: FlatButton.icon(
                label: Text("Back", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
