import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<dynamic> getApi(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching : $e');
      return null;
    }
  }

  static Future<dynamic> postApi(
    String url,
    Map body,
    Map<String, String>? headers,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers ??
            {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
      );
      // print(response.statusCode);
      if (response.statusCode == 201) {
        return response;
      } else {
        print('some error while creating post ' + response.body);
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<dynamic> updateApi(
    String url,
    Map body,
    Map<String, String>? headers,
  ) async {
    try {
      final response = await http.put(Uri.parse(url),
          body: jsonEncode(body),
          headers: headers ??
              {
                "Content-Type": "application/json",
                "Accept": "application/json",
              });
      if (response.statusCode == 200) {
        return response;
      } else {
        print('some error while updating post ' + response.body);
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<dynamic> deleteApi(
    String url,
    Map<String, String>? headers,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: headers ??
            {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Some error while deleting post ' + response.body);
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
