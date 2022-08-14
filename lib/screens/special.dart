import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/getPath.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Special extends StatefulWidget {
  @override
  _SpecialState createState() => _SpecialState();
}

class _SpecialState extends State<Special> {
  String image = '';
  bool showPreview = false;
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    List<Available> listOfAvailable = [];
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    final listOfSpecial = map['list'] as List<ReadEvery>;
    listOfSpecial.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));
    final screenWidth = MediaQuery.of(context).size.width;
    final safeHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - safeHeight;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/images/img.jpg'),
                fit: BoxFit.cover,
              )),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenWidth * 0.043,
                    ),
                    returnGridView(
                        listOfSpecial, screenWidth, context, listOfAvailable),
                  ],
                ),
              ),
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

  Widget returnGridView(listOfSpecial, screenWidth, context, listOfAvailable) {
    return GridView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 1,
          childAspectRatio: 10 / 12),
      children: List.generate(listOfSpecial.length, (index) {
        listOfAvailable.add(Available(
            isPresent: false, source: listOfSpecial[index].image.toString()));
        return GestureDetector(
          onLongPress: () {
            setState(() {
              showPreview = true;
              image = listOfAvailable[index].source.toString();
            });
          },
          onLongPressEnd: (details) {
            setState(() {
              showPreview = false;
            });
          },
          child: Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Container(
                    height: screenWidth * 0.4,
                    width: screenWidth * 0.4,
                    child: FutureBuilder<dynamic>(
                      future: getImage(listOfSpecial[index].image.toString(),
                          listOfAvailable, index),
                      builder: (context, AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                  onPressed: () {
                    Available temp = listOfAvailable[index];
                    ReadEvery temp2 = listOfSpecial[index];
                    print(temp);
                    if (temp2.message.toString().isEmpty) {
                      Navigator.pushNamed(context, '/SpecialImage',
                          arguments: temp);
                    } else {
                      Navigator.pushNamed(context, '/SpecialInfo',
                          arguments: {'read': temp2, 'avail': temp});
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, screenWidth * 0.01, screenWidth * 0.1, 0),
                  child: Text(
                    listOfSpecial[index].name.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.07,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  imageExits(String url) async {
    try {
      var directory = (await getExternalStorageDirectory());

      directory = Directory(await getPath(directory, 'Special'));
      if (!await directory.exists()) {
        return null;
      } else {
        var fileName =
            url.substring(url.indexOf('images%2F') + 9, url.indexOf('.jp')) +
                '.jpg';
        File saveFile = File(directory.path + '/$fileName');
        if (await saveFile.exists()) {
          return saveFile;
        } else {
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  getImage(String url, List<Available> listOfAvailable, int index) async {
    var image = await imageExits(url);
    if (image != null) {
      listOfAvailable[index].isPresent = true;
      listOfAvailable[index].source = image.path;
      return Image.file(
        image,
        fit: BoxFit.fitWidth,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        memCacheHeight: 250,
        memCacheWidth: 250,
      );
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
