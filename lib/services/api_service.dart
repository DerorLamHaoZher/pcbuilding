import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000';

  static Future<Map<String, dynamic>> refreshPcParts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/scrape'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to refresh PC parts');
      }
    } catch (e) {
      print('Error in refreshPcParts: $e'); // Debug logging
      throw Exception('Error refreshing PC parts: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPcParts({
    String? category,
    String? searchQuery,
  }) async {
    try {
      var url = '$baseUrl/products';
      
      // Add query parameters if they exist
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (searchQuery != null) queryParams['q'] = searchQuery;
      
      if (queryParams.isNotEmpty) {
        url += '?${Uri.encodeQueryComponent(queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&'))}';
      }

      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        throw Exception('Failed to load PC parts');
      }
    } catch (e) {
      throw Exception('Error fetching PC parts: $e');
    }
  }

  static Future<bool> checkDataExists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/scrape-status'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['has_data'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
} 

