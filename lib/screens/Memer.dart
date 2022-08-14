import 'dart:io';

import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:birthdayfafa/services/sharefile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Memer extends StatelessWidget {
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    var map = ModalRoute.of(context)!.settings.arguments as Map;
    ReadEvery read = map['memes'] as ReadEvery;
    Available avail = map['avail'] as Available;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: screenHeight - safeAreaTop,
          width: screenWidth,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/img.jpg'),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.4, screenWidth * 0.07, 0, 0),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await downloadFile(
                            avail, dio, 'o/', '.jpg', 'Meme', 'Memes');
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Flexible(
                      child: ElevatedButton(
                        child: Icon(
                          Icons.share,
                          size: screenWidth * 0.1,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          shareFile(avail, 'Memes', dio, '.jpg', 'o/');
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenWidth * 0.05,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, screenWidth * 0.025),
                child: Text(
                  read.message.toString() + '\n\n\n\n',
                  maxLines: 3,
                  style: GoogleFonts.architectsDaughter(
                    color: Colors.white,
                    fontSize: screenWidth * 0.065,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                      )
                    ],
                    fontWeight:
                        FontWeight.lerp(FontWeight.w500, FontWeight.w600, 0.47),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(child: returnMeme(read, avail, screenWidth)),
            ],
          ),
        ),
      ),
    );
  }

  returnMeme(ReadEvery read, Available avail, screenWidth) {
    if (avail.isPresent!) {
      return Image.file(
        File(avail.source.toString()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: read.image.toString(),
        placeholder: (context, url) => SpinKitSpinningLines(
          color: Colors.white,
          size: screenWidth * 0.3,
        ),
        errorWidget: (context, url, error) => SpinKitWave(
          color: Colors.white,
          size: screenWidth * 0.3,
        ),
      );
    }
  }
}
