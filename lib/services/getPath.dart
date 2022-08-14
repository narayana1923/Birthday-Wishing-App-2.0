getPath(directory, String temp) async {
  String newPath = '';
  List<String> folders = directory.path.split("/");
  for (int x = 1; x < folders.length; x++) {
    if (folders[x] != 'Android') {
      newPath += '/' + folders[x];
    } else {
      break;
    }
  }
  if (temp == 'cache') {
    newPath = newPath + '/Android/media/com.narayana.birthdayfafa/.caches';
    return newPath;
  }
  newPath = newPath + '/Pictures/BirthdayFafa/BirthdayFafa $temp';
  return newPath;
}
