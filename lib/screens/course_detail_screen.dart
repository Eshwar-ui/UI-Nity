// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  // Use a Set to efficiently track the indices of completed chapters.
  final Set<int> _completedChapters = <int>{};
  final Set<int> _expandedTiles = <int>{};

  // Calculate the progress percentage.
  double get _progress => _completedChapters.isEmpty
      ? 0.0
      : _completedChapters.length / widget.course.chapters.length;

  // Toggles the completion status of a chapter and rebuilds the widget.
  void _toggleChapterCompletion(int index) {
    setState(() {
      if (_completedChapters.contains(index)) {
        _completedChapters.remove(index);
      } else {
        _completedChapters.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        forceMaterialTransparency: true,

        title: Text(
          widget.course.title,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        // iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.course.chapters.length,
        itemBuilder: (context, index) {
          final chapter = widget.course.chapters[index];
          final isCompleted = _completedChapters.contains(index);

          return Card(
            margin: const EdgeInsets.only(bottom: 20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            color: isCompleted ? Colors.grey[100] : Colors.white,
            shadowColor: Colors.black12,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                leading: GestureDetector(
                  onTap: () => _toggleChapterCompletion(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.black : Colors.white,
                      border: Border.all(
                        color: isCompleted ? Colors.black : Colors.grey[400]!,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      isCompleted ? Icons.check : Icons.radio_button_unchecked,
                      color: isCompleted ? Colors.white : Colors.black,
                      size: 28,
                    ),
                  ),
                ),
                title: Text(
                  chapter.title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isCompleted ? Colors.grey[600] : Colors.black,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: Icon(
                  _expandedTiles.contains(index)
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
                initiallyExpanded: _expandedTiles.contains(index),
                onExpansionChanged: (expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedTiles.add(index);
                    } else {
                      _expandedTiles.remove(index);
                    }
                  });
                },
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.content,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        if (chapter.resource != null &&
                            chapter.resource!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () async {
                              final url = Uri.parse(chapter.resource!);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not launch the link'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.link, color: Colors.black),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            label: const Text(
                              'Resource',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
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
    );
  }
}
