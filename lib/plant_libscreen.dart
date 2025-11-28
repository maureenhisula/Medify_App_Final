import 'package:flutter/material.dart';
import 'result_screen.dart';

class PlantLibScreen extends StatelessWidget {
  final String? searchQuery; // ✅ Add this

  const PlantLibScreen({super.key, this.searchQuery}); // ✅ Accept searchQuery
  // ✅ Accept searchQuery

  @override
  Widget build(BuildContext context) {
    // Get the plantDetails map from ResultScreen
    final plantDetails = _ResultScreenPlantDetails.plantDetails;

    // Filter out the "Other" plant
    var filteredPlants = plantDetails.entries
        .where((entry) => entry.key != "Other")
        .toList();

    // ✅ Filter based on searchQuery if provided
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      filteredPlants = filteredPlants
          .where(
            (entry) =>
                entry.key.toLowerCase().contains(searchQuery!.toLowerCase()) ||
                (entry.value["commonNames"] as String).toLowerCase().contains(
                  searchQuery!.toLowerCase(),
                ),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: filteredPlants.map((entry) {
          final name = entry.key;
          final details = entry.value;

          return _buildPlantCard(
            context: context,
            name: name,
            scientificName: details["scientificName"] ?? "Unknown",
            commonName: details["commonNames"] ?? "Unknown",
            image: details["image"] ?? "assets/images/plant.png",
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPlantCard({
    required BuildContext context,
    required String image,
    required String name,
    required String scientificName,
    required String commonName,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              plantResult: name,
              accuracy: 1.0,
              plantImage: image,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
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
                      "Common name: $commonName",
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
      ),
    );
  }
}

// Helper class to expose the plantDetails map from ResultScreen
class _ResultScreenPlantDetails {
  static final Map<String, Map<String, dynamic>> plantDetails = const {
    "Aeugbati": {
      "commonNames": "Aeugbati, Alugbati",
      "scientificName": "Basella alba",
      "image": "assets/images/alugbati.png",
    },
    "Akapulko": {
      "commonNames": "Akapulko, Palochina",
      "scientificName": "Senna alata",
      "image": "assets/images/akapulko.png",
    },
    "Ampalaya": {
      "commonNames": "Ampalaya, Maragoso",
      "scientificName": "Momordica charantia",
      "image": "assets/images/ampalaya.png",
    },
    "Aloe Vera": {
      "commonNames": "Aloe, Sabila",
      "scientificName": "Aloe barbadensis Miller ",
      "image": "assets/images/aloevera.png",
    },
    "Adgaw": {
      "commonNames": "Adgaw, Alagaw",
      "scientificName": "Premna odorata Blanco",
      "image": "assets/images/argaw.png",
    },

    "Bayawas": {
      "commonNames": "Bayawas, Bayabas",
      "scientificName": "Psidium guajava",
      "image": "assets/images/bayabas.png",
    },
    "Buyo": {
      "commonNames": "Buyo, Ikmo",
      "scientificName": "Piper betle",
      "image": "assets/images/buyo.png",
    },
    "Cassava": {
      "commonNames": "Balinghoy, Kamoteng kahoy",
      "scientificName": "Manihot esculenta Crantz",
      "image": "assets/images/cassava.png",
    },
    "Damong Maria": {
      "commonNames": "Damong Maria, Hilba",
      "scientificName": "Artemisia vulgaris",
      "image": "assets/images/damong maria.png",
    },

    "Kataka-taka": {
      "commonNames": "Katakataka, Anheliko",
      "scientificName": "Kalanchoe pinnata",
      "image": "assets/images/kataka-taka.png",
    },
    "Lagundi": {
      "commonNames": "Lagundi, Turagay",
      "scientificName": "Vitex negundo",
      "image": "assets/images/lagundi.png",
    },
    "Lampunaya": {
      "commonNames": "Lampunaya, Mayana",
      "scientificName": "Plectranthus Scutellarioides",
      "image": "assets/images/eampunaya.png",
    },
    "Malunggay": {
      "commonNames": "Malunggay, Marunggay",
      "scientificName": "Moringa oleifera",
      "image": "assets/images/malunggay.png",
    },

    "Oregano": {
      "commonNames": "Oregano, Klabo, Suganda",
      "scientificName": "Coleus amboinicus",
      "image": "assets/images/klabo.png",
    },

    "Sambong": {
      "commonNames": "Sambong, Hinalib-on",
      "scientificName": "Blumea balsamifera",
      "image": "assets/images/sambong.png",
    },
    "Takip Kuhol": {
      "commonNames": "Takip Kuhol, Gotu Kola",
      "scientificName": "Centella asiatica",
      "image": "assets/images/takip kuhol.png",
    },
    "Tanglad": {
      "commonNames": "Tanglad",
      "scientificName": "Cymbopogon citratus",
      "image": "assets/images/tanglad.png",
    },
    "Tawa-Tawa": {
      "commonNames": "Tawa-Tawa, Gatas-gatas",
      "scientificName": "Euphorbia hirta",
      "image": "assets/images/tawa.png",
    },
    "Tsaang Gubat": {
      "commonNames": "Tsaang Gubat",
      "scientificName": "Ehretia microphylla",
      "image": "assets/images/tsa.png",
    },
    "Ulasimang Bato": {
      "commonNames": "Ulasimang Bato, Pansit-pansitan",
      "scientificName": "Peperomia pellucida",
      "image": "assets/images/pansit.png",
    },
  };
}
