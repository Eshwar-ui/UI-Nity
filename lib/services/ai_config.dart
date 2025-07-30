// AI Configuration for the app
class AIConfig {
  // OpenRouter Configuration
  static const String openRouterApiKey =
      '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'; // Add your OpenRouter API key here
  static const String openRouterUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const String defaultModel =
      'anthropic/claude-3-haiku'; // You can change this to any model OpenRouter supports

  // Free models from OpenRouter (no cost)
  static const List<String> fallbackModels = [
    'anthropic/claude-3-haiku', // Free tier available
    'google/gemma-2-9b-it', // Free model
    'meta-llama/llama-3.1-8b-instruct', // Free model
    'microsoft/phi-3-mini-4k-instruct', // Free model
    'google/gemma-2-2b-it', // Free model
    'openai/gpt-3.5-turbo', // Free tier available (if accessible)
  ];
  static const int maxTokens = 500;
  static const double temperature = 0.7;

  // Alternative AI Services (for future use)
  static const String anthropicApiKey = 'YOUR_ANTHROPIC_API_KEY';
  static const String googleAIKey = 'YOUR_GOOGLE_AI_KEY';

  // Local AI fallback settings
  static const bool enableLocalFallback = true;
  static const int localAnalysisDelay = 500; // milliseconds

  // Component matching settings
  static const double minRelevanceScore = 0.0;
  static const double maxRelevanceScore = 10.0;
  static const int maxRecommendedComponents = 20;

  // UI Settings
  static const bool showAIRationale = true;
  static const bool showRelevanceScores = true;
  static const bool showAIRecommendedBadge = true;
}
