// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I change my profile picture?',
        'answer':
            'Tap the edit icon on your profile image, then select a new image from your gallery.',
      },
      {
        'question': 'How do I update my name?',
        'answer':
            'Tap the edit icon next to your name, enter your new name, and save.',
      },
      {
        'question': 'How do I enable or disable dark mode?',
        'answer':
            'Use the Dark Mode switch in your profile settings to toggle between light and dark themes.',
      },
      {
        'question': 'How do I reset my password?',
        'answer':
            'Sign out, then on the login screen tap "Forgot Password?" and follow the instructions.',
      },
      {
        'question': 'How do I delete my account?',
        'answer':
            'Scroll to the bottom of the profile screen and tap "Delete Account". Confirm your choice to permanently delete your account.',
      },
      {
        'question': 'How do I contact support?',
        'answer':
            'For help or feedback, email us at srirameshwarchandra@gmail.com .',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 2,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                ...faqs.map(
                  (faq) => ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      faq['question']!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 12,
                          left: 8,
                          right: 8,
                        ),
                        child: Text(
                          faq['answer']!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
