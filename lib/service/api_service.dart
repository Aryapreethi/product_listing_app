import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  static const String baseUrl =
      "https://fakestoreapi.com/productss";

  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          "Server error: ${response.statusCode}",
        );
      }
    } on http.ClientException {
      throw Exception("No internet connection");
    } on FormatException {
      throw Exception("Invalid data format");
    } catch (e) {
      throw Exception("Something went wrong: $e");
    }
  }
}

