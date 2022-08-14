import 'dart:io';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:birthdayfafa/services/thumbnail.dart';
import 'package:birthdayfafa/services/videoPreview.dart';
import 'package:flutter/material.dart';

class Edhole extends StatefulWidget {
  @override
  _EdholeState createState() => _EdholeState();
}

class _EdholeState extends State<Edhole> {
  bool showPreview = false;
  String video = '';
  String thumbnailer = '';
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    List<Available> listOfAvailable = [];
    List<String> thumbnail = [];
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    var listOfEdhoLe = map['list'] as List<ReadEvery>;
    assetsAudioPlayer = map['audio'] as AssetsAudioPlayer;
    listOfEdhoLe = List.from(listOfEdhoLe.reversed);
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
                    returnGridView(listOfEdhoLe, screenWidth, context,
                        listOfAvailable, thumbnail),
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
                      future: videoPreview(video, thumbnailer),
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

  Widget returnGridView(
      listOfEdhoLe, screenWidth, context, listOfAvailable, thumbnail) {
    return GridView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
          childAspectRatio: 10 / 10),
      children: List.generate(listOfEdhoLe.length, (index) {
        listOfAvailable.add(Available(
            isPresent: false, source: listOfEdhoLe[index].image.toString()));
        thumbnail.add('');
        return GestureDetector(
          onLongPress: () {
            assetsAudioPlayer!.pause();
            setState(() {
              showPreview = true;
              video = Uri.encodeFull(listOfAvailable[index].source.toString());
              thumbnailer = thumbnail[index].toString();
            });
          },
          onLongPressEnd: (details) {
            assetsAudioPlayer!.play();
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
                  child: FutureBuilder<dynamic>(
                    future: returnThumbnail(
                        listOfEdhoLe[index].image.toString(),
                        listOfAvailable,
                        index,
                        'Edho le'),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        thumbnail[index] = snapshot.data;
                        return Stack(alignment: Alignment.center, children: [
                          Container(
                            height: screenWidth * 0.4,
                            width: screenWidth * 0.4,
                            child: Image.file(
                              File(snapshot.data),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: screenWidth * 0.2,
                          ),
                        ]);
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                onPressed: () {
                  assetsAudioPlayer!.pause();
                  Navigator.pushNamed(context, '/VideoInfo', arguments: {
                    'avail': listOfAvailable[index],
                    'str': 'Edho le',
                    'thumbnail': thumbnail[index],
                    'audio': assetsAudioPlayer,
                  });
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
