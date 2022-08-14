import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/getPath.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Memes extends StatefulWidget {
  @override
  _MemesState createState() => _MemesState();
}

class _MemesState extends State<Memes> {
  bool showPreview = false;
  String image = '';
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    List<Available> listOfAvailable = [];
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    final listOfMemes = map['list'] as List<ReadEvery>;
    listOfMemes.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - safeAreaHeight;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                      height: screenHeight * 0.02,
                    ),
                    returnGridView(
                        listOfMemes, screenWidth, context, listOfAvailable),
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
                        if (snapshot.hasData)
                          return snapshot.data;
                        else
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

  Widget returnGridView(listOfMemes, screenWidth, context, listOfAvailable) {
    return GridView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
          childAspectRatio: 10 / 10),
      children: List.generate(listOfMemes.length, (index) {
        listOfAvailable.add(Available(
            isPresent: false, source: listOfMemes[index].image.toString()));
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
          child: Column(
            children: [
              TextButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size.square(screenWidth * 0.49)),
                ),
                child: Container(
                  height: screenWidth * 0.4,
                  width: screenWidth * 0.4,
                  child: FutureBuilder<dynamic>(
                    future: getMeme(listOfMemes[index].image.toString(),
                        listOfAvailable, index),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data;
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/Memer', arguments: {
                    'memes': listOfMemes[index],
                    'avail': listOfAvailable[index],
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  memeExists(String url) async {
    try {
      var directory = (await getExternalStorageDirectory());
      Directory path = Directory(await getPath(directory, 'Memes'));
      if (!await path.exists()) {
        return null;
      } else {
        var fileName =
            url.substring(url.indexOf('o/') + 2, url.indexOf('.jpg')) + '.jpg';
        File saveFile = File(path.path + '/$fileName');
        print(saveFile.path);
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

  getMeme(String url, List<Available> listOfAvailable, int index) async {
    var image = await memeExists(url);
    print('trieddd $image');
    if (image != null) {
      listOfAvailable[index].isPresent = true;
      listOfAvailable[index].source = image.path;
      return Image.file(
        image,
        fit: BoxFit.cover,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => Icon(Icons.error),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(
          value: downloadProgress.progress,
        ),
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
