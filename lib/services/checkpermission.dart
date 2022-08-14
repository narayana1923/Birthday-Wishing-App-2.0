import 'package:permission_handler/permission_handler.dart';
import 'package:device_info/device_info.dart';

Future<bool> requestPermission() async {
  var androidInfo = (await DeviceInfoPlugin().androidInfo).version.release;
  Permission permission;
  if (int.parse(androidInfo) >= 11)
    permission = Permission.manageExternalStorage;
  else
    permission = Permission.storage;
  var result = await permission.request();
  if (result == PermissionStatus.granted) {
    return true;
  } else if (result == PermissionStatus.permanentlyDenied) {
    await openAppSettings();
    if (await permission.isGranted) return true;
    return false;
  }
  return false;
}
