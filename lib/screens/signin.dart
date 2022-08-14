import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:birthdayfafa/services/checkpermission.dart';
import 'package:birthdayfafa/services/read_every.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:birthdayfafa/constants.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with WidgetsBindingObserver {
  var videoCount, memeCount, edhoLeCount, imageCount;
  var imageDatabase, videoDatabase, memeDatabase, edhoLeDatabase;
  final assetsAudioPlayer = AssetsAudioPlayer();
  bool showPreview = false;
  String path = '';
  String username = '', password = '';
  String realUsername = 'username', realPassword = 'password';
  bool isSilent = false;
  Map<String, List<ReadEvery>> mp = {
    'Special': [],
    'Videos': [],
    'Memes': [],
    'Edho le': [],
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        assetsAudioPlayer.pause();
        break;
      case AppLifecycleState.paused:
        assetsAudioPlayer.pause();
        break;
      case AppLifecycleState.detached:
        assetsAudioPlayer.pause();
        break;
      default:
        break;
    }
  }

  Future<bool> loadingJson() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/files/birthdayfafa-export.json");
    final jsonResult = jsonDecode(data);
    var countData = jsonResult['count'] as Map;
    videoCount = countData['Videos'] as int;
    imageCount = countData['Images'] as int;
    edhoLeCount = countData['Edho le'] as int;
    memeCount = countData['Memes'] as int;
    var resourceData = jsonResult['Data'] as Map;
    edhoLeDatabase = resourceData['Edho le'] as List;
    videoDatabase = resourceData['Videos'] as List;
    memeDatabase = resourceData['Memes'] as List;
    imageDatabase = resourceData['Images'] as List;
    return true;
  }

  void loadPasswordFile() async {
    if (!await File(path + '/user/userdetails.txt').exists()) {
      File tempFile =
          await File(path + '/user/userdetails.txt').create(recursive: true);
      await tempFile.writeAsString(
          await rootBundle.loadString('assets/files/userdetails.txt'));
    }
    await getUsernameAndPassword();
  }

  void checkMusic() async {
    path = (await getExternalStorageDirectory())!.path;
    loadPasswordFile();
    if (await File(path + '/audio/birthday_song.mp3').exists()) {
      assetsAudioPlayer.open(
        Audio.file(path + '/audio/birthday_song.mp3'),
        respectSilentMode: true,
        playInBackground: PlayInBackground.disabledRestoreOnForeground,
        loopMode: LoopMode.single,
      );
    } else {
      await Directory('$path/audio').create(recursive: true);
      var musicFile = await rootBundle.load('assets/audio/birthday_song.mp3');
      File temp = await File('$path/audio/birthday_song.mp3').writeAsBytes(
          musicFile.buffer
              .asUint8List(musicFile.offsetInBytes, musicFile.lengthInBytes));
      print('working-------------------------------------------------------');
      assetsAudioPlayer.open(
        Audio.file(temp.path),
        respectSilentMode: true,
        playInBackground: PlayInBackground.disabledRestoreOnForeground,
        loopMode: LoopMode.single,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    checkMusic();
    WidgetsBinding.instance!.addObserver(this);
    activateListeners();
  }

  @override
  void dispose() {
    super.dispose();
    assetsAudioPlayer.pause();
  }

  void activateListeners() async {
    await loadingJson();
    for (int i = 1; i <= imageCount; i++) {
      loadSpecial(imageDatabase[i]);
    }

    for (int i = 1; i <= memeCount; i++) {
      loadMemes(memeDatabase[i]);
    }

    for (int i = 1; i <= edhoLeCount; i++) {
      loadEdhoLe(edhoLeDatabase[i]);
    }

    for (int i = 1; i <= videoCount; i++) {
      loadVideos(videoDatabase[i]);
    }
  }

  Future<void> changeMusic() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      allowedExtensions: ['mp3'],
      type: FileType.custom,
      dialogTitle: 'Choose a audio',
    );
    if (result == null) {
      Fluttertoast.showToast(msg: 'Please Choose a mp3 file....');
    } else if (result.files.first.extension != 'mp3') {
      Fluttertoast.showToast(msg: 'Only Mp3 files are supported');
    } else if (result.files.first.extension == 'mp3') {
      File musciFile = File(result.files.single.path.toString());
      await musciFile.copy(path + '/audio/birthday_song.mp3');
      Fluttertoast.showToast(msg: 'Successfully changed background music');
      await assetsAudioPlayer.stop();
      await assetsAudioPlayer.play();
    } else {
      Fluttertoast.showToast(msg: 'Something Went Wrong!');
    }
  }

  checkPermission() async {
    if (!await requestPermission()) {
      Fluttertoast.showToast(
        msg: 'Please Give Permissions',
        toastLength: Toast.LENGTH_LONG,
      );
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }

  Future<void> getUsernameAndPassword() async {
    File temp = File(path + '/user/userdetails.txt');
    List<String> details = (await temp.readAsString()).toString().split(' ');
    realUsername = details[0];
    realPassword = details[1];
  }

  final _formkey = GlobalKey<FormState>();
  showChangeDialog(screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      height: screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(height: screenWidth * 0.07),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.04, screenWidth * 0.1, screenWidth * 0.04, 0),
              child: TextFormField(
                validator: (val) =>
                    val.toString().length < 6 ? 'Username is too short' : null,
                decoration:
                    textInputDecoration.copyWith(hintText: 'New username'),
                onChanged: (value) => newUsername = value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.05,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 2,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: screenWidth * 0.05,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.04, 0, screenWidth * 0.04, 0),
              child: TextFormField(
                validator: (val) =>
                    val.toString().length < 6 ? 'Username is too short' : null,
                decoration:
                    textInputDecoration.copyWith(hintText: 'New password'),
                obscureText: true,
                onChanged: (val) => newPassword = val,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.09),
            Flexible(
              child: Padding(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.07, 0, 0, 0),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          changerUsernameAndPassword();
                          setState(() {
                            showPreview = false;
                          });
                        }
                      },
                      child: Text(
                        'Reset',
                        style: GoogleFonts.prompt(
                          fontSize: screenWidth * 0.058,
                          color: Color(0xFF5D30B6),
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 0.3,
                            )
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(screenWidth * 0.35, screenWidth * 0.13)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.black))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.04,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          showPreview = false;
                        });
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.prompt(
                          fontSize: screenWidth * 0.058,
                          color: Color(0xFF5D30B6),
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 0.3,
                            )
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(screenWidth * 0.35, screenWidth * 0.13)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.black))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  changerUsernameAndPassword() async {
    File temp = File(path + '/user/userdetails.txt');
    temp.writeAsString(newUsername + ' ' + newPassword);
    realUsername = newUsername;
    realPassword = newPassword;
  }

  String newUsername = '', newPassword = '';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/img.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.7, screenWidth * 0.04, 0, 0),
                    child: Row(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Icon(
                            isSilent
                                ? Icons.volume_off
                                : Icons.volume_up_rounded,
                            color: Colors.amberAccent[400],
                            size: screenWidth * 0.09,
                          ),
                          onPressed: () {
                            assetsAudioPlayer.setVolume(isSilent ? 1 : 0);
                            setState(() {
                              isSilent = !isSilent;
                            });
                          },
                        ),
                        Flexible(
                          child: PopupMenuButton(
                            tooltip: 'Sorry',
                            iconSize: screenWidth * 0.09,
                            color: Colors.white,
                            onSelected: (item) {
                              if (item == 0) {
                                changeMusic();
                              } else if (item == 1) {
                                setState(() {
                                  showPreview = true;
                                });
                              }
                            },
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: Colors.amberAccent[400],
                            ),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  height: screenWidth * 0.06,
                                  child: Text('Change Music'),
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  height: 0,
                                  child: PopupMenuDivider(),
                                ),
                                PopupMenuItem(
                                  child: Text('Reset User'),
                                  height: screenWidth * 0.06,
                                  value: 1,
                                  textStyle: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ];
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.23,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.19, 0, screenWidth * 0.19, 0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter username'),
                      onChanged: (value) => username = value,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            ),
                          ]),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        screenWidth * 0.19, 0, screenWidth * 0.19, 0),
                    child: TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Enter password'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.06,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.07,
                  ),
                  Center(
                    child: ElevatedButton(
                      onLongPress: () {
                        Fluttertoast.showToast(msg: 'Example');
                      },
                      onPressed: () {
                        if (isValid(
                            username, password, screenWidth, screenHeight)) {
                          Navigator.pushNamed(context, '/select', arguments: {
                            'map': mp,
                            'audio': assetsAudioPlayer
                          });
                        }
                      },
                      child: Text(
                        'Sign In',
                        maxLines: 1,
                        style: GoogleFonts.prompt(
                          fontSize: screenWidth * 0.058,
                          color: Color(0xFF5D30B6),
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 0.3,
                            )
                          ],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(
                            Size(screenWidth * 0.45, screenWidth * 0.13)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.black))),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pinkAccent),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (showPreview) ...[
              BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 1.0,
                  sigmaY: 1.0,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Center(
                child: showChangeDialog(screenWidth),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void loadVideos(Map m) {
    mp['Videos']!.add(
        ReadEvery(name: m['title'], image: m['value'], number: m['number']));
  }

  void loadEdhoLe(Map m) {
    mp['Edho le']!.add(ReadEvery(
      image: m['value'],
    ));
  }

  void loadMemes(Map m) {
    mp['Memes']!
        .add(ReadEvery(name: m['title'], image: m['value'], message: m['des']));
  }

  void loadSpecial(Map m) {
    mp['Special']!.add(ReadEvery(
        name: m['title'],
        image: m['value'],
        number: m['number'],
        message: m['des']));
  }

  bool isValid(String username, String password, screenWidth, screenHeight) {
    if (username.compareTo(realUsername) == 0) {
      if (password.compareTo(realPassword) != 0) {
        Fluttertoast.showToast(
            msg: 'Incorrect password', toastLength: Toast.LENGTH_LONG);
        return false;
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Incorrect username',
          toastLength: Toast.LENGTH_LONG);
      return false;
    }
    return true;
  }
}
