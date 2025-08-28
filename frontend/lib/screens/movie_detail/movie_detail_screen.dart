import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:frontend/models/cast_member.dart';
import '../../widgets/info_widgets.dart';
import '../../widgets/rating_bar_widget.dart';
import '../../widgets/review_card.dart';
import '../../widgets/gradient_button.dart';

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
}

class MovieDetailScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
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

  Widget _buildMovieDetailsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(label: 'Full Synopsis', value: widget.movie['synopsis']!),
          const SizedBox(height: 8),
          InfoRow(label: 'Casts', value: widget.movie['cast']!),
          const SizedBox(height: 8),
          InfoRow(label: 'Director', value: widget.movie['directors']!),
          const SizedBox(height: 8),
          InfoRow(label: 'Writers', value: widget.movie['writers']!),
          const SizedBox(height: 8),
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
                    RatingBarWidget(label: '5 stars', percentage: 0.7),
                    RatingBarWidget(label: '4 stars', percentage: 0.2),
                    RatingBarWidget(label: '3 stars', percentage: 0.08),
                    RatingBarWidget(label: '2 stars', percentage: 0.02),
                    RatingBarWidget(label: '1 star', percentage: 0.0),
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
          ReviewCard(
            title: 'Amazing cinematography!',
            review:
                'The visual effects and storytelling are incredible. A masterpiece of modern cinema.',
            author: 'John D.',
            rating: 5,
          ),
          const SizedBox(height: 12),
          ReviewCard(
            title: 'Mind-bending plot',
            review:
                'Complex but rewarding. You need to watch it multiple times to catch all the details.',
            author: 'Sarah M.',
            rating: 4,
          ),
        ],
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
              onPressed: () => Get.back(),
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
                            InfoRow(
                              label: 'Genres',
                              value: widget.movie['genres']!.join(', '),
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
                                  widget.movie['runtime']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating:
                                      double.tryParse(
                                        widget.movie['rating'] ?? '0',
                                      ) ??
                                      0,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  unratedColor: Colors.grey[300],
                                  itemCount: 5,
                                  itemSize: 20,
                                  direction: Axis.horizontal,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.movie['rating']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
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
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          labelColor: Colors.deepPurple,
                          unselectedLabelColor: Colors.grey,
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.deepPurple,
                            ),
                            insets: EdgeInsets.symmetric(horizontal: 16),
                          ),
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
              child: GradientButton(
                text: 'Book Ticket',
                onPressed: () {
                  Get.toNamed(AppRoutes.ticketBooking);
                },
                height: 56,
                borderRadius: BorderRadius.circular(16),
                icon: const Icon(
                  Icons.confirmation_number_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
