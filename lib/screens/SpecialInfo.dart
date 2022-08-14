import 'dart:io';
import 'dart:ui';

import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialInfo extends StatefulWidget {
  @override
  _SpecialInfoState createState() => _SpecialInfoState();
}

class _SpecialInfoState extends State<SpecialInfo> {
  String image = '';

  bool showPreview = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeheight = MediaQuery.of(context).padding.top;
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    var read = map['read'];
    var avail = map['avail'];
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: (screenHeight - safeheight) / 2,
                  width: screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenWidth * 0.1,
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            image = avail.source.toString();
                            showPreview = true;
                          });
                        },
                        onLongPressEnd: (details) {
                          setState(() {
                            showPreview = false;
                          });
                        },
                        child: TextButton(
                          child: Container(
                            height: screenWidth * 0.65,
                            width: screenWidth * 0.65,
                            color: Colors.white,
                            child: getImage(avail),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/SpecialImage',
                                arguments: avail);
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenWidth * 0.02,
                      ),
                      Text(
                        read.name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.07,
                          shadows: [Shadow(offset: Offset(2, 2))],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: (screenHeight - safeheight) - screenWidth * 1.3,
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.02, 0, screenWidth * 0.02, 0),
                    child: Center(
                      child: SelectableText(
                        read.message.toString(),
                        style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          color: Colors.white,
                          shadows: [Shadow(offset: Offset(2, 2))],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.5, screenWidth * 0.04, 0, 0),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                    ),
                    child: Text(
                      'SAY THANKS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                    ),
                    onPressed: () {
                      openWhatsapp(read, context);
                    },
                  ),
                ),
              ],
            ),
            if (showPreview) ...[
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              Container(
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: FutureBuilder<dynamic>(
                      future: imagePreview(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else
                          return CircularProgressIndicator();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  getImage(Available avail) {
    if (avail.isPresent!) {
      return Image.file(
        File(avail.source.toString()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: avail.source.toString(),
      );
    }
  }

  openWhatsapp(ReadEvery read, context) async {
    var dir = await getApplicationDocumentsDirectory();
    print(dir.path);
    var text =
        '"${read.message.toString()}"\n- ${read.name.toString()}\n\n\nThank you ${read.name.toString()}';
    var urlAndroid =
        "whatsapp://send?phone=${read.number.toString()}&text=${Uri.encodeFull(text)}";
    try {
      await launch(urlAndroid);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Whatsapp not installed'),
      ));
    }
  }

  imagePreview() async {
    try {
      File f = File(image);
      if (await f.exists())
        return Image.file(f);
      else
        throw Exception();
    } catch (e) {
      return CachedNetworkImage(
        imageUrl: image,
      );
    }
  }
}
