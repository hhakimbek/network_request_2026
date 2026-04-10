import 'dart:convert';
import 'package:http/http.dart';

class Network {
  static const String BASE = "jsonplaceholder.typicode.com";
  static Map<String, String> headers = {
    'Content-type': 'application/json; charset=UTF-8',
  };

  // HTTP APIs
  static const String API_LIST = "/posts";
  static const String API_CREATE = "/posts";
  static const String API_UPDATE = "/posts/"; //{id}
  static const String API_DELETE = "/posts/"; //{id}

  // HTTP requests
  static Future<String?> GET(
    String api, [
    Map<String, String> params = const {},
  ]) async {
    try {
      var uri = Uri.https(BASE, api, params);
      var response = await get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
      ;
      print(response.body);
      return null;
    } catch (e) {
      print("MY ERROR: $e");
      return null;
    }
  }

  static Future<String?> POST(String api, Map<String, dynamic> body) async {
    try {
      var uri = Uri.https(BASE, api);
      var response = await post(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> PUT(String api, Map<String, dynamic> body) async {
    try {
      var uri = Uri.https(BASE, api);
      var response = await put(uri, headers: headers, body: jsonEncode(body));
      if (response.statusCode == 200) return response.body;
      return null;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> DELETE(String api) async {
    try {
      var uri = Uri.https(BASE, api);
      var response = await delete(uri, headers: headers);
      if (response.statusCode == 200) return response.body;
      return null;
    } catch (e) {
      return null;
    }
  }
}
