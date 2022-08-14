import 'dart:io';
import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:birthdayfafa/services/thumbnail.dart';
import 'package:birthdayfafa/services/videoPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';

class Videos extends StatefulWidget {
  @override
  _VideosState createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  String path = '';
  String video = '';
  String thumbnailer = '';
  bool showPreview = false;
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    List<Available> listOfAvailable = [];
    List<String> thumbnail = [];
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - safeAreaHeight;
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    final listOfVideos = map['list'] as List<ReadEvery>;
    assetsAudioPlayer = map['audio'] as AssetsAudioPlayer;
    listOfVideos.sort((a, b) => a.name
        .toString()
        .toLowerCase()
        .compareTo(b.name.toString().toLowerCase()));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: screenHeight,
              width: screenWidth,
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
                      height: 10,
                    ),
                    returnGridView(context, screenWidth, listOfVideos,
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
      context, screenWidth, listOfVideos, listOfAvailable, thumbnail) {
    return GridView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
          childAspectRatio: 10 / 4.5),
      children: List.generate(listOfVideos.length, (index) {
        listOfAvailable.add(Available(
            isPresent: false, source: listOfVideos[index].image.toString()));
        thumbnail.add('');
        return Row(
          children: [
            GestureDetector(
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
              child: TextButton(
                child: Container(
                  height: screenWidth * 0.4,
                  width: screenWidth * 0.4,
                  child: FutureBuilder<dynamic>(
                    future: returnThumbnail(
                        listOfVideos[index].image.toString(),
                        listOfAvailable,
                        index,
                        'Videos'),
                    builder: (context, AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        thumbnail[index] = snapshot.data;
                        return Stack(alignment: Alignment.center, children: [
                          Container(
                            height: screenWidth * 0.37,
                            width: screenWidth * 0.37,
                            child: Image.file(
                              File(snapshot.data),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Icon(
                            Icons.play_arrow_sharp,
                            color: Colors.white70,
                            size: screenWidth * 0.2,
                          ),
                        ]);
                      } else {
                        return SpinKitCircle(
                          color: Colors.white,
                          size: screenWidth * 0.2,
                        );
                      }
                    },
                  ),
                ),
                onPressed: () {
                  assetsAudioPlayer!.pause();
                  Navigator.pushNamed(context, '/VideoInfo', arguments: {
                    'avail': listOfAvailable[index],
                    'str': 'Videos',
                    'thumbnail': thumbnail[index],
                    'audio': assetsAudioPlayer,
                  });
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Container(
              width: screenWidth * 0.5,
              height: screenWidth * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenWidth * 0.1,
                  ),
                  Text(
                    listOfVideos[index].name.toString(),
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
                  SizedBox(
                    height: screenWidth * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(screenWidth * 0.07, 0, 0, 0),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey.shade700),
                      ),
                      child: Text(
                        'SAY THANKS!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                      onPressed: () {
                        openWhatsapp(listOfVideos[index], context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

openWhatsapp(ReadEvery read, context) async {
  var text = 'Thanks for the video wishes ${read.name.toString()}';
  // var urlAndroid = "https://wa.me/${read.number.toString()}/?text=${Uri.parse(read.message.toString())}";
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
