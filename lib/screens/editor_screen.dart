// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

class CodeSnippet {
  final String language;
  final String code;

  CodeSnippet({required this.language, required this.code});
}

class EditorScreen extends StatefulWidget {
  final Map<String, dynamic> componentData;

  const EditorScreen({super.key, required this.componentData});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final List<CodeSnippet> _snippetTemplates = [];

  @override
  void initState() {
    super.initState();
    _prepareSnippets();
  }

  void _prepareSnippets() {
    final dynamic flutterValue = widget.componentData['flutter_code'];
    final String? flutterCode = flutterValue is String ? flutterValue : null;
    if (flutterCode != null && flutterCode.trim().isNotEmpty) {
      _snippetTemplates.add(
        CodeSnippet(language: 'Flutter', code: flutterCode),
      );
    }

    final dynamic reactValue = widget.componentData['react_code'];
    final String? reactCode = reactValue is String ? reactValue : null;
    if (reactCode != null && reactCode.trim().isNotEmpty) {
      _snippetTemplates.add(CodeSnippet(language: 'React', code: reactCode));
    }

    final dynamic htmlCssValue = widget.componentData['html_css_code'];
    final String? htmlCssCode = htmlCssValue is String ? htmlCssValue : null;
    if (htmlCssCode != null && htmlCssCode.trim().isNotEmpty) {
      _snippetTemplates.add(
        CodeSnippet(language: 'HTML/CSS', code: htmlCssCode),
      );
    }

    if (_snippetTemplates.isEmpty) {
      _snippetTemplates.add(
        CodeSnippet(
          language: 'Info',
          code: 'No code snippets found for this component.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final componentName =
        widget.componentData['component_name'] as String? ?? 'Component';
    final componentDescription =
        widget.componentData['description'] as String? ?? '';
    final componentPreview = widget.componentData['preview'];
    final category =
        widget.componentData['category'] as String? ?? 'Uncategorized';
    final dynamic tagsRaw = widget.componentData['tags'];
    List<String> tags;
    if (tagsRaw is List) {
      tags = tagsRaw.map((e) => e.toString()).toList();
    } else if (tagsRaw is String && tagsRaw.trim().isNotEmpty) {
      tags = tagsRaw.split(',').map((e) => e.trim()).toList();
    } else {
      tags = [];
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final previewHeight = screenHeight * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: Text(componentName),
        forceMaterialTransparency: true,
      ),
      body: kIsWeb
          ? LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return SingleChildScrollView(
                  child: isWide
                      ? Row(
                          children: [
                            SizedBox(
                              width: constraints.maxWidth / 2,
                              child: AspectRatio(
                                aspectRatio: 1.4,
                                child: Container(
                                  color: Colors.grey[100],
                                  child: Center(child: componentPreview),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: constraints.maxWidth / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        16,
                                        16,
                                        16,
                                        8,
                                      ),
                                      child: Text(
                                        componentDescription,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Category: ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Chip(
                                            label: Text(category),
                                            backgroundColor: Colors.blue[50],
                                            labelStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (tags.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 4,
                                        ),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: tags
                                              .map(
                                                (tag) => Chip(
                                                  label: Text(tag),
                                                  backgroundColor:
                                                      Colors.green[50],
                                                  labelStyle: const TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ..._snippetTemplates.map(
                                      (snippet) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 8,
                                        ),
                                        child: ExpansionTile(
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                          title: Text(snippet.language),
                                          children: [
                                            AnimatedSwitcher(
                                              duration: const Duration(
                                                milliseconds: 400,
                                              ),
                                              transitionBuilder:
                                                  (child, animation) =>
                                                      SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                            0,
                                                            0.1,
                                                          ),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        ),
                                                      ),
                                              child: _CodeSnippetView(
                                                key: ValueKey(
                                                  snippet.language,
                                                ), // for animation
                                                language: snippet.language,
                                                code: snippet.code,
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
                        )
                      : Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.4,
                              child: Container(
                                color: Colors.grey[100],
                                child: Center(child: componentPreview),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      16,
                                      8,
                                    ),
                                    child: Text(
                                      componentDescription,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Category: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Chip(
                                          label: Text(category),
                                          backgroundColor: Colors.blue[50],
                                          labelStyle: const TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (tags.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 4,
                                      ),
                                      child: Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: tags
                                            .map(
                                              (tag) => Chip(
                                                label: Text(tag),
                                                backgroundColor:
                                                    Colors.green[50],
                                                labelStyle: const TextStyle(
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ..._snippetTemplates.map(
                                    (snippet) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 8,
                                      ),
                                      child: ExpansionTile(
                                        tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        title: Text(snippet.language),
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 400,
                                            ),
                                            transitionBuilder:
                                                (child, animation) =>
                                                    SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: const Offset(
                                                          0,
                                                          0.1,
                                                        ),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: FadeTransition(
                                                        opacity: animation,
                                                        child: child,
                                                      ),
                                                    ),
                                            child: _CodeSnippetView(
                                              key: ValueKey(
                                                snippet.language,
                                              ), // for animation
                                              language: snippet.language,
                                              code: snippet.code,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                );
              },
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                // 30% height preview
                Container(
                  height: previewHeight,
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Center(child: componentPreview),
                ),
                // Description
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    componentDescription,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                // Category
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Category: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text(category),
                        backgroundColor: Colors.blue[50],
                        labelStyle: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                // Tags
                if (tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.green[50],
                              labelStyle: const TextStyle(color: Colors.green),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                // Code snippets
                ..._snippetTemplates.map(
                  (snippet) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                      title: Text(snippet.language),
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.1),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              ),
                          child: _CodeSnippetView(
                            key: ValueKey(snippet.language), // for animation
                            language: snippet.language,
                            code: snippet.code,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CodeSnippetView extends StatelessWidget {
  final String language;
  final String code;

  const _CodeSnippetView({
    super.key,
    required this.language,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(35, 39, 47, 1), // dark background
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 0),
                child: SelectableText(
                  code,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    color: Colors.white, // light text
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: TextButton.icon(
                icon: const Icon(
                  Icons.copy_all_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'Copy',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.08),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$language code copied to clipboard!'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
