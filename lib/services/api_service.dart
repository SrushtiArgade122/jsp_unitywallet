// services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart'
    as http; // CRITICAL: Ensure you have 'http: ^0.13.6' in pubspec.yaml
import '../config.dart'; // Reads the GOOGLE_SCRIPT_URL constant

class ApiService {
  /// Fetches or refreshes user data from the Google Apps Script.
  /// Uses the provided member ID and Name for lookup.
  /// Returns the Map of user data on status 'success', or null on failure.
  static Future<Map<String, dynamic>?> loginUser(String id, String name) async {
    try {
      // Constructs the full URL with action=login, id, and name parameters
      final url = Uri.parse(
        "$GOOGLE_SCRIPT_URL?action=login&id=$id&name=$name",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // This print is VITAL for debugging the ₹0.00 issue.
        // DO NOT REMOVE THIS LINE until your app is working perfectly.
        print("🔥 RAW API RESPONSE: $decoded");

        // Check for the success status returned by your Google Apps Script
        if (decoded is Map<String, dynamic> && decoded['status'] == 'success') {
          return decoded;
        } else if (decoded is Map<String, dynamic> &&
            decoded['status'] == 'error') {
          print("API Login Error: ${decoded['message']}");
          return null;
        }
      }

      print(
        "API FAILED: Status ${response.statusCode}, Body: ${response.body}",
      );
      return null;
    } catch (e) {
      print("API ERROR (Connection/Decoding): $e");
      return null;
    }
  }
}
