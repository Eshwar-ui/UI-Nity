class Course {
  final String title;
  final String description;
  final List<Chapter> chapters;

  const Course({
    required this.title,
    required this.description,
    required this.chapters,
  });
}

class Chapter {
  final String title;
  final String content;
  final String? resource;

  const Chapter({required this.title, required this.content, this.resource});
}
