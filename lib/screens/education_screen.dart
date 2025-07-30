// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../data/course_data.dart';
import '../models/course_model.dart';
import 'course_detail_screen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false, // Prevent back button
        title: const Text('Learning Hub'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use a max cross axis extent for responsive wrapping
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: courses.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400, // max width per card
              mainAxisSpacing: 24.0,
              crossAxisSpacing: 24.0,
              childAspectRatio: 1.999, // match AspectRatio below
            ),
            itemBuilder: (context, index) {
              final course = courses[index];
              return _buildCourseCard(context, course);
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 0.0),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 30,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                course.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailScreen(course: course),
                      ),
                    );
                  },
                  child: const Text('Start Learning'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
