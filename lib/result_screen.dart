import 'package:flutter/material.dart';
import 'favorites_manager.dart';

class ResultScreen extends StatefulWidget {
  final String plantResult;
  final double accuracy;
  final String? plantImage;

  const ResultScreen({
    super.key,
    required this.plantResult,
    required this.accuracy,
    this.plantImage,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isFavorite = false;

  // Track expansion state for each section
  bool isMedicinalExpanded = false;
  bool isPreparationExpanded = false;
  bool isHabitatExpanded = false;
  bool isCautionsExpanded = false;

  final Map<String, Map<String, dynamic>> plantDetails = {
    "Aeugbati": {
      "commonNames": "Aeugbati, Alugbati",
      "scientificName": "Basella alba",
      "englishName": "Malabar Spinach",
      "description":
          "It is a leafy green vegetable and it is a member of the Basellaceae family. It has nothing to do with spinach. When raw, it has fleshy, juicy leaves that taste like citrus and pepper. It tastes like spinach when cooked. Malabar spinach is a popular nutritious vegetable that acts as a natural coolant.",
      "medicinalUse": [
        "Improves eyesight - Rich in antioxidants (vitamins A & C, beta-carotene, zeaxanthin, lutein) that protect retinal cells from free-radical damage and support healthy vision.",
        "Aids digestion - The fiber in basella provides roughage that aids proper digestion, improves nutrient absorption, and helps lower the risk of colorectal cancer through detoxification.",
        "Prevents anemia - Folate-rich leaves aid in the absorption of vitamin B12 and iron, supporting red blood cell production and preventing anemia.",
      ],
      "preparation": [
        "While young, tender leaves of this leafy green can be eaten raw in salads, it is usually more common to cook the leaves to improve their texture and flavour. Cooking also helps to reduce oxalates present in raw leaves.",
      ],
      "habitat": [
        "It grows well in areas under full sunlight and hot, humid climates.",
      ],
      "cautions": ["Generally safe as food; wash to remove contaminants."],
      "image": "assets/images/alugbati.png",
      "similarImages": [
        "assets/images/alugbati1.jpg",
        "assets/images/alugbati2.jpg",
        "assets/images/alugbati3.jpg",
      ],
    },
    "Akapulko": {
      "commonNames": "Akapulko, Palochina, ",
      "scientificName": "Senna alata",
      "englishName": "Candle Bush",
      "description":
          "The akapulko plant commonly known as Senna or Ringworm Bush is a small tree known to contain chrysophanol acid. Chrysophanol acid has been shown to be effective when treating conditions such as scabies, eczema, insect bites and other skin infections.",
      "medicinalUse": [
        "Skin conditions - The juice from crushed leaves is applied externally to treat ringworm, scabies, eczema, and itchiness.",
        "Internal ailments - A decoction made by boiling the leaves can be consumed to help with bronchitis, asthma, or act as a natural laxative.",
        "Minor aches - A warm decoction can be used as a gargle to relieve sore throats or toothaches.",
      ],
      "preparation": [
        "External use - Crush the fresh leaves and apply the juice to the affected skin 1 to 2 times a day, as recommended by the DOH.",
        "Internal use (decoction) - Boil the chopped leaves for about 15 minutes, allow it to cool, and strain before drinking.",
      ],
      "habitat": ["Tropical gardens, roadsides, waste places"],
      "cautions": [
        "Not for pregnant and breastfeeding women.",
        "Stop use if adverse reaction occurs.",
      ],
      "image": "assets/images/akapulko.png",
      "similarImages": [
        "assets/images/akapulko1.jpg",
        "assets/images/akapulko2.jpg",
        "assets/images/akapulko3.jpg",
      ],
    },
    "Aloe Vera": {
      "commonNames": "Aloe, Sabila",
      "scientificName": "Aloe barbadensis Miller",
      "englishName": "Aloe Vera",
      "description":
          "Aloe vera is a succulent perennial herb belonging to the Asphodelaceae family. It has thick, fleshy green leaves arranged in a rosette pattern, with small teeth along the edges and a clear, cooling gel inside. This gel is rich in vitamins, minerals, enzymes, and amino acids that contribute to its healing properties.",
      "medicinalUse": [
        "Burns and Wounds: Gel soothes and promotes healing of minor burns, cuts, and abrasions.",
        "Skin Care: Hydrates skin, helps reduce acne, rashes, and sunburn discomfort.",
      ],
      "preparation": [
        "Topical: Apply the clear inner gel directly to affected skin areas.",
        "Cream or Ointment: Mix the gel into skin-care formulations for burns, dryness, or irritation.",
      ],
      "habitat": [
        "Commonly cultivated in tropical, subtropical, and arid climates worldwide.",
        "Grows best in sandy, well-drained soil under full sunlight.",
      ],
      "cautions": [
        "Some individuals may experience skin irritation or allergic reactions.",
        "Do not ingest the yellow latex beneath the leaf skin; it can cause cramps or diarrhea.",
      ],
      "image": "assets/images/aloevera.png",
      "similarImages": [
        "assets/images/aloevera1.jpg",
        "assets/images/aloevera2.jpg",
        "assets/images/aloevera3.jpg",
      ],
    },
    "Ampalaya": {
      "commonNames": "Ampalaya, Maragoso",
      "scientificName": "Momordica charantia",
      "englishName": "Bitter Melon",
      "description":
          "Ampalaya (bitter gourd), which is recognized by the Department of Health (DOH) in the Philippines as one of its 10 approved herbal medicines. It is primarily promoted for its potential benefits in managing mild, non-insulin-dependent type 2 diabetes by helping to lower blood sugar levels.",
      "medicinalUse": [
        "Diabetes: Lowers blood sugar levels (used in type-2 diabetes adjunctively in studies).",
        "Digestive: Stimulates appetite, relieves indigestion in folk practice.",
        "Skin: Leaf juice used for minor wounds and skin diseases (topical use).",
      ],
      "preparation": [
        "Juice: Fresh fruit or leaves juiced and taken daily (in small, diluted amounts)",
        "Tea: Dried leaves boiled in water (decoction / infusion)",
        "Culinary: Cooked as vegetable dishes (to reduce bitterness and ingest safely)",
      ],
      "habitat": ["Cultivated in farms, home gardens"],
      "cautions": [
        "May cause hypoglycemia if combined with diabetes medications",
        "Not recommended for pregnant women (possible uterine effects in high doses)",
      ],
      "image": "assets/images/ampalaya.png",
      "similarImages": [
        "assets/images/ampalaya1.jpg",
        "assets/images/ampalaya2.jpg",
        "assets/images/ampalaya3.jpg",
      ],
    },
    "Adgaw": {
      "commonNames": "Adgaw, Alagaw",
      "scientificName": "Premna odorata",
      "englishName": "Fragrant Premna",
      "description":
          "Adgaw is a small tree or shrub with aromatic leaves used in traditional healing for coughs, colds, and fever. The leaves when crushed release a mild fragrance and are believed to help respiratory and digestive symptoms.",
      "medicinalUse": [
        "Respiratory: Relieves coughs and asthma (used in decoctions or as steam inhalation in folk practice).",
        "Fever: Helps reduce body heat (used as febrifuge in traditional medicine).",
        "Wound care: Used as a disinfectant wash or poultice in folk tradition.",
      ],
      "preparation": [
        "Decoction: Boil leaves in water and drink as tea or use as wash",
        "Poultice: Crushed leaves applied to wounds or inflamed areas",
        "Steam inhalation: Boil leaves, inhale steam to ease congestion",
      ],
      "habitat": ["Forests, lowland rural areas, near dwellings"],
      "cautions": ["Use in moderation.", "Not recommended for pregnant women."],
      "image": "assets/images/argaw.png",
      "similarImages": [
        "assets/images/argaw1.jpg",
        "assets/images/argaw2.jpg",
        "assets/images/argaw3.jpg",
      ],
    },
    "Bayawas": {
      "commonNames": "Bayawas, Bayabas",
      "scientificName": "Psidium guajava",
      "englishName": "Guava",
      "description":
          "Bayabas is a small tree cultivated for its fruit and medicinal leaves. It is well known for its antimicrobial, anti-inflammatory, and astringent properties in traditional medicine.",
      "medicinalUse": [
        "Oral / Dental: Leaf decoction for mouthwash against toothache and gum disease",
        "Diarrhea / Gastrointestinal: Tea made from leaves helps relieve diarrhea by inhibiting pathogens",
        "Wound healing / Skin: Crushed leaves applied to cuts and abrasions to promote healing",
      ],
      "preparation": [
        "Decoction: Boil leaves and use as tea or wash",
        "Mouthwash: Gargle cooled decoction",
        "Poultice: Fresh leaves crushed and applied directly to wounds or inflamed skin",
      ],
      "habitat": ["Cultivated in home gardens, farms, tropical lowlands"],
      "cautions": [
        "Avoid excessive consumption of raw leaves.",
        "Allergic individuals should test first.",
      ],
      "image": "assets/images/bayabas.png",
      "similarImages": [
        "assets/images/bayabas1.jpg",
        "assets/images/bayabas2.jpg",
        "assets/images/bayabas3.jpg",
      ],
    },
    "Buyo": {
      "commonNames": "Buyo, Ikmo",
      "scientificName": "Piper betle",
      "englishName": "Betel Leaf",
      "description":
          "Buyo (Piper betle) is a climbing vine with glossy, heart-shaped leaves. Traditionally, its leaves are chewed (with areca nut and lime) in cultural practice, but it also has medicinal properties, especially for oral, dermatologic, and digestive health.",
      "medicinalUse": [
        "Oral: Fresh leaves chewed to strengthen gums, freshen breath, and alleviate toothache",
        "Digestive: Helps relieve indigestion, flatulence, and spasms",
        "Antiseptic: Used externally on wounds or skin infections to inhibit microbes",
      ],
      "preparation": [
        "Chewing: Fresh leaves (often with lime) to benefit gums/teeth (cautiously)",
        "Poultice: Crushed leaves applied to wounds or inflamed skin",
        "Decoction: Boil leaves for gargle or wash in mild infections",
      ],
      "habitat": ["Tropical gardens, shaded trellises, humid climates"],
      "cautions": [
        "Prolonged chewing with areca nut may cause oral lesions/cancer.",
        "Avoid excessive internal use (especially concentrated extracts).",
      ],
      "image": "assets/images/buyo.png",
      "similarImages": [
        "assets/images/buyo1.jpg",
        "assets/images/buyo2.jpg",
        "assets/images/buyo3.jpg",
      ],
    },
    "Cassava": {
      "commonNames": "Balinghoy, Kamoteng Kahoy",
      "scientificName": "Manihot esculenta",
      "englishName": "Cassava",
      "description":
          "Cassava is a root crop that serves as a staple food in many tropical countries. It produces large starchy tubers, and leaves may also be used in traditional remedies when properly processed.",
      "medicinalUse": [
        "Energy Source: Provides carbohydrates for strength and endurance (nutritional)",
        "Skin Treatment: Used externally for skin irritation and wounds in folk practice",
      ],
      "preparation": [
        "Boiled: Roots are peeled, boiled (or processed) and eaten safely",
        "Poultice: Leaves (after thorough cooking) crushed and applied to affected skin areas",
      ],
      "habitat": ["Tropical regions, farmlands, and backyard gardens"],
      "cautions": [
        "Raw cassava contains cyanogenic glycosides — must be properly processed (soak / ferment / boil).",
        "Leaves also need thorough cooking before use.",
      ],
      "image": "assets/images/cassava.png",
      "similarImages": [
        "assets/images/cassava1.jpg",
        "assets/images/cassava2.jpg",
        "assets/images/cassava3.jpg",
      ],
    },
    "Damong Maria": {
      "commonNames": "Damong Maria, Hilba",
      "scientificName": "Artemisia vulgaris",
      "englishName": "Mugwort",
      "description":
          "Damong Maria (Artemisia vulgaris) is an aromatic shrub traditionally used in Philippine folk medicine for digestive, menstrual, respiratory, and pain relief purposes. It has feathery leaves and an aromatic smell when crushed.",
      "medicinalUse": [
        "Digestive: Relieves stomachache, bloating, indigestion",
        "Reproductive / Menstrual: Helps regulate menstruation and relieve cramps",
        "Pain relief: Used for body aches, nerve pain, and as a mild analgesic",
      ],
      "preparation": [
        "Tea / Infusion: Dried leaves steeped in hot water and consumed",
        "Poultice: Warm leaves crushed and applied to painful areas",
        "Steam inhalation: Leaves boiled and steam inhaled for respiratory relief",
      ],
      "habitat": ["Fields, grasslands, roadsides, cooler or elevated areas"],
      "cautions": [
        "Not recommended for pregnant women.",
        "High doses may affect nervous system.",
      ],
      "image": "assets/images/damong maria.png",
      "similarImages": [
        "assets/images/damong maria1.jpg",
        "assets/images/damong maria2.jpg",
        "assets/images/damong maria3.jpg",
      ],
    },
    "Kataka-taka": {
      "commonNames": "Katakataka, Anheliko",
      "scientificName": "Kalanchoe pinnata",
      "englishName": "Leaf of Life, Miracle Plant",
      "description":
          "Katakataka (Kalanchoe pinnata) is a succulent perennial whose leaves can sprout new plantlets at the edges. It grows readily in tropical and subtropical climates and is well known in folk medicine for its cooling, healing, and anti-inflammatory properties.",
      "medicinalUse": [
        "Respiratory: Relieves cough, bronchitis, sore throat (leaf infusions / decoctions used)",
        "Skin: Poultice for boils, ulcers, wounds, insect bites",
        "Anti-inflammatory: Reduces swelling and pain in joints and soft tissues",
      ],
      "preparation": [
        "Poultice: Crushed fresh leaves applied to skin wounds or inflammation",
        "Decoction / Tea: Boil leaves in water and drink (for cough or internal use, cautiously)",
        "Topical extract / compress: Leaf extract used externally on inflamed areas",
      ],
      "habitat": ["Gardens, rocky soils, edges of woods, potted environments"],
      "cautions": [
        "Avoid excessive internal use (possible cardiac glycoside-type effects in some species).",
        "Not recommended for pregnant women.",
        "Test topical use on small skin area first (possible irritation).",
      ],
      "image": "assets/images/kataka-taka.png",
      "similarImages": [
        "assets/images/kataka-taka1.jpg",
        "assets/images/kataka-taka2.jpg",
        "assets/images/kataka-taka2.jpg",
      ],
    },
    "Oregano": {
      "commonNames": "Oregano, Klabo, Suganda",
      "scientificName": "Coleus amboinicus",
      "englishName": "Cuban Oregano",
      "description":
          "Oregano (Coleus amboinicus) is a fragrant perennial herb from the mint family, widely known as both a culinary spice and a traditional medicinal plant. It has fleshy aromatic leaves and is rich in essential oils and phenolic compounds that provide antimicrobial, anti-inflammatory, and antioxidant properties.",
      "medicinalUse": [
        "Respiratory: Eases asthma, acts as expectorant, relieves coughs",
        "Skin: Anti-inflammatory and antimicrobial for rashes, insect bites, minor infections",
      ],
      "preparation": [
        "Tea / Infusion: 1 tsp dried leaves/flowers per cup, steep 10 minutes",
        "Poultice: Crushed fresh leaves applied to affected area",
        "Steam inhalation: Boil leaves and inhale vapors (for respiratory symptoms)",
      ],
      "habitat": [
        "Fields, wild meadows, cultivated gardens, tropical climates",
      ],
      "cautions": [
        "May interact with blood thinners or anticoagulant therapy.",
        "Essential oil or concentrated ingestion can be toxic if misused.",
      ],
      "image": "assets/images/klabo.png",
      "similarImages": [
        "assets/images/klabo1.jpeg",
        "assets/images/klabo2.jpeg",
        "assets/images/klabo3.jpeg",
      ],
    },
    "Lagundi": {
      "commonNames": "Lagundi, Turagay",
      "scientificName": "Vitex negundo",
      "englishName": "Five-leaved Chaste Tree",
      "description":
          "Lagundi is a shrub native to the Philippines, with leaves composed of five narrow leaflets and aromatic properties. It grows in disturbed sites, gardens, and open areas.",
      "medicinalUse": [
        "Respiratory: Relieves cough, asthma, bronchitis by reducing symptoms and improving airway function",
        "Fever: Used in folklore and some trials as antipyretic support",
        "Pain relief: Mild analgesic and anti-inflammatory for aches and joint pain",
      ],
      "preparation": [
        "Decoction: Boil leaves in water, strain and drink (for cough / respiratory relief)",
        "Poultice: Crushed leaves applied to painful skin areas or joints",
        "Steam inhalation: Leaves boiled and steam inhaled",
      ],
      "habitat": ["Forests, gardens, roadside areas, rural zones"],
      "cautions": ["Use in moderation."],
      "image": "assets/images/lagundi.png",
      "similarImages": [
        "assets/images/lagundi1.jpg",
        "assets/images/lagundi2.jpg",
        "assets/images/lagundi3.jpg",
      ],
    },
    "Lampunaya": {
      "commonNames": "Lampunaya, Mayana",
      "scientificName": "Plectranthus amboinicus",
      "englishName": "Mayana, Coleus.",
      "description":
          "Lampunaya (often *Plectranthus amboinicus*) is a fleshy aromatic herb with broad, succulent leaves and strong aroma. It is commonly used in Filipino and Southeast Asian folk medicine for respiratory and digestive complaints.",
      "medicinalUse": [
        "Respiratory: Relieves cough, sore throat, and congestion",
        "Digestive: Helps reduce stomach discomfort, bloating, and gas",
        "Anti-inflammatory: Used for swelling, muscle pain, and topical ailments",
      ],
      "preparation": [
        "Decoction: Boil leaves in water and drink (tea)",
        "Poultice: Crushed leaves applied to chest, throat, or painful areas",
        "Steam inhalation: Boil leaves and inhale vapor (for respiratory symptoms)",
      ],
      "habitat": ["Moist shaded gardens, home yards, tropical climates"],
      "cautions": [
        "Use in moderation, especially for internal use.",
        "Test small doses first (possible sensitivity or interaction).",
      ],
      "image": "assets/images/eampunaya.png",
      "similarImages": [
        "assets/images/eampunaya1.jpg",
        "assets/images/eampunaya2.jpg",
        "assets/images/eampunaya3.jpg",
      ],
    },
    "Malunggay": {
      "commonNames": "Malunggay, Marunggay",
      "scientificName": "Moringa oleifera",
      "englishName": "Moringa",
      "description":
          "Malunggay is a nutrient-rich plant known for its leaves, pods, and seeds. The leaves are especially valued for their high vitamin, mineral, and antioxidant content. It grows quickly and is widely cultivated in tropical and subtropical regions.",
      "medicinalUse": [
        "Nutritional Supplement: Rich in vitamins A, C, and minerals, supports general health and combats malnutrition",
        "Lactation Aid: Traditionally used to promote milk production in breastfeeding mothers",
        "Antioxidant / Anti-inflammatory: Helps reduce oxidative stress and inflammation",
      ],
      "preparation": [
        "Soup: Fresh leaves added to dishes like tinola or other soups",
        "Tea: Dried leaves steeped in hot water to make infusion",
        "Powder: Dried leaf powder taken in small doses or added to foods",
      ],
      "habitat": ["Tropical and subtropical backyards, gardens, rural areas"],
      "cautions": [
        "Generally safe in dietary amounts; excessive consumption may cause stomach upset in some individuals",
      ],
      "image": "assets/images/malunggay.png",
      "similarImages": [
        "assets/images/malunggay1.jpg",
        "assets/images/malunggay2.jpg",
        "assets/images/malunggay3.jpg",
      ],
    },
    "Sambong": {
      "commonNames": "Sambong, Hinalib-on",
      "scientificName": "Blumea balsamifera",
      "englishName": "Blumea camphor",
      "description":
          "Sambong is a shrub commonly used in Filipino traditional medicine. It has aromatic leaves and is widely known for its diuretic and urolithiasis (kidney stone) supportive properties.",
      "medicinalUse": [
        "Kidney / Urolithiasis: Supports passage of kidney stones, increases urine output (diuretic effect in research / PCHRD herbal formulations).",
        "Blood pressure support: Folk and preliminary use in hypertension management (via diuretic effect)",
        "Respiratory: Mild use for cough / cold symptom relief in traditional practice",
      ],
      "preparation": [
        "Tea / Infusion: Steep leaves in hot water for 10 minutes and drink",
        "Poultice: Crushed leaves applied to affected skin or to help draw out impurities",
        "Decoction: Boil leaves and consume or use as wash",
      ],
      "habitat": ["Fields, open areas, gardens, secondary growth"],
      "cautions": [
        "Use in moderation (diuretic effect may affect fluid/electrolyte balance).",
        "May interact with antihypertensive or diuretic medications.",
      ],
      "image": "assets/images/sambong.png",
      "similarImages": [
        "assets/images/sambong1.jpg",
        "assets/images/sambong2.jpg",
        "assets/images/sambong3.jpg",
      ],
    },
    "Takip Kuhol": {
      "commonNames": "Takip Kuhol, Gotu Kola",
      "scientificName": "Centella asiatica",
      "englishName": "Indian Pennywort",
      "description":
          "Takip Kuhol (Centella asiatica), also known as Gotu Kola, is a small, creeping perennial herb commonly found in moist, shaded areas. It has rounded leaves and is highly valued in traditional medicine across Asia. It is believed to improve memory, promote wound healing, and support skin health.",
      "medicinalUse": [
        "Cognitive: Enhances memory and concentration (neuroprotective and cognitive support in studies)",
        "Skin: Promotes wound healing, reduces scars and improves skin integrity",
        "Circulatory: Improves blood flow and supports varicose veins / venous insufficiency",
        "Anti-inflammatory: Helps relieve arthritis and swelling",
      ],
      "preparation": [
        "Tea / Infusion: Fresh leaves boiled in water, consumed daily",
        "Poultice: Crushed leaves applied directly to wounds or skin issues",
        "Juice: Fresh leaf extract taken in small amounts for general health",
      ],
      "habitat": ["Moist soils, rice fields, shaded gardens, wetlands"],
      "cautions": [
        "Excessive intake may cause headaches or dizziness.",
        "May interact with sedatives, thyroid medications, and blood-thinning drugs.",
      ],
      "image": "assets/images/takip kuhol.png",
      "similarImages": [
        "assets/images/takip kuhol1.jpg",
        "assets/images/takip kuhol2.jpg",
        "assets/images/takip kuhol3.jpg",
      ],
    },
    "Tanglad": {
      "commonNames": "Tanglad",
      "scientificName": "Cymbopogon citratus",
      "englishName": "Lemongrass",
      "description":
          "Tanglad is a tall, perennial grass known for its lemon-like aroma and narrow leaves. It is used widely in cooking, herbal teas, and folk medicine in tropical climates.",
      "medicinalUse": [
        "Digestive: Eases bloating, gas, and stomach discomfort",
        "Calming / Relaxation: Reduces stress and may promote sleep when used as tea",
        "Antimicrobial / Antifungal: Topical or mild internal use for minor infections",
      ],
      "preparation": [
        "Tea / Infusion: Steep leaves in hot water for 10 minutes and drink",
        "Poultice: Crushed leaves applied to affected skin areas",
        "Aromatherapy / Steam: Use in steam inhalation or diluted topical oil",
      ],
      "habitat": ["Gardens, home yards, tropical climates, well-drained soils"],
      "cautions": [
        "May cause mild allergic reactions in sensitive individuals (skin irritation).",
        "Avoid ingesting concentrated essential oil.",
      ],
      "image": "assets/images/tanglad.png",
      "similarImages": [
        "assets/images/tanglad1.jpg",
        "assets/images/tanglad2.jpg",
        "assets/images/tanglad3.jpg",
      ],
    },
    "Tawa-Tawa": {
      "commonNames": "Tawa-Tawa, Gatas-gatas",
      "scientificName": "Euphorbia hirta",
      "englishName": "Asthma Herb",
      "description":
          "Tawa-Tawa is a common tropical weed with small hairy leaves and milky sap. It is widely used in folk medicine in the Philippines for supportive uses in dengue and respiratory ailments.",
      "medicinalUse": [
        "Blood health: May help increase platelet count in dengue (supportive, not definitive)",
        "Respiratory: Used for asthma, bronchitis, cough relief",
        "Fever / Diarrhea: Used as antipyretic or antidiarrheal remedy in folk practice",
      ],
      "preparation": [
        "Tea: Boil leaves in water and drink 2–3 times daily",
        "Juice: Fresh leaf juice consumed in small amounts (with care)",
        "Poultice / Wash: Crushed leaf applied or decoction used as wash for skin or bleeding",
      ],
      "habitat": ["Roadsides, fields, open disturbed areas, tropical climates"],
      "cautions": [
        "Avoid excess use: may irritate stomach or mucosa.",
        "Do not rely on it alone in serious illness (especially dengue) — seek medical care.",
        "Milk sap may irritate skin/eyes — handle with caution.",
      ],
      "image": "assets/images/tawa.png",
      "similarImages": [
        "assets/images/tawa1.jpg",
        "assets/images/tawa2.jpg",
        "assets/images/tawa3.jpg",
      ],
    },
    "Tsaang Gubat": {
      "commonNames": "Tsaang Gubat",
      "scientificName": "Ehretia microphylla",
      "englishName": "Wild Tea",
      "description":
          "Tsaang Gubat is a shrub native to the Philippines, used traditionally as an herbal tea. It has small leaves and often grows in forest edges or shaded areas.",
      "medicinalUse": [
        "Digestive aid: Relieves stomach cramp, diarrhea, and general GI discomfort",
        "Skin health: Used to wash wounds, treat rashes, and as topical wash",
        "Mouthwash / Sore throat: Cooled decoction used for oral rinses",
      ],
      "preparation": [
        "Tea: Boil leaves in water for 5–10 minutes and drink (infusion / decoction)",
        "Poultice: Crushed leaves applied to affected skin areas",
        "Wash: Use cooled leaf decoction externally on rashes or wounds",
      ],
      "habitat": ["Forest margins, shaded gardens, tropical lowland regions"],
      "cautions": [
        "Generally safe for short use; for prolonged or internal uses consult physician",
      ],
      "image": "assets/images/tsa.png",
      "similarImages": [
        "assets/images/tsa1.jpg",
        "assets/images/tsa2.jpg",
        "assets/images/tsa3.jpg",
      ],
    },
    "Ulasimang Bato": {
      "commonNames": "Ulasimang Bato, Pansit-pansitan",
      "scientificName": "Peperomia pellucida",
      "englishName": "Shiny Bush",
      "description":
          "Ulasimang Bato is a small succulent herb with translucent, heart-shaped leaves, often growing in moist shaded areas. It is a common plant in Philippine folk medicine for reducing inflammation and urinary problems.",
      "medicinalUse": [
        "Anti-inflammatory: Reduces joint pain, swelling, gout, and arthritis",
        "Diuretic / Urinary: Helps with mild urinary complaints and flushing",
        "Skin: Used topically in poultices for wounds or skin irritation",
      ],
      "preparation": [
        "Salad / Fresh: Fresh leaves eaten raw or added to salads (washed)",
        "Tea: Boil leaves and drink as infusion",
        "Poultice: Crushed leaves applied directly to inflamed areas",
      ],
      "habitat": ["Gardens, moist soil, shaded areas, tropical climates"],
      "cautions": [
        "Safe in moderate amounts; avoid very high doses or unverified concentrated extracts",
      ],
      "image": "assets/images/pansit.png",
      "similarImages": [
        "assets/images/pansit1.jpg",
        "assets/images/pansit2.jpg",
        "assets/images/pansit3.jpg",
      ],
    },
  };

  void _showFullImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find matching plant or create a default one
    MapEntry<String, Map<String, dynamic>>? plantEntry;

    try {
      plantEntry = plantDetails.entries.firstWhere(
        (entry) =>
            entry.key.toLowerCase() == widget.plantResult.trim().toLowerCase(),
      );
    } catch (e) {
      // If plant not found, create a default entry
      plantEntry = MapEntry(widget.plantResult, {
        "commonNames": "Unknown",
        "scientificName": "Not available",
        "englishName": "Unknown",
        "description": "Plant information not available in database.",
        "medicinalUse": ["Information not available"],
        "preparation": ["Information not available"],
        "habitat": ["Information not available"],
        "cautions": ["Please consult with a healthcare professional"],
        "image": "assets/images/placeholder.png",
        "similarImages": [],
      });
    }

    final plant = plantEntry.value;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar with white background & dynamic title
            SliverAppBar(
              pinned: true,
              floating: false,
              expandedHeight: 270,
              backgroundColor: Colors.white,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final settings = context
                      .dependOnInheritedWidgetOfExactType<
                        FlexibleSpaceBarSettings
                      >();
                  final t = settings?.currentExtent ?? 0;
                  final minExtent = settings?.minExtent ?? 0;
                  final visible = t <= minExtent + 20;

                  return AnimatedOpacity(
                    opacity: visible ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      widget.plantResult,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: GestureDetector(
                  onTap: () => _showFullImage(
                    context,
                    widget.plantImage ?? plant["image"],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      widget.plantImage ?? plant["image"],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ),

            // White panel with rounded corners containing all info
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plant Name
                    Text(
                      widget.plantResult,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 28, 110, 31),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Scientific Name
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "Scientific name: "),
                          TextSpan(
                            text: plant["scientificName"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 28, 110, 31),
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Common Name
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "Common name: "),
                          TextSpan(
                            text: plant["commonNames"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 28, 110, 31),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 4),
                    // English Name
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "English Name: "),
                          TextSpan(
                            text: plant["englishName"],
                            style: const TextStyle(
                              color: Color.fromARGB(255, 28, 110, 31),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "DESCRIPTION",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      plant["description"],
                      style: const TextStyle(height: 1.4),
                    ),
                    const SizedBox(height: 20),

                    // Expandable Medicinal Use Section
                    if ((plant["medicinalUse"] as List).isNotEmpty)
                      _buildExpandableSection(
                        icon: Icons.local_hospital,
                        title: "Medicinal use",
                        items: List<String>.from(plant["medicinalUse"]),
                        isExpanded: isMedicinalExpanded,
                        onTap: () {
                          setState(() {
                            isMedicinalExpanded = !isMedicinalExpanded;
                          });
                        },
                        color: Colors.green,
                      ),

                    const SizedBox(height: 16),

                    // Expandable Preparation Section
                    if ((plant["preparation"] as List).isNotEmpty)
                      _buildExpandableSection(
                        icon: Icons.local_cafe,
                        title: "Preparation",
                        items: List<String>.from(plant["preparation"]),
                        isExpanded: isPreparationExpanded,
                        onTap: () {
                          setState(() {
                            isPreparationExpanded = !isPreparationExpanded;
                          });
                        },
                        color: Colors.green,
                      ),

                    const SizedBox(height: 16),

                    // Expandable Habitat Section
                    if ((plant["habitat"] as List).isNotEmpty)
                      _buildExpandableSection(
                        icon: Icons.landscape,
                        title: "Habitat",
                        items: List<String>.from(plant["habitat"]),
                        isExpanded: isHabitatExpanded,
                        onTap: () {
                          setState(() {
                            isHabitatExpanded = !isHabitatExpanded;
                          });
                        },
                        color: Colors.green,
                      ),

                    const SizedBox(height: 16),

                    // Expandable Cautions Section
                    if ((plant["cautions"] as List).isNotEmpty)
                      _buildExpandableSection(
                        icon: Icons.warning,
                        title: "Cautions",
                        items: List<String>.from(plant["cautions"]),
                        isExpanded: isCautionsExpanded,
                        onTap: () {
                          setState(() {
                            isCautionsExpanded = !isCautionsExpanded;
                          });
                        },
                        color: Colors.orange,
                      ),

                    const SizedBox(height: 20),
                    const Text(
                      "SIMILAR IMAGES",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        (plant["similarImages"] as List).length,
                        (index) => _buildImage(
                          (plant["similarImages"] as List)[index],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () {
                          if (!isFavorite) {
                            FavoritesManager.instance.addFavorite({
                              "displayName": widget.plantResult,
                              "scientificName": plant["scientificName"],
                              "localName": plant["commonNames"],
                              "benefits": plant["description"],
                              "image": widget.plantImage ?? plant["image"],
                            });
                            setState(() {
                              isFavorite = true;
                            });
                          }
                        },
                        child: Text(
                          isFavorite ? "Saved" : "+ Save Plant",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required IconData icon,
    required String title,
    required List<String> items,
    required bool isExpanded,
    required VoidCallback onTap,
    Color color = Colors.green,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: color),
                        const SizedBox(width: 8),
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: color,
                    ),
                  ],
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      ...items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8, left: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "• ",
                                style: TextStyle(height: 1.4, fontSize: 16),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: GestureDetector(
          onTap: () => _showFullImage(context, path),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
