import 'dart:io';
import 'package:birthdayfafa/services/getPath.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

returnThumbnail(videoURL, listOfAvailable, index, String str) async {
  try {
    String videoName = videoURL.toString();
    videoName = videoName.substring(
        videoName.indexOf('o/') + 2, videoName.indexOf('.mp4'));
    Directory temp = (await getExternalStorageDirectory())!;
    temp = Directory(await getPath(temp, 'cache'));
    await Directory(temp.path).create(recursive: true);
    final File imageFile = File('${temp.path}/$videoName.png');
    Directory externalDirectory = Directory(await getPath(temp, str));

    if (await imageFile.exists()) {
      if (await externalDirectory.exists()) {
        if (await File(externalDirectory.path + '/$videoName.mp4').exists()) {
          listOfAvailable[index].isPresent = true;
          listOfAvailable[index].source =
              externalDirectory.path + '/$videoName.mp4';
        }
      }
      return imageFile.path;
    } else {
      if (await externalDirectory.exists()) {
        if (await File(externalDirectory.path + '/$videoName.mp4').exists()) {
          listOfAvailable[index].isPresent = true;
          listOfAvailable[index].source =
              externalDirectory.path + '/$videoName.mp4';
          return await VideoThumbnail.thumbnailFile(
            video: externalDirectory.path + '/$videoName.mp4',
            thumbnailPath: temp.path,
            imageFormat: ImageFormat.PNG,
            quality: 100,
          );
        }
      }
    }
    print(videoURL);
    return await VideoThumbnail.thumbnailFile(
      video: videoURL,
      thumbnailPath: temp.path,
    );
  } catch (e) {
    print(e);
  }
}
