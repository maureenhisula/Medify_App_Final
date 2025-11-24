import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scanner_screen.dart';
import 'favorite_screen.dart';
import 'plant_libscreen.dart';
import 'settings_screen.dart';
import 'result_screen.dart';
import 'favorites_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final Map<String, Map<String, String>> plantData = {
    'oregano': {
      'image': 'assets/images/klabo.png',
      'sci': 'Coleus amboinicus',
      'local': 'Klabo',
    },
    'sambong': {
      'image': 'assets/images/sambong.png',
      'sci': 'Blumea balsamifera',
      'local': 'Sambong',
    },
    'akapulko': {
      'image': 'assets/images/akapulko.png',
      'sci': 'Senna alata',
      'local': 'Akapulko',
    },
    'lagundi': {
      'image': 'assets/images/lagundi.png',
      'sci': 'Vitex negundo',
      'local': 'Lagundi',
    },
    'tanglad': {
      'image': 'assets/images/tanglad.png',
      'sci': 'Cymbopogon citratus',
      'local': 'Tanglad',
    },
    'damong maria': {
      'image': 'assets/images/damong maria.png',
      'sci': 'Artemisia vulgaris',
      'local': 'Damong Maria',
    },
  };

  final List<Map<String, String>> plantTrivia = [
    {
      'name': 'Aeugbati',
      'image': 'assets/images/alugbati.png',
      'trivia':
          'Packed with vitamins and iron, Aeugbati isn`t just a leafy veggie — it`s a natural body cooler and gentle detoxifier.',
    },
    {
      'name': 'Akapulko',
      'image': 'assets/images/akapulko.png',
      'trivia':
          'Known as the "ringworm bush," Akapulko naturally fights skin fungi — a DOH-approved herbal remedy for clearer, healthier skin.',
    },
    {
      'name': 'Aloe Vera',
      'image': 'assets/images/aloevera.png',
      'trivia':
          'Famous for its cooling gel, Aloe Vera heals burns, hydrates skin, and aids digestion — a natural soothing remedy loved worldwide.',
    },
    {
      'name': 'Ampalaya',
      'image': 'assets/images/ampalaya.png',
      'trivia':
          'The famous bitter gourd! Trusted by generations — and DOH-approved — for helping lower blood sugar levels naturally.',
    },
    {
      'name': 'Argaw / Alagaw',
      'image': 'assets/images/argaw.png',
      'trivia':
          'With its soothing aroma, Alagaw leaves have long been brewed to ease coughs, asthma, and chest congestion.',
    },
    {
      'name': 'Bayabas',
      'image': 'assets/images/bayabas.png',
      'trivia':
          'Guava leaves are nature`s antiseptic — perfect for washing wounds and relieving diarrhea.',
    },
    {
      'name': 'Buyo',
      'image': 'assets/images/buyo.png',
      'trivia':
          'The betel leaf isn`t just for chewing — it`s also prized for its antibacterial power and refreshing aroma.',
    },
    {
      'name': 'Cassava',
      'image': 'assets/images/cassava.png',
      'trivia':
          'A staple root crop rich in energy; cassava leaves are also used in traditional remedies for rheumatism.',
    },
    {
      'name': 'Damong Maria',
      'image': 'assets/images/damong maria.png',
      'trivia':
          'Known as a women`s herb, Damong Maria tea helps relieve menstrual cramps and stomach discomfort.',
    },
    {
      'name': 'Kataka-taka',
      'image': 'assets/images/kataka-taka.png',
      'trivia':
          'True to its name "the astonishing one," Kataka-taka`s thick leaves can heal wounds and burns when applied directly.',
    },
    {
      'name': 'Klabo',
      'image': 'assets/images/klabo.png',
      'trivia':
          'Known for its distinctive scent, Klabo is used in rural medicine for easing rheumatism and skin infections.',
    },
    {
      'name': 'Lagundi',
      'image': 'assets/images/lagundi.png',
      'trivia':
          'One of DOH`s top herbal medicines — Lagundi helps relieve cough, asthma, and bronchitis naturally.',
    },
    {
      'name': 'Lampunaya',
      'image': 'assets/images/eampunaya.png',
      'trivia':
          'With its fragrant leaves, Lampunaya tea is a go-to home remedy for cough, sore throat, and colds.',
    },
    {
      'name': 'Malunggay',
      'image': 'assets/images/malunggay.png',
      'trivia':
          'Often called the "miracle tree," Malunggay is loaded with vitamins, minerals, and antioxidants for overall wellness.',
    },
    {
      'name': 'Sambong',
      'image': 'assets/images/sambong.png',
      'trivia':
          'A DOH-certified herbal diuretic, Sambong helps flush out kidney stones and lower blood pressure.',
    },
    {
      'name': 'Takip Kuhol / Gotu Kola',
      'image': 'assets/images/takip kuhol.png',
      'trivia':
          'A brain and blood booster! Gotu Kola improves memory, circulation, and overall vitality.',
    },
    {
      'name': 'Tanglad',
      'image': 'assets/images/tanglad.png',
      'trivia':
          'Lemongrass isn`t just for tea — it calms the nerves, eases cough, and drives away mosquitoes.',
    },
    {
      'name': 'Tawa-Tawa',
      'image': 'assets/images/tawa.png',
      'trivia':
          'Traditionally brewed to help increase platelet count during dengue — a well-known herbal hero in the Philippines.',
    },
    {
      'name': 'Tsaang Gubat',
      'image': 'assets/images/tsa.png',
      'trivia':
          'A soothing tea made from Tsaang Gubat leaves helps relieve stomach pain and diarrhea.',
    },
    {
      'name': 'Ulasimang Bato',
      'image': 'assets/images/pansit.png',
      'trivia':
          'Known for its shiny leaves and healing touch — used to ease arthritis and lower uric acid.',
    },
  ];

  final PageController _triviaController = PageController();
  final PageController _tabPageController = PageController();
  final TextEditingController _searchController = TextEditingController();

  int _triviaIndex = 0;
  int _selectedTab = 0;
  int _selectedNav = 0;
  Timer? _autoScrollTimer;

  bool _showTutorial = false;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late AnimationController _tutorialController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _tutorialFadeAnimation;
  late Animation<double> _tutorialBlurAnimation;

  List<Map<String, String>> _recentHistory = [];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    _setupAnimations();
    _checkFirstLaunch();
    _loadRecentHistory();
    plantTrivia.shuffle();
  }

  Future<void> _loadRecentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('recentHistory') ?? [];

    setState(() {
      _recentHistory = history.map((entry) {
        final parts = entry.split('|');
        return {
          'plantName': parts[0],
          'imagePath': parts.length > 1 ? parts[1] : '',
        };
      }).toList();
    });
  }

  void _setupAnimations() {
    _tutorialController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _tutorialFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _tutorialController, curve: Curves.easeInOut),
    );

    _tutorialBlurAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _tutorialController, curve: Curves.easeInOut),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeOut));
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTutorial = prefs.getBool('hasSeenTutorial') ?? false;

    if (!hasSeenTutorial) {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted && _selectedNav == 0) {
        setState(() {
          _showTutorial = true;
        });
        _tutorialController.forward();
      }
    }
  }

  Future<void> _dismissTutorial() async {
    await _tutorialController.reverse();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenTutorial', true);

    if (mounted) {
      setState(() {
        _showTutorial = false;
      });
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_triviaController.hasClients) {
        int nextPage = _triviaIndex + 1;
        if (nextPage >= plantTrivia.length) nextPage = 0;
        _triviaController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _triviaController.dispose();
    _tabPageController.dispose();
    _searchController.dispose();
    _autoScrollTimer?.cancel();
    _pulseController.dispose();
    _glowController.dispose();
    _tutorialController.dispose();
    super.dispose();
  }

  double _getResponsiveSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    return (width / 375) * baseSize * 0.85;
  }

  Widget _buildSearchBar({bool readOnly = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createSearchRoute());
      },
      child: Container(
        height: _getResponsiveSize(context, 48),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F1F1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsiveSize(context, 16),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Colors.grey,
              size: _getResponsiveSize(context, 24),
            ),
            SizedBox(width: _getResponsiveSize(context, 8)),
            Text(
              "Search plant",
              style: TextStyle(
                color: Colors.grey,
                fontSize: _getResponsiveSize(context, 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Route _createSearchRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SearchScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(0, 0.1);
        const endOffset = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(
          begin: beginOffset,
          end: endOffset,
        ).chain(CurveTween(curve: curve));
        var fadeTween = Tween<double>(begin: 0, end: 1);

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildPlantPanel(String plantKey) {
    final plant = plantData[plantKey]!;
    final displayName = plantKey[0].toUpperCase() + plantKey.substring(1);
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth * 0.48;

    return AnimatedBuilder(
      animation: FavoritesManager.instance,
      builder: (context, _) {
        final alreadySaved = FavoritesManager.instance.isFavorite({
          "displayName": displayName,
          "scientificName": plant['sci']!,
          "localName": displayName,
          "image": plant['image']!,
        });

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ResultScreen(plantResult: displayName, accuracy: 100.0),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: _getResponsiveSize(context, 10),
              vertical: _getResponsiveSize(context, 10),
            ),
            width: panelWidth.clamp(160, 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 14,
                  spreadRadius: 1,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    plant['image']!,
                    height: _getResponsiveSize(context, 140),
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: _getResponsiveSize(context, 8)),
                Text(
                  displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getResponsiveSize(context, 16),
                    color: Colors.black,
                  ),
                ),
                Text(
                  plant['sci']!,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: _getResponsiveSize(context, 13),
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: _getResponsiveSize(context, 8)),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _getResponsiveSize(context, 12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (!alreadySaved) {
                          FavoritesManager.instance.addFavorite({
                            "displayName": displayName,
                            "scientificName": plant['sci']!,
                            "localName": plant['local']!,
                            "benefits": "Medicinal plant",
                            "image": plant['image']!,
                          });
                        } else {
                          FavoritesManager.instance.removeFavorite({
                            "displayName": displayName,
                            "scientificName": plant['sci']!,
                            "localName": plant['local']!,
                            "benefits": "Medicinal plant",
                            "image": plant['image']!,
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size.fromHeight(
                        _getResponsiveSize(context, 32),
                      ),
                    ),
                    child: Text(
                      alreadySaved ? "Saved" : "+ Save Plant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getResponsiveSize(context, 12),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _getResponsiveSize(context, 10)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecentHistoryPanel(Map<String, String> historyItem) {
    final screenWidth = MediaQuery.of(context).size.width;
    final panelWidth = screenWidth * 0.48;
    final plantName = historyItem['plantName'] ?? 'Unknown';
    final imagePath = historyItem['imagePath'] ?? '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResultScreen(plantResult: plantName, accuracy: 100.0),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _getResponsiveSize(context, 10),
          vertical: _getResponsiveSize(context, 10),
        ),
        width: panelWidth.clamp(160, 220),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: imagePath.isNotEmpty && File(imagePath).existsSync()
                  ? Image.file(
                      File(imagePath),
                      height: _getResponsiveSize(context, 140),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: _getResponsiveSize(context, 140),
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.eco,
                        color: Colors.green,
                        size: _getResponsiveSize(context, 60),
                      ),
                    ),
            ),
            SizedBox(height: _getResponsiveSize(context, 12)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSize(context, 12),
              ),
              child: Text(
                plantName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _getResponsiveSize(context, 16),
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: _getResponsiveSize(context, 8)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _getResponsiveSize(context, 12),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsiveSize(context, 12),
                  vertical: _getResponsiveSize(context, 8),
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.history,
                      size: _getResponsiveSize(context, 14),
                      color: Colors.green,
                    ),
                    SizedBox(width: _getResponsiveSize(context, 4)),
                    Text(
                      "Recent Scan",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: _getResponsiveSize(context, 12),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: _getResponsiveSize(context, 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabHeader(String title, int index) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
          _tabPageController.jumpToPage(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _getResponsiveSize(context, 18),
            color: isActive ? Colors.green : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  Widget _buildWithSearch(Widget child) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _getResponsiveSize(context, 16),
            vertical: _getResponsiveSize(context, 20),
          ),
          child: _buildSearchBar(readOnly: true),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _getCurrentPage() {
    if (_selectedNav == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadRecentHistory();
      });
    }

    switch (_selectedNav) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildWithSearch(const FavoriteScreen());
      case 2:
        return const ScannerScreen();
      case 3:
        return _buildWithSearch(PlantLibScreen(searchQuery: ""));
      case 4:
        return const SettingsScreen();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsiveSize(context, 16),
        vertical: _getResponsiveSize(context, 20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: _getResponsiveSize(context, 20)),
          Text(
            "Plant Trivia",
            style: TextStyle(
              fontSize: _getResponsiveSize(context, 19),
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 65, 135, 68),
            ),
          ),
          SizedBox(height: _getResponsiveSize(context, 12)),
          Center(
            child: Column(
              children: [
                Container(
                  width: screenWidth * 0.90,
                  height: _getResponsiveSize(context, 190).clamp(160, 200),
                  padding: EdgeInsets.all(_getResponsiveSize(context, 12)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _triviaController,
                          physics: const ClampingScrollPhysics(),
                          itemCount: plantTrivia.length,
                          onPageChanged: (index) =>
                              setState(() => _triviaIndex = index),
                          itemBuilder: (context, index) {
                            final plant = plantTrivia[index];
                            return Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    plant['image']!,
                                    width: _getResponsiveSize(context, 120),
                                    height: _getResponsiveSize(context, 120),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: _getResponsiveSize(context, 14),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        plant['name']!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: _getResponsiveSize(
                                            context,
                                            17,
                                          ),
                                          color: const Color(0xFF388E3C),
                                        ),
                                      ),
                                      SizedBox(
                                        height: _getResponsiveSize(context, 6),
                                      ),
                                      Text(
                                        plant['trivia']!,
                                        style: TextStyle(
                                          fontSize: _getResponsiveSize(
                                            context,
                                            13,
                                          ),
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: _getResponsiveSize(context, 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          int groupIndex = (_triviaIndex ~/ 4);
                          int groupStart = groupIndex * 4;
                          int activeIndexInGroup = _triviaIndex - groupStart;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: activeIndexInGroup == index ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: activeIndexInGroup == index
                                  ? Colors.green
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _getResponsiveSize(context, 30)),
          Row(
            children: [
              _buildTabHeader("Popular", 0),
              SizedBox(width: _getResponsiveSize(context, 22)),
              _buildTabHeader("Recent History", 1),
            ],
          ),
          SizedBox(height: _getResponsiveSize(context, 18)),
          SizedBox(
            height: _getResponsiveSize(context, 280).clamp(230, 290),
            child: PageView(
              controller: _tabPageController,
              onPageChanged: (index) => setState(() => _selectedTab = index),
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  padding: const EdgeInsets.only(left: 0),
                  itemBuilder: (context, index) {
                    final keys = ['oregano', 'sambong', 'lagundi'];
                    return _buildPlantPanel(keys[index]);
                  },
                ),
                _recentHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: _getResponsiveSize(context, 60),
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: _getResponsiveSize(context, 12)),
                            Text(
                              'No recent scans',
                              style: TextStyle(
                                fontSize: _getResponsiveSize(context, 16),
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: _getResponsiveSize(context, 6)),
                            Text(
                              'Scan a plant to see it here',
                              style: TextStyle(
                                fontSize: _getResponsiveSize(context, 14),
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _recentHistory.length,
                        padding: const EdgeInsets.only(left: 0),
                        itemBuilder: (context, index) {
                          return _buildRecentHistoryPanel(
                            _recentHistory[index],
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    return AnimatedBuilder(
      animation: _tutorialController,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: _tutorialFadeAnimation.value,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _tutorialBlurAnimation.value,
                    sigmaY: _tutorialBlurAnimation.value,
                  ),
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.4 * _tutorialFadeAnimation.value,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Opacity(
                opacity: _tutorialFadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _tutorialFadeAnimation.value)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _getResponsiveSize(context, 32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Let's Identify Some Plants!",
                          style: TextStyle(
                            fontSize: _getResponsiveSize(context, 20),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: _getResponsiveSize(context, 8)),
                        Text(
                          "Tap the button below to identify your plant.",
                          style: TextStyle(
                            fontSize: _getResponsiveSize(context, 18),
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedNav == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _selectedNav != 0) {
          setState(() {
            _selectedNav = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SafeArea(child: _getCurrentPage()),
            if (_showTutorial && _selectedNav == 0) _buildTutorialOverlay(),
          ],
        ),
        bottomNavigationBar: _selectedNav == 2
            ? null
            : Container(
                margin: EdgeInsets.only(
                  bottom: _getResponsiveSize(context, 50),
                  left: _getResponsiveSize(context, 8),
                  right: _getResponsiveSize(context, 8),
                ),
                height: _getResponsiveSize(context, 80).clamp(65, 80),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(42),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home, "Home", 0),
                        _buildNavItem(Icons.favorite, "Favorites", 1),
                        SizedBox(width: _getResponsiveSize(context, 60)),
                        _buildNavItem(Icons.spa, "Library", 3),
                        _buildNavItem(Icons.settings, "Settings", 4),
                      ],
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildCameraButton(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedNav == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNav = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color.fromARGB(255, 17, 187, 23)
                : Colors.grey,
            size: _getResponsiveSize(context, 28),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: _getResponsiveSize(context, 13),
              color: isActive
                  ? const Color.fromARGB(255, 35, 170, 39)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return GestureDetector(
      onTap: () {
        if (_showTutorial) {
          _dismissTutorial();
        }
        setState(() {
          _selectedNav = 2;
        });
      },
      child: SizedBox(
        width: _getResponsiveSize(context, 120),
        height: _getResponsiveSize(context, 120),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_showTutorial && _selectedNav == 0)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: 1.0 - _pulseAnimation.value,
                    child: Container(
                      width:
                          _getResponsiveSize(context, 65) +
                          (_pulseAnimation.value * 50),
                      height:
                          _getResponsiveSize(context, 65) +
                          (_pulseAnimation.value * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(17, 235, 24, 1)
                                .withValues(
                                  alpha: (1.0 - _pulseAnimation.value) * 0.6,
                                ),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (_showTutorial && _selectedNav == 0)
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    width: _getResponsiveSize(context, 85),
                    height: _getResponsiveSize(context, 85),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(
                            17,
                            235,
                            24,
                            1,
                          ).withValues(alpha: _glowAnimation.value * 0.4),
                          blurRadius: 30,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: const Color.fromRGBO(
                            17,
                            235,
                            24,
                            1,
                          ).withValues(alpha: _glowAnimation.value * 0.2),
                          blurRadius: 50,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  );
                },
              ),
            Container(
              padding: EdgeInsets.all(_getResponsiveSize(context, 12)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(17, 235, 24, 1),
                boxShadow: _showTutorial && _selectedNav == 0
                    ? [
                        BoxShadow(
                          color: const Color.fromRGBO(
                            17,
                            235,
                            24,
                            1,
                          ).withValues(alpha: 0.5),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: _getResponsiveSize(context, 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<Map<String, dynamic>> allPlants;
  late List<Map<String, dynamic>> filteredPlants;

  static final Map<String, Map<String, dynamic>> _plantData = {
    "Malunggay": {
      "scientificName": "Moringa oleifera",
      "image": "assets/images/malunggay.png",
    },
    "Ampalaya": {
      "scientificName": "Momordica charantia",
      "image": "assets/images/ampalaya.png",
    },
    "Lagundi": {
      "scientificName": "Vitex negundo",
      "image": "assets/images/lagundi.png",
    },
    "Sambong": {
      "scientificName": "Blumea balsamifera",
      "image": "assets/images/sambong.png",
    },
    "Tanglad": {
      "scientificName": "Cymbopogon citratus",
      "image": "assets/images/tanglad.png",
    },
    "Oregano": {
      "scientificName": "Coleus amboinicus",
      "image": "assets/images/klabo.png",
    },
    "Akapulko": {
      "scientificName": "Senna alata",
      "image": "assets/images/akapulko.png",
    },
    "Ulasimang Bato": {
      "scientificName": "Peperomia pellucida",
      "image": "assets/images/pansit.png",
    },
    "Bayawas": {
      "scientificName": "Psidium guajava",
      "image": "assets/images/bayabas.png",
    },
    "Takip Kuhol": {
      "scientificName": "Centella asiatica",
      "image": "assets/images/takip kuhol.png",
    },
    "Tawa-Tawa": {
      "scientificName": "Euphorbia hirta",
      "image": "assets/images/tawa.png",
    },
    "Damong Maria": {
      "scientificName": "Artemisia vulgaris",
      "image": "assets/images/damong maria.png",
    },
    "Aeugbati": {
      "scientificName": "Basella alba",
      "image": "assets/images/alugbati.png",
    },
    "Kataka-taka": {
      "scientificName": "Kalanchoe pinnata",
      "image": "assets/images/kataka-taka.png",
    },
    "Tsaang Gubat": {
      "scientificName": "Ehretia microphylla",
      "image": "assets/images/tsa.png",
    },
    "Buyo": {
      "scientificName": "Piper betle",
      "image": "assets/images/buyo.png",
    },
    "Adgaw": {
      "scientificName": "Premna odorata",
      "image": "assets/images/argaw.png",
    },
    "Lampunaya": {
      "scientificName": "Alpinia elegans",
      "image": "assets/images/eampunaya.png",
    },
    "Aloe Vera": {
      "scientificName": "Aloe barbadensis Miller",
      "image": "assets/images/aloevera.png",
    },
  };

  @override
  void initState() {
    super.initState();
    allPlants = _plantData.entries
        .map(
          (e) => {
            "name": e.key,
            "scientificName": e.value["scientificName"] ?? "Unknown",
            "commonNames": e.value["commonNames"] ?? "",
            "image": e.value["image"] ?? "assets/images/plant.png",
          },
        )
        .toList();
    filteredPlants = List.from(allPlants);
    _controller.addListener(_filterPlants);
  }

  void _filterPlants() {
    final query = _controller.text.toLowerCase();
    setState(() {
      filteredPlants = allPlants
          .where(
            (p) =>
                p["name"].toLowerCase().contains(query) ||
                p["commonNames"].toLowerCase().contains(query),
          )
          .toList();
    });
  }

  double _getResponsiveSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    return (width / 375) * baseSize * 0.85;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(_getResponsiveSize(context, 16)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: _getResponsiveSize(context, 24),
                        ),
                        hintText: "Search plant",
                        hintStyle: TextStyle(
                          fontSize: _getResponsiveSize(context, 16),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1F1F1),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: _getResponsiveSize(context, 10),
                          horizontal: _getResponsiveSize(context, 16),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: _getResponsiveSize(context, 16),
                      ),
                    ),
                  ),
                  SizedBox(width: _getResponsiveSize(context, 10)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: _getResponsiveSize(context, 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredPlants.isEmpty
                  ? Center(
                      child: Text(
                        "No plants found",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: _getResponsiveSize(context, 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredPlants.length,
                      itemBuilder: (context, index) {
                        final plant = filteredPlants[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: _getResponsiveSize(context, 10),
                            horizontal: _getResponsiveSize(context, 16),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(plant["image"]),
                            radius: _getResponsiveSize(context, 34),
                          ),
                          title: Text(
                            plant["name"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _getResponsiveSize(context, 18),
                            ),
                          ),
                          subtitle: Text(
                            plant["scientificName"],
                            style: TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: _getResponsiveSize(context, 15),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResultScreen(
                                  plantResult: plant["name"],
                                  accuracy: 100.0,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
