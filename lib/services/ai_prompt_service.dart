import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/app_logger.dart';
import 'ai_config.dart';

class AIPromptService extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // AI-powered prompt understanding and component search
  Future<Map<String, List<Map<String, dynamic>>>> understandPromptAndSearch(
    String prompt,
    Map<String, List<Map<String, dynamic>>> allComponents,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      appLogger.i('Processing AI prompt: $prompt');

      // Step 1: Get AI analysis and component recommendations
      final aiResponse = await _getAIRecommendations(prompt, allComponents);

      // Step 2: Process AI response and find matching components
      final rankedComponents = await _processAIResponse(
        aiResponse,
        allComponents,
      );

      _isLoading = false;
      notifyListeners();

      return rankedComponents;
    } catch (e, stackTrace) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      appLogger.e(
        'AI prompt processing error',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  // Get AI recommendations using OpenRouter API
  Future<Map<String, dynamic>> _getAIRecommendations(
    String prompt,
    Map<String, List<Map<String, dynamic>>> allComponents,
  ) async {
    try {
      // Prepare component data for AI
      final componentData = _prepareComponentDataForAI(allComponents);

      // Create comprehensive AI prompt with component data
      final aiPrompt = _createAIPrompt(prompt, componentData);

      // Call OpenRouter API
      final response = await _callOpenAI(aiPrompt);

      return response;
    } catch (e) {
      appLogger.e(
        'AI API call failed, falling back to local analysis',
        error: e,
      );
      // Fallback to local analysis if AI API fails
      return await _fallbackAnalysis(prompt, allComponents);
    }
  }

  // Prepare component data in a format suitable for AI
  String _prepareComponentDataForAI(
    Map<String, List<Map<String, dynamic>>> allComponents,
  ) {
    final List<String> componentDescriptions = [];

    allComponents.forEach((category, components) {
      for (final component in components) {
        final name = component['name'] ?? 'Unknown';
        final description = component['description'] ?? '';
        final tags = component['tags'] ?? [];
        final tagsString = tags is List ? tags.join(', ') : tags.toString();

        componentDescriptions.add(
          'Component: $name | Category: $category | Description: $description | Tags: $tagsString',
        );
      }
    });

    return componentDescriptions.join('\n');
  }

  // Create a comprehensive AI prompt
  String _createAIPrompt(String userPrompt, String componentData) {
    return '''
You are an expert UI/UX designer and developer. A user has requested: "$userPrompt"

Available components in the system:
$componentData

Please analyze the user's request and:
1. Understand their intent and requirements
2. Identify which components would be most relevant
3. Provide a JSON response with:
   - intent: what the user wants to do (create, find, modify)
   - componentType: the main type of component they need
   - style: any style preferences mentioned
   - functionality: any specific functionality requirements
   - recommendedComponents: array of component names that best match their needs
   - reasoning: brief explanation of why these components were chosen
   - relevanceScores: object mapping component names to relevance scores (0-10)

Return only valid JSON, no additional text.
''';
  }

  // Call OpenRouter API
  Future<Map<String, dynamic>> _callOpenAI(String prompt) async {
    try {
      // Check if API key is configured
      if (AIConfig.openRouterApiKey == 'YOUR_OPENROUTER_API_KEY') {
        appLogger.w(
          'OpenRouter API key not configured, using fallback analysis',
        );
        return await _fallbackAnalysis(prompt, {});
      }

      // Call OpenRouter API
      final response = await _callOpenRouterAPI(prompt);
      return response;
    } catch (e) {
      appLogger.e('OpenRouter API call failed, using fallback', error: e);
      return await _fallbackAnalysis(prompt, {});
    }
  }

  // Call OpenRouter API with model fallback
  Future<Map<String, dynamic>> _callOpenRouterAPI(String prompt) async {
    // Try different models if one fails
    for (final model in AIConfig.fallbackModels) {
      try {
        appLogger.i('Trying model: $model');

        // Check if model supports system prompts (some models don't)
        final supportsSystemPrompt =
            !model.contains('gemma') &&
            !model.contains('llama') &&
            !model.contains('phi');

        final messages = supportsSystemPrompt
            ? [
                {
                  'role': 'system',
                  'content':
                      'You are an expert UI/UX designer and developer. Analyze user requests for UI components and return relevant recommendations in JSON format. Always return valid JSON only, no additional text.',
                },
                {'role': 'user', 'content': prompt},
              ]
            : [
                {
                  'role': 'user',
                  'content':
                      '''You are an expert UI/UX designer and developer. Analyze this user request for UI components and return relevant recommendations in JSON format. Always return valid JSON only, no additional text.

User request: $prompt''',
                },
              ];

        final response = await http.post(
          Uri.parse(AIConfig.openRouterUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${AIConfig.openRouterApiKey}',
            'HTTP-Referer':
                'https://design-editor-app.com', // Your app's domain
            'X-Title': 'Design Editor App', // Your app's name
          },
          body: jsonEncode({
            'model': model,
            'messages': messages,
            'max_tokens': AIConfig.maxTokens,
            'temperature': AIConfig.temperature,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final content = data['choices'][0]['message']['content'];

          try {
            // Try to parse the JSON response
            final result = jsonDecode(content);
            appLogger.i('Successfully used model: $model');
            return result;
          } catch (e) {
            appLogger.e(
              'Failed to parse AI response as JSON from model: $model',
              error: e,
            );
            // Continue to next model if JSON parsing fails
            continue;
          }
        } else {
          appLogger.e(
            'OpenRouter API error with model $model: ${response.statusCode} - ${response.body}',
          );
          // Continue to next model if this one fails
          continue;
        }
      } catch (e) {
        appLogger.e('OpenRouter API call failed with model: $model', error: e);
        // Continue to next model if this one fails
        continue;
      }
    }

    // If all models fail, throw exception
    throw Exception('All OpenRouter models failed');
  }

  // Simulate AI response (fallback when API is not available)
  Future<Map<String, dynamic>> _simulateAIResponse(String prompt) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Extract keywords from prompt for intelligent response
    final lowerPrompt = prompt.toLowerCase();

    Map<String, dynamic> response = {
      'intent': 'find',
      'componentType': 'general',
      'style': 'default',
      'functionality': 'standard',
      'recommendedComponents': [],
      'reasoning':
          'Based on your request, here are the most relevant components.',
      'relevanceScores': {},
    };

    // Intelligent keyword analysis
    if (lowerPrompt.contains('button') || lowerPrompt.contains('btn')) {
      response['componentType'] = 'Buttons';
      response['recommendedComponents'] = [
        'Primary Button',
        'Secondary Button',
        'Icon Button',
      ];
      response['relevanceScores'] = {
        'Primary Button': 9.5,
        'Secondary Button': 8.5,
        'Icon Button': 7.5,
      };
    } else if (lowerPrompt.contains('form') ||
        lowerPrompt.contains('input') ||
        lowerPrompt.contains('field')) {
      response['componentType'] = 'Forms';
      response['recommendedComponents'] = [
        'Text Input',
        'Email Input',
        'Password Input',
      ];
      response['relevanceScores'] = {
        'Text Input': 9.0,
        'Email Input': 8.5,
        'Password Input': 8.0,
      };
    } else if (lowerPrompt.contains('card') ||
        lowerPrompt.contains('container')) {
      response['componentType'] = 'Cards';
      response['recommendedComponents'] = [
        'Profile Card',
        'Product Card',
        'Info Card',
      ];
      response['relevanceScores'] = {
        'Profile Card': 9.0,
        'Product Card': 8.5,
        'Info Card': 8.0,
      };
    } else if (lowerPrompt.contains('nav') || lowerPrompt.contains('menu')) {
      response['componentType'] = 'Navigation';
      response['recommendedComponents'] = [
        'Navigation Menu',
        'Tab Bar',
        'Sidebar',
      ];
      response['relevanceScores'] = {
        'Navigation Menu': 9.0,
        'Tab Bar': 8.5,
        'Sidebar': 8.0,
      };
    } else {
      // General search - return components from all categories
      response['recommendedComponents'] = [
        'Primary Button',
        'Secondary Button',
        'Text Input',
        'Profile Card',
      ];
      response['relevanceScores'] = {
        'Primary Button': 7.0,
        'Secondary Button': 6.5,
        'Text Input': 6.0,
        'Profile Card': 5.5,
      };
    }

    // Add style preferences
    if (lowerPrompt.contains('modern') || lowerPrompt.contains('clean')) {
      response['style'] = 'modern';
    } else if (lowerPrompt.contains('colorful') ||
        lowerPrompt.contains('vibrant')) {
      response['style'] = 'colorful';
    }

    // Add functionality preferences
    if (lowerPrompt.contains('interactive') ||
        lowerPrompt.contains('animated')) {
      response['functionality'] = 'interactive';
    }

    return response;
  }

  // Process AI response and find matching components
  Future<Map<String, List<Map<String, dynamic>>>> _processAIResponse(
    Map<String, dynamic> aiResponse,
    Map<String, List<Map<String, dynamic>>> allComponents,
  ) async {
    final Map<String, List<Map<String, dynamic>>> rankedResults = {};
    final recommendedComponents =
        aiResponse['recommendedComponents'] as List<dynamic>? ?? [];
    final relevanceScores =
        aiResponse['relevanceScores'] as Map<String, dynamic>? ?? {};

    appLogger.i('AI recommended components: $recommendedComponents');

    // Find and rank components based on AI recommendations
    allComponents.forEach((category, components) {
      final List<Map<String, dynamic>> categoryResults = [];

      for (final component in components) {
        final componentName = component['name'] as String? ?? '';
        final relevanceScore = relevanceScores[componentName] ?? 0.0;

        // Add component with AI relevance score
        categoryResults.add({
          ...component,
          'relevanceScore': relevanceScore,
          'category': category,
          'aiRecommended': recommendedComponents.contains(componentName),
        });
      }

      // Sort by relevance score (highest first)
      categoryResults.sort((a, b) {
        final scoreA = (a['relevanceScore'] is int)
            ? (a['relevanceScore'] as int).toDouble()
            : (a['relevanceScore'] as double? ?? 0.0);
        final scoreB = (b['relevanceScore'] is int)
            ? (b['relevanceScore'] as int).toDouble()
            : (b['relevanceScore'] as double? ?? 0.0);
        return scoreB.compareTo(scoreA);
      });

      // Only include categories with relevant components
      if (categoryResults.isNotEmpty) {
        rankedResults[category] = categoryResults;
      }
    });

    return rankedResults;
  }

  // Fallback analysis when AI API is not available
  Future<Map<String, dynamic>> _fallbackAnalysis(
    String prompt,
    Map<String, List<Map<String, dynamic>>> allComponents,
  ) async {
    final lowerPrompt = prompt.toLowerCase();

    // Simple keyword-based fallback
    final keywords = lowerPrompt
        .split(RegExp(r'\s+'))
        .where((word) => word.length > 2)
        .toList();
    final recommendedComponents = <String>[];
    final relevanceScores = <String, double>{};

    allComponents.forEach((category, components) {
      for (final component in components) {
        final componentName = component['name'] as String? ?? '';
        final description = component['description'] as String? ?? '';
        final tags = component['tags'] ?? [];

        double score = 0.0;

        // Score based on name matching
        if (lowerPrompt.contains(componentName.toLowerCase())) {
          score += 5.0;
        }

        // Score based on description matching
        for (final keyword in keywords) {
          if (description.toLowerCase().contains(keyword)) {
            score += 2.0;
          }
        }

        // Score based on tags
        if (tags is List) {
          for (final tag in tags) {
            if (lowerPrompt.contains(tag.toString().toLowerCase())) {
              score += 3.0;
            }
          }
        }

        if (score > 0) {
          recommendedComponents.add(componentName);
          relevanceScores[componentName] = score;
        }
      }
    });

    return {
      'intent': 'find',
      'componentType': 'general',
      'style': 'default',
      'functionality': 'standard',
      'recommendedComponents': recommendedComponents,
      'reasoning': 'Fallback analysis based on keyword matching.',
      'relevanceScores': relevanceScores,
    };
  }

  // Future: Actual OpenAI API integration
  Future<Map<String, dynamic>> _callOpenAIActual(String prompt) async {
    // Uncomment and configure when you have OpenAI API key
    /*
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_OPENAI_API_KEY',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a UI component expert. Analyze user requests and return relevant component recommendations in JSON format.'
          },
          {
            'role': 'user',
            'content': prompt
          }
        ],
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return jsonDecode(content);
    } else {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }
    */

    // Placeholder
    throw Exception('OpenAI API not configured');
  }
}
