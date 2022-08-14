import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/dialog.dart';
import 'package:birthdayfafa/services/getPath.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Written {
  String? name;
  String? imagePath;
  String? startName;
  String? extension;
  Written({this.name, this.imagePath, this.startName, this.extension});
}

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  List<Written> listOfServices = [];
  AssetsAudioPlayer? assetsAudioPlayer;
  dynamic mp = {};

  void intializeList() {
    listOfServices.add(Written(
        name: "Special",
        imagePath: 'assets/images/special.png',
        startName: 'images%2F',
        extension: '.jp'));
    listOfServices.add(Written(
        name: "Videos",
        imagePath: 'assets/images/video.webp',
        startName: 'o/',
        extension: '.mp4'));
    listOfServices.add(Written(
        name: "Memes",
        imagePath: 'assets/images/memes.png',
        startName: 'o/',
        extension: '.jpg'));
    listOfServices.add(Written(
        name: "Edho le",
        imagePath: 'assets/images/edho.png',
        startName: 'o/',
        extension: '.mp4'));
  }

  @override
  void initState() {
    super.initState();
    intializeList();
  }

  @override
  Widget build(BuildContext context) {
    var temp = (ModalRoute.of(context)!.settings.arguments) as Map;
    mp = temp['map'];
    assetsAudioPlayer = temp['audio'];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/img.jpg'),
            fit: BoxFit.cover,
          )),
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenWidth * 0.55,
                    ),
                    Flexible(
                      child: returnGridView(
                          listOfServices, screenWidth, context, mp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget returnGridView(listOfServices, screenWidth, context, mp) {
    return GridView(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      children: List.generate(listOfServices.length, (index) {
        return Card(
          shadowColor: Colors.transparent,
          color: Colors.transparent,
          child: TextButton(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  child: Image.asset(
                    listOfServices[index].imagePath.toString(),
                    fit: BoxFit.fill,
                  ),
                  aspectRatio: 1.6 / 1,
                ),
                SizedBox(
                  height: screenWidth * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0, 0, 0),
                  child: Text(
                    listOfServices[index].name.toString(),
                    style: TextStyle(
                      fontSize: screenWidth * 0.075,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(3, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              var temp = listOfServices[index].name.toString();
              Navigator.pushNamed(context, '/' + temp,
                  arguments: {'list': mp[temp], 'audio': assetsAudioPlayer});
            },
            onLongPress: () {
              var temp = listOfServices[index];
              showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(
                        temp.name,
                        style: GoogleFonts.aladin(
                          color: Colors.white,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to',
                        style: GoogleFonts.aladin(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.black,
                      actions: [
                        TextButton.icon(
                          icon: Icon(Icons.file_download),
                          label: Text('Download All'),
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            showShareDialog(
                                context, screenWidth, 'Downloading');
                            await downloadFile(mp[temp.name], temp, context);
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.share),
                          label: Text('Share All'),
                          onPressed: () async {
                            Navigator.of(dialogContext).pop();
                            showShareDialog(context, screenWidth, 'Sharing');
                            await shareFile(mp[temp.name], temp);
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.cancel),
                          label: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      }),
    );
  }

  shareFile(List<ReadEvery> mp, Written temp) async {
    try {
      Fluttertoast.showToast(
          msg: 'Please Wait for a while...', toastLength: Toast.LENGTH_LONG);
      Dio dio = Dio();
      bool flag = false;
      String path = await getPath(
          await (getExternalStorageDirectory()), temp.name.toString());
      Directory directory = Directory(path);
      var url = '';
      var startName = temp.startName.toString();
      var extension = temp.extension.toString();
      var backExtension = (extension == '.jp') ? '.jpg' : extension;
      var fileName = ' ';
      if (!await directory.exists()) {
        await directory.create(recursive: true);
        flag = true;
      }
      List<String> files = [];
      List<bool> isAvailable = List.generate(mp.length, (index) => true);

      for (int i = 0; i < mp.length; i++) {
        url = mp[i].image.toString();
        fileName = url.substring(url.indexOf(startName) + startName.length,
                url.indexOf(extension)) +
            backExtension;
        files.add(path + '/$fileName');
        if (flag || !await File(files[i]).exists()) {
          await dio.download(url, files[i]);
          isAvailable[i] = false;
        }
      }
      await Share.shareFiles(files);
      for (int i = 0; i < mp.length; i++) {
        if (!isAvailable[i]) File(files[i]).delete();
      }
    } catch (e) {
      print(e);
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Failed To Share', toastLength: Toast.LENGTH_LONG);
    }
  }

  downloadFile(List<ReadEvery> urls, Written temp, BuildContext context) async {
    Dio dio = Dio();
    Directory directory;
    try {
      directory = (await getExternalStorageDirectory())!;

      directory = Directory(await getPath(directory, temp.name.toString()));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      var fileName = '';
      var url = '';
      var startName = temp.startName.toString();
      var extension = temp.extension.toString();
      var backExtension = (extension == '.jp') ? '.jpg' : extension;

      Fluttertoast.showToast(
        msg: 'Download started',
        toastLength: Toast.LENGTH_SHORT,
      );
      for (int i = 0; i < urls.length; i++) {
        url = urls[i].image.toString();
        fileName = url.substring(url.indexOf(startName) + startName.length,
                url.indexOf(extension)) +
            backExtension;
        File saveFile = File(directory.path + '/$fileName');
        if (!await saveFile.exists()) {
          await dio.download(url, saveFile.path);
        }
      }
      MediaScanner.loadMedia(path: directory.path);
      Fluttertoast.showToast(
        msg: 'All ${temp.name} Downloaded!!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed To Download ${temp.name}',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }
}
