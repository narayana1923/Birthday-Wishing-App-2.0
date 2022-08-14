import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/getVideo.dart';
import 'package:birthdayfafa/services/sharefile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoInfo extends StatefulWidget {
  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  final Dio dio = Dio();
  AssetsAudioPlayer? assetsAudioPlayer;

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer!.play();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    final avail = map['avail'] as Available;
    String temp = map['str'] as String;
    String thumbnail = map['thumbnail'] as String;
    assetsAudioPlayer = map['audio'] as AssetsAudioPlayer;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, screenWidth * 0.01, 0, 0),
                child: FutureBuilder<dynamic>(
                  future: getVideo(avail, thumbnail),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data;
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, screenWidth * 0.05, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      print(temp + ' dngfkjfgd' + avail.source.toString());
                      downloadFile(avail, dio, 'o/', '.mp4',
                          temp == 'Videos' ? 'Video' : temp, temp);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    icon: Icon(
                      Icons.file_download,
                      color: Colors.black,
                      size: screenWidth * 0.07,
                    ),
                    label: Text('Download',
                        style: GoogleFonts.mukta(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  ElevatedButton.icon(
                    onPressed: () async {
                      shareFile(avail, temp, dio, '.mp4', 'o/');
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: screenWidth * 0.07,
                    ),
                    label: Text('Share',
                        style: GoogleFonts.mukta(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
