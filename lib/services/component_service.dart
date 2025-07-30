// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ComponentService extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, List<Map<String, dynamic>>> _componentsByCategory = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Map<String, dynamic>>> get componentsByCategory =>
      _componentsByCategory;

  Future<void> fetchComponents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await Supabase.instance.client
          .from('ui_componets')
          .select();
      print('Supabase response:');
      print(response);
      // Assume each component has a 'category' field
      final Map<String, List<Map<String, dynamic>>> categorized = {};
      for (final item in response) {
        final category = item['category'] ?? 'Uncategorized';
        categorized.putIfAbsent(category, () => []).add(item);
      }
      _componentsByCategory = categorized;
    } catch (e) {
      print('Error fetching components:');
      print(e);
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Search components by matching keywords in the tags field.
  Map<String, List<Map<String, dynamic>>> searchComponentsByPrompt(
    String prompt,
  ) {
    if (prompt.trim().isEmpty) return _componentsByCategory;
    final keywords = prompt
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((k) => k.isNotEmpty)
        .toSet();
    final Map<String, List<Map<String, dynamic>>> filtered = {};
    _componentsByCategory.forEach((category, components) {
      final matches = components.where((component) {
        final dynamic tagsValue = component['tags'];
        List<String> tags = [];

        if (tagsValue is List) {
          // If it's already a list, process it as before.
          tags = tagsValue.map((t) => t.toString().toLowerCase()).toList();
        } else if (tagsValue is String && tagsValue.isNotEmpty) {
          // If it's a string, split it by commas into a list.
          tags = tagsValue
              .split(',')
              .map((t) => t.trim().toLowerCase())
              .where((t) => t.isNotEmpty)
              .toList();
        }
        return tags.any((tag) => keywords.any((kw) => tag.contains(kw)));
      }).toList();
      if (matches.isNotEmpty) {
        filtered[category] = matches;
      }
    });
    return filtered;
  }
}
