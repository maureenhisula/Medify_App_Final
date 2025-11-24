import 'package:flutter/material.dart';
import 'result_screen.dart';
import 'favorites_manager.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: FavoritesManager.instance,
      builder: (context, _) {
        final favoritePlants = FavoritesManager.instance.favoritePlants;

        return Scaffold(
          backgroundColor: Colors.white,

          body: favoritePlants.isEmpty
              ? const Center(
                  child: Text(
                    "No favorite plants yet.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoritePlants.length,
                  itemBuilder: (context, index) {
                    final plant = favoritePlants[index];

                    return GestureDetector(
                      onTap: () {
                        // Only pass parameters that ResultScreen currently expects
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              plantResult: plant["displayName"] ?? "Unknown",
                              accuracy: 1.0,
                              plantImage: plant["image"],
                            ),
                          ),
                        );
                      },
                      child: _buildPlantCard(
                        image: plant["image"] ?? 'assets/plant.png',
                        name: plant["displayName"] ?? "Unknown",
                        scientificName: plant["scientificName"] ?? "Unknown",
                        commonNames: plant["localName"] ?? "Unknown",
                        englishName: plant["englishName"] ?? "Unknown",
                        onRemove: () {
                          FavoritesManager.instance.removeFavorite(plant);
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildPlantCard({
    required String image,
    required String name,
    required String scientificName,
    required String commonNames,
    required String englishName,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.08,
            ), // Updated to avoid deprecated withOpacity
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Scientific name: ',
                              style: TextStyle(fontStyle: FontStyle.normal),
                            ),
                            TextSpan(
                              text: scientificName,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        "Common name: $commonNames",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
