import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/movie.dart';
import '../../routes/app_routes.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.movieDetail,
          arguments: movie,
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.imageUrl,
                height: 240,
                width: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 240,
                  width: 180,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.broken_image,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${movie.year} • ${movie.genres.take(2).join(', ')}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}