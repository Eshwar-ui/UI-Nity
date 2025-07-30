// ignore_for_file: use_build_context_synchronously

import 'package:design_editor_app/screens/editor_screen.dart';
import 'package:design_editor_app/services/component_library_provider.dart';
import 'package:design_editor_app/services/ai_prompt_service.dart';
import 'package:design_editor_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/component_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _lastPrompt = '';
  Map<String, List<Map<String, dynamic>>>? _searchResults;
  String _greeting = 'Hello, Designer!';

  @override
  void initState() {
    super.initState();
    // Fetch components and user data when the screen is first built
    Future.microtask(() {
      context.read<ComponentService>().fetchComponents();
      _loadGreeting();
    });
  }

  Future<void> _loadGreeting() async {
    String newGreeting = 'Hello, Designer!';
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // Fetch profile details from the 'users' table
      final response = await Supabase.instance.client
          .from('users')
          .select('name')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        final name = response['name'] as String?;
        if (name != null && name.isNotEmpty) {
          newGreeting = 'Hello, $name!';
        } else if (user.email != null && user.email!.isNotEmpty) {
          newGreeting = 'Hello, ${user.email!.split('@').first}!';
        }
      } else if (user.email != null && user.email!.isNotEmpty) {
        newGreeting = 'Hello, ${user.email!.split('@').first}!';
      }
    } catch (e) {
      // Catch other potential errors (network, etc.) and fallback to email.
      final user = Supabase.instance.client.auth.currentUser;
      if (user?.email != null && user!.email!.isNotEmpty) {
        newGreeting = 'Hello, ${user.email!.split('@').first}!';
      }
      debugPrint('Could not fetch user name, falling back: $e');
    } finally {
      if (mounted) setState(() => _greeting = newGreeting);
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final componentService = context.watch<ComponentService>();
    final libraryProvider = context.watch<ComponentLibraryProvider>();
    final aiPromptService = context.watch<AIPromptService>();

    if (componentService.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (componentService.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Could not load components: ${componentService.error}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
              ),
            ),
          ),
        ),
      );
    }
    final componentsByCategory = _searchResults != null
        ? _filterAIRecommendedComponents(_searchResults!)
        : componentService.componentsByCategory;

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false, // Prevent back button
        title: Row(
          children: [
            const Icon(Icons.waving_hand_outlined, size: 28),
            const SizedBox(width: 8),
            Expanded(child: Text(_greeting, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Preview area
          if (libraryProvider.selectedComponent != null)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    libraryProvider.selectedComponent?['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (libraryProvider.selectedComponent?['preview'] != null)
                    SizedBox(
                      height: 180,
                      child: libraryProvider.selectedComponent!['preview'],
                    )
                  else
                    const Text('No Preview Available'),
                  if (libraryProvider.selectedComponent?['description'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        libraryProvider.selectedComponent!['description'],
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => libraryProvider.clearSelection(),
                    ),
                  ),
                ],
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _promptController,
                hintText:
                    'Try: "I need a modern login button" or "Show me colorful cards" or "Find interactive forms"',
                keyboardType: TextInputType.multiline,
                isEnabled: true,
                minlines: 3,
                validator: (value) => null,
              ),
              CustomCTA(
                textColor: Theme.of(context).colorScheme.primary,
                color: Theme.of(context).scaffoldBackgroundColor,
                onPressed: () async {
                  final prompt = _promptController.text.trim();
                  if (prompt.isEmpty) return;

                  setState(() {
                    _lastPrompt = prompt;
                  });

                  try {
                    final aiResults = await aiPromptService
                        .understandPromptAndSearch(
                          prompt,
                          componentService.componentsByCategory,
                        );

                    if (mounted) {
                      setState(() {
                        _searchResults = aiResults;
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('AI search failed: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                text: aiPromptService.isLoading
                    ? 'AI Processing...'
                    : 'AI Search',
                borderRadius: 16,
                isLoading: aiPromptService.isLoading,
                shadowColor: Theme.of(context).colorScheme.primary,
              ),
              if (_lastPrompt.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.psychology,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Analysis for: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: Text(
                                _lastPrompt,
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              tooltip: 'Clear search',
                              onPressed: () {
                                setState(() {
                                  _promptController.clear();
                                  _lastPrompt = '';
                                  _searchResults = null;
                                });
                              },
                            ),
                          ],
                        ),
                        if (aiPromptService.error == null &&
                            _searchResults != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'AI found relevant components based on your request. Components are ranked by relevance.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          ...componentsByCategory.entries.map((entry) {
            final category = entry.key;
            final components = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          category,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        if (_searchResults != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${components.length} AI matches',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: components.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final component = components[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return EditorScreen(
                                    componentData: {
                                      'component_name': component['name'],
                                      'flutter_code':
                                          component['flutter_code'] ?? '',
                                      'react_code':
                                          component['react_code'] ?? '',
                                      'html_css_code':
                                          component['html_css_code'] ?? '',
                                      'description':
                                          component['description'] ?? '',
                                      'preview':
                                          context
                                              .read<ComponentLibraryProvider>()
                                              .getComponentByName(
                                                context,
                                                // Pass the BuildContext as the first argument
                                                component['name'],
                                                // Pass the component map as the second argument
                                              ) ??
                                          const SizedBox.shrink(),
                                      'category':
                                          component['category'] ??
                                          'Uncategorized',
                                      'tags': component['tags'] ?? [],
                                    },
                                  );
                                },
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 100,
                            width: 170,
                            child: Stack(
                              children: [
                                CustomCardComponent(
                                  title: component['name'] ?? 'No Title',
                                  component: Builder(
                                    builder: (context) {
                                      try {
                                        final preview = context
                                            .read<ComponentLibraryProvider>()
                                            .getComponentByName(
                                              context,
                                              component['name'],
                                            );
                                        if (preview == null) {
                                          // If null, show icon
                                          return const Icon(
                                            Icons.widgets,
                                            size: 48,
                                            color: Colors.grey,
                                          );
                                        }
                                        return FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: SizedBox(
                                            width: 250,
                                            child: preview,
                                          ),
                                        );
                                      } catch (e) {
                                        // If any error occurs, show icon
                                        return const Icon(
                                          Icons.widgets,
                                          size: 48,
                                          color: Colors.grey,
                                        );
                                      }
                                    },
                                  ),
                                  category:
                                      component['category'] ?? 'Uncategorized',
                                ),
                                // AI Relevance Score Badge
                                if (_searchResults != null &&
                                    component['relevanceScore'] != null)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            '${(component['relevanceScore'] is int ? (component['relevanceScore'] as int).toDouble() : component['relevanceScore'] as double).toStringAsFixed(1)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        if (component['aiRecommended'] == true)
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 2,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text(
                                              'AI',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // Filter components to show only AI-recommended ones
  Map<String, List<Map<String, dynamic>>> _filterAIRecommendedComponents(
    Map<String, List<Map<String, dynamic>>> searchResults,
  ) {
    final Map<String, List<Map<String, dynamic>>> filteredResults = {};

    searchResults.forEach((category, components) {
      // Filter components that are AI recommended or have relevance scores
      final filteredComponents = components.where((component) {
        final isAIRecommended = component['aiRecommended'] == true;
        final hasRelevanceScore = component['relevanceScore'] != null;
        final relevanceScore = component['relevanceScore'];

        // Include if AI recommended or has a good relevance score (> 0)
        if (isAIRecommended) return true;
        if (hasRelevanceScore) {
          final score = relevanceScore is int
              ? relevanceScore.toDouble()
              : (relevanceScore as double? ?? 0.0);
          return score > 0;
        }
        return false;
      }).toList();

      // Only include categories that have filtered components
      if (filteredComponents.isNotEmpty) {
        filteredResults[category] = filteredComponents;
      }
    });

    return filteredResults;
  }
}
