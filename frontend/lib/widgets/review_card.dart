import 'package:flutter/material.dart';

/// A reusable review card widget that displays a user review with title, content, author, and star rating
class ReviewCard extends StatelessWidget {
  final String title;
  final String review;
  final String author;
  final int rating;

  const ReviewCard({
    super.key,
    required this.title,
    required this.review,
    required this.author,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 14,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              '- $author',
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
