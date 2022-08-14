import 'dart:io';
import 'package:birthdayfafa/services/getPath.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

shareFile(avail, String temp, dio, String extension, String startName) async {
  try {
    if (avail.isPresent!) {
      Share.shareFiles(
        [avail.source.toString()],
      );
    } else {
      File file = await shareResource(
          avail.source.toString(), temp, dio, extension, startName);
      await Share.shareFiles(
        [file.path],
      );
      file.delete();
    }
  } catch (e) {
    print(e);
  }
}

shareResource(String fileURL, String temp, dio, String extension,
    String startName) async {
  var backExtension = (extension == '.jp') ? '.jpg' : extension;
  var fileName = fileURL.substring(
          fileURL.indexOf(startName) + startName.length,
          fileURL.indexOf(extension)) +
      backExtension;
  Directory directory;
  try {
      directory = (await getExternalStorageDirectory())!;
      directory = Directory(await getPath(directory, temp));
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      File saveFile = File(directory.path + '/$fileName');
      Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: 'Please wait...',
        toastLength: Toast.LENGTH_LONG,
      );
      await dio.download(fileURL, saveFile.path);
      Fluttertoast.cancel();
      return saveFile;
    }
  catch (e) {
    print(e);
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: 'Failed To share!!',
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}

downloadFile(avail, dio, String startName, String extension, String fileType,
    String folderName) async {
  if (avail.isPresent!) {
    Fluttertoast.showToast(
      msg: '$fileType Already Downloaded!!',
      toastLength: Toast.LENGTH_SHORT,
    );
    return;
  }
  var backExtension = (extension == '.jp') ? '.jpg' : extension;
  var url = avail.source.toString();
  var fileName = url.substring(
          url.indexOf(startName) + startName.length, url.indexOf(extension))+ backExtension;
  Directory directory;
  try {
      directory = (await getExternalStorageDirectory())!;
    directory = Directory(await getPath(directory, folderName));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    File saveFile = File(directory.path + '/$fileName');
    Fluttertoast.showToast(
      msg: 'Downloading Started :-)',
      toastLength: Toast.LENGTH_SHORT,
    );
    await dio.download(url, saveFile.path);
    MediaScanner.loadMedia(path: saveFile.path);
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: '$fileType Downloaded!!',
      toastLength: Toast.LENGTH_SHORT,
    );
    avail.isPresent = true;
    avail.source = saveFile.path;
  } catch (e) {
    print(e);
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: 'Failed To Download $fileType :-(',
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
