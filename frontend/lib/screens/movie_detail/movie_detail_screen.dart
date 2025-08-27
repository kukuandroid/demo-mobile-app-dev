import 'package:flutter/material.dart';

class CastMember {
  final String name;
  final String role;
  final String imageUrl;

  const CastMember({
    required this.name,
    required this.role,
    required this.imageUrl,
  });
}

class MovieDetails {
  final String synopsis;
  final List<CastMember> cast;
  final List<String> directors;
  final List<String> writers;
  final String runtime;
  final List<String> genres;

  const MovieDetails({
    required this.synopsis,
    required this.cast,
    required this.directors,
    required this.writers,
    required this.runtime,
    required this.genres,
  });

  // Factory method to create sample data
  factory MovieDetails.sample() {
    return MovieDetails(
      synopsis:
          'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project and his team to disaster.',
      cast: const [
        CastMember(
          name: 'Leonardo DiCaprio',
          role: 'Cobb',
          imageUrl: 'https://via.placeholder.com/60?text=LD',
        ),
        CastMember(
          name: 'Joseph Gordon-Levitt',
          role: 'Arthur',
          imageUrl: 'https://via.placeholder.com/60?text=JL',
        ),
        CastMember(
          name: 'Ellen Page',
          role: 'Ariadne',
          imageUrl: 'https://via.placeholder.com/60?text=EP',
        ),
        CastMember(
          name: 'Tom Hardy',
          role: 'Eames',
          imageUrl: 'https://via.placeholder.com/60?text=TH',
        ),
      ],
      directors: ['Christopher Nolan'],
      writers: ['Christopher Nolan'],
      runtime: '2h 28m',
      genres: ['Action', 'Adventure', 'Sci-Fi'],
    );
  }
}

class MovieDetailScreen extends StatefulWidget {
  final Map<String, String> movie;

  MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  final MovieDetails details = MovieDetails.sample();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildMovieDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildInfoRow('Director', details.directors.join(', ')),
          const SizedBox(height: 8),
          _buildInfoRow('Writers', details.writers.join(', ')),
          const SizedBox(height: 8),
          _buildInfoRow('Language', 'English'),
          const SizedBox(height: 8),
          _buildInfoRow('Country', 'USA, UK'),
          const SizedBox(height: 8),
          _buildInfoRow('Budget', '\$160 million'),
          const SizedBox(height: 8),
          _buildInfoRow('Box Office', '\$836.8 million'),

          // Synopsis Section
          const SizedBox(height: 24),
          const Text(
            'Synopsis',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            details.synopsis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.6,
            ),
          ),

          // Cast Section
          const SizedBox(height: 24),
          const Text(
            'Cast',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: details.cast.length,
              itemBuilder: (context, index) {
                final member = details.cast[index];
                return Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(member.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        member.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        member.role,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingsReviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    widget.movie['rating']!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('IMDb Rating'),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingBar('5 stars', 0.7),
                    _buildRatingBar('4 stars', 0.2),
                    _buildRatingBar('3 stars', 0.08),
                    _buildRatingBar('2 stars', 0.02),
                    _buildRatingBar('1 star', 0.0),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'User Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            'Amazing cinematography!',
            'The visual effects and storytelling are incredible. A masterpiece of modern cinema.',
            'John D.',
            5,
          ),
          const SizedBox(height: 12),
          _buildReviewCard(
            'Mind-bending plot',
            'Complex but rewarding. You need to watch it multiple times to catch all the details.',
            'Sarah M.',
            4,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
    String title,
    String review,
    String author,
    int rating,
  ) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.movie['imageUrl']!, fit: BoxFit.cover),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black26, Colors.black87],
                        stops: [0.3, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title, Thumbnail & Info Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          widget.movie['imageUrl']!,
                          width: 110,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.movie['title']!,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: details.genres
                                  .map((genre) => _buildInfoChip(genre))
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.movie['year']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 73, 70, 70),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  details.runtime,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.deepPurple,
                          unselectedLabelColor: Colors.grey,
                          indicator: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          indicatorColor: Colors.deepPurple,
                          tabs: const [
                            Tab(text: 'Movie Details'),
                            Tab(text: 'Ratings & Review'),
                          ],
                        ),
                        SizedBox(
                          height: 480,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildMovieDetailsTab(),
                                _buildRatingsReviewTab(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Book Ticket',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
