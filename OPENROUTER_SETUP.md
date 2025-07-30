# OpenRouter AI Integration Setup

## What is OpenRouter?

OpenRouter is a unified API that provides access to multiple AI models (OpenAI, Anthropic, Google, etc.) through a single interface. This makes it easy to switch between different AI providers.

## Setup Instructions

### 1. Get OpenRouter API Key

1. Go to [OpenRouter.ai](https://openrouter.ai)
2. Sign up for an account
3. Navigate to "Keys" section
4. Create a new API key
5. Copy the API key

### 2. Configure Your App

1. Open `lib/services/ai_config.dart`
2. Replace `YOUR_OPENROUTER_API_KEY` with your actual API key:

```dart
static const String openRouterApiKey = 'sk-or-v1-your-actual-api-key-here';
```

### 3. Free Models Available

The app is configured to use free models from OpenRouter. These models are available at no cost:

**Primary Models (Free Tier):**

- `openai/gpt-3.5-turbo` - Fast and reliable, free tier available
- `anthropic/claude-3-haiku` - Good reasoning, free tier available

**Completely Free Models:**

- `google/gemma-2-9b-it` - Google's free model
- `google/gemma-2-2b-it` - Smaller, faster Google model
- `meta-llama/llama-3.1-8b-instruct` - Meta's free model
- `microsoft/phi-3-mini-4k-instruct` - Microsoft's free model

The app automatically tries these models in order if one fails, ensuring you always get AI-powered recommendations without any cost.

### 4. Test the Integration

1. Run your app
2. Go to the Home screen
3. Enter a prompt like "I need a modern login button"
4. The AI should analyze your request and return relevant components

## How It Works

1. **User Input**: User enters a natural language prompt
2. **AI Analysis**: OpenRouter analyzes the prompt and understands the intent
3. **Component Matching**: AI identifies relevant components from your library
4. **Ranked Results**: Components are ranked by relevance with scores
5. **Visual Feedback**: Results show with AI badges and relevance scores

## Example Prompts to Try

- "I need a modern login button"
- "Show me colorful cards for a product showcase"
- "Find interactive form elements"
- "Display navigation menus"
- "Create a dark theme button"
- "I want animated components"

## Troubleshooting

### API Key Issues

- Make sure your API key is correct
- Check if you have sufficient credits in your OpenRouter account
- Verify the API key has the necessary permissions

### No Results

- The AI might not find exact matches
- Try more specific prompts
- Check if your component library has the requested components

### Fallback Mode

If the AI API fails, the app automatically falls back to local keyword matching to ensure functionality.

## Cost Considerations

- **Free Models**: All configured models are free to use
- **No Credit Required**: You don't need to add credits to your account
- **Free Tier**: GPT-3.5-turbo and Claude-3-haiku have generous free tiers
- **Completely Free**: Gemma, Llama, and Phi models are 100% free
- **Automatic Fallback**: If one model fails, it tries the next free model

The app is designed to work entirely with free models, so you won't incur any charges.

## Security Notes

- Never commit your API key to version control
- Consider using environment variables for production
- The API key is only used for AI analysis, not stored permanently
