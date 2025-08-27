import 'package:flutter/material.dart';
import '../../models/movie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample movie data
  static const List<Movie> movies = [
    Movie(
      title: 'Inception',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '2010',
      rating: '8.8',
    ),
    Movie(
      title: 'The Dark Knight',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '2008',
      rating: '9.0',
    ),
    Movie(
      title: 'Interstellar',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '2014',
      rating: '8.6',
    ),
    Movie(
      title: 'The Shawshank Redemption',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '1994',
      rating: '9.3',
    ),
    Movie(
      title: 'Pulp Fiction',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '1994',
      rating: '8.9',
    ),
    Movie(
      title: 'The Godfather',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/en/a/af/Batman_Begins_Poster.jpg',
      year: '1972',
      rating: '9.2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepPurple.shade100,
                        backgroundImage: const NetworkImage(
                          'https://cdn2.iconfinder.com/data/icons/avatars-60/5985/24-Maid-128.png',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Filhan',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.deepPurple,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready for a movie night?\nBook your ticket now!',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Search button
                  IconButton(
                    icon: const Icon(Icons.notifications, size: 28),
                    onPressed: () {
                      // TODO: Implement search functionality
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Movie grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Movie poster
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              movie.imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Movie details
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      movie.year,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie.rating,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
