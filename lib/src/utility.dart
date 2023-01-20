import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// Function to load the json file dynamically from asset folder.
Future<dynamic> loadJsonFromFile(String filePath) async {
  final jsonString = await rootBundle.loadString(filePath);
  return jsonDecode(jsonString);
}
