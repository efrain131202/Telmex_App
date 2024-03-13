import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }

  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted;
  }
}
