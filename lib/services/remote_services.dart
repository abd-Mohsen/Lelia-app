import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class RemoteServices {
  static final String _hostIP = "$kHostIP/api";
  static final GetStorage _getStorage = GetStorage();
  static Map<String, String> headers = {
    "Accept": "Application/json",
  };

  static var client = http.Client();

  static Future<bool> register(
    String userName,
    String email,
    String password,
    String phone,
    int role,
    int? supervisorId,
  ) async {
    return true;
  }
}
