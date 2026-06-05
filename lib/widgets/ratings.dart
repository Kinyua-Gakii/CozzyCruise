import 'package:flutter/material.dart';

class RatingsPage extends StatelessWidget {
  final double rating;
  final int totalRatings;
  final List<Map<String, dynamic>> reviews;

  const RatingsPage({
    super.key,
    required this.rating,
    required this.totalRatings,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    // filter only reviews with actual comments
    final validReviews = reviews
        .where(
          (r) =>
              r['comment'] != null && r['comment'].toString().trim().isNotEmpty,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Ratings & Reviews")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildRatingSummary(),
            const SizedBox(height: 10),
            _buildRatingBreakdown(),
            const SizedBox(height: 10),
            _buildReviewsSection(validReviews),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              if (index < rating.floor()) {
                return const Icon(Icons.star, color: Colors.amber);
              } else if (index < rating) {
                return const Icon(Icons.star_half, color: Colors.amber);
              } else {
                return const Icon(Icons.star_border, color: Colors.amber);
              }
            }),
          ),

          const SizedBox(height: 6),

          Text(
            "$totalRatings ratings",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBreakdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(5, (index) {
          int star = 5 - index;

          // replace with backend
          double percent = (star == 5)
              ? 0.6
              : (star == 4)
              ? 0.25
              : (star == 3)
              ? 0.1
              : 0.03;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text("$star"),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 8),

                Expanded(
                  child: LinearProgressIndicator(value: percent, minHeight: 6),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildReviewsSection(List validReviews) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: validReviews.isEmpty
          ? const Center(
              child: Text(
                "No written reviews yet",
                style: TextStyle(color: Colors.grey),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reviews",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),

                ...validReviews.map((review) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 3),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // stars
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < review['rating']
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          review['comment'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
