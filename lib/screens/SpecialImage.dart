import 'dart:io';

import 'package:birthdayfafa/services/available.dart';
import 'package:birthdayfafa/services/sharefile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecialImage extends StatefulWidget {
  @override
  _SpecialImageState createState() => _SpecialImageState();
}

class _SpecialImageState extends State<SpecialImage> {
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    var read = ModalRoute.of(context)!.settings.arguments as Available;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: getImage(read, screenWidth),
            ),
            SizedBox(
              height: screenWidth * 0.03,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      downloadFile(
                          read, dio, 'images%2F', '.jp', 'Image', 'Special');
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
                      shareFile(read, 'Special', dio, '.jp', 'images%2F');
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

  getImage(Available read, screenWidth) {
    if (read.isPresent!) {
      print(read.source.toString());
      return Image.file(
        File(read.source.toString()),
      );
    } else {
      return CachedNetworkImage(
        imageUrl: read.source.toString(),
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
