import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Open mail app - tries multiple methods
  void _sendMail(BuildContext context, String email) async {
    final String subject = 'Medify App Support & Feedback';
    final String body =
        'Hello Medify Team,\n\nI would like to share the following feedback:\n';

    // Method 1: Standard mailto (works with any email app)
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      // Try to launch with any available app
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // Method 2: Try with platformDefault mode (lets Android chooser handle it)
        await launchUrl(emailUri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      // Method 3: Try Gmail-specific intent for Android
      try {
        final Uri gmailUri = Uri.parse(
          'googlegmail://co?to=$email&subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
        );
        await launchUrl(gmailUri);
      } catch (e2) {
        // Method 4: Generic email intent
        try {
          final Uri genericEmailUri = Uri(scheme: 'mailto', path: email);
          await launchUrl(
            genericEmailUri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e3) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please install an email app to send feedback.'),
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    }
  }

  // Share app
  void _shareApp() async {
    try {
      final byteData = await rootBundle.load('assets/images/medify_logo.png');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/medify_logo.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      const appLink =
          'https://drive.google.com/file/d/1NrbhR4ZnmHe5k7W0Ou_ANBCHN4QErDH5/view?fbclid=IwZXh0bgNhZW0CMTEAAR416Tak_k4f95swO9tYVgRkGoNgZlTB3M8yVmotBssypy6-pk0LbJxPqxmeHw_aem_PLt8klyo_BpXz2OJuy5qnA';

      await SharePlus.instance.share(
        ShareParams(
          text:
              '🌿 Check out Medify — your smart medicinal plant identifier app!\n\n📲 Download here: $appLink',
          files: [XFile(file.path)],
          subject: 'Medify — Smart Medicinal Plant Identifier',
        ),
      );
    } catch (e) {
      debugPrint('Error sharing app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding and sizing
    final horizontalPadding = screenWidth * 0.043; // ~16px on 375px width
    final verticalPadding = screenHeight * 0.029; // ~24px on 812px height
    final bottomPadding = screenHeight * 0.039; // ~32px on 812px height

    final List<Map<String, dynamic>> options = [
      // 1️⃣ Help Center / FAQs
      {"title": "Help Center / FAQs", "icon": Icons.help_outline},
      // 2️⃣ Tutorial Reset
      {"title": "Tutorial / Onboarding Reset", "icon": Icons.school_outlined},
      // 3️⃣ Support & Feedback
      {
        "title": "Support & Feedback",
        "email": "maureenhisula@gmail.com",
        "icon": Icons.support_agent,
      },
      // 4️⃣ Share App
      {"title": "Share App", "icon": Icons.share},
      // 5️⃣ About the App
      {
        "title": "About the App / Developer Info",
        "content": "about",
        "icon": Icons.info_outline,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            verticalPadding,
            horizontalPadding,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌿 Settings Title
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.011,
                  bottom: screenHeight * 0.025,
                ),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    fontSize: screenWidth * 0.069,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // =====================
              // 🧩 PANEL 1: Help & Tutorial
              // =====================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10, // slightly higher for softness
                      spreadRadius: 2, // spreads shadow evenly
                      offset: const Offset(0, 0), // center shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(options[0]["icon"], color: Colors.green),
                      title: Text(
                        options[0]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FAQScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, color: Colors.transparent),
                    ListTile(
                      leading: Icon(options[1]["icon"], color: Colors.green),
                      title: Text(
                        options[1]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TutorialResetPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // =====================
              // 🧩 PANEL 2: Support & Share
              // =====================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(options[2]["icon"], color: Colors.green),
                      title: Text(
                        options[2]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        _sendMail(context, options[2]["email"]!);
                      },
                    ),
                    const Divider(height: 1, color: Colors.transparent),
                    ListTile(
                      leading: Icon(options[3]["icon"], color: Colors.green),
                      title: Text(
                        options[3]["title"]!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: _shareApp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // =====================
              // 🧩 PANEL 3: About
              // =====================
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Icon(options[4]["icon"], color: Colors.green),
                  title: Text(
                    options[4]["title"]!,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutInfoPage(),
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

// 🌿 Tutorial Reset Page
class TutorialResetPage extends StatelessWidget {
  const TutorialResetPage({super.key});

  final List<Map<String, dynamic>> tutorialSteps = const [
    {
      "icon": Icons.camera_alt_outlined,
      "title": "Open the Scanner",
      "description":
          "Tap the scanner icon from the bottom navigation bar to start identifying plants.",
    },
    {
      "icon": Icons.photo_camera,
      "title": "Take a Clear Photo",
      "description":
          "Ensure the plant is well-lit and in focus. Capture leaves, flowers, or distinctive parts.",
    },
    {
      "icon": Icons.search_outlined,
      "title": "View Identification Results",
      "description":
          "After scanning, you'll see the plant name and a brief description.",
    },
    {
      "icon": Icons.info_outline,
      "title": "Tap for Details",
      "description":
          "Tap the 'Tap for details' for detailed medicinal uses and scientific info.",
    },
    {
      "icon": Icons.list_alt_outlined,
      "title": "Explore Plant Info Panels",
      "description":
          "Scroll through the info panel to see all available data about the plant.",
    },
    {
      "icon": Icons.refresh_outlined,
      "title": "Reset Tutorial",
      "description":
          "Replay the onboarding anytime from this screen using the reset button below.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
        title: const Text(
          "Tutorial / Onboarding Reset",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tutorialSteps.length,
                itemBuilder: (context, index) {
                  final step = tutorialSteps[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: Colors.green.withValues(alpha: 0.1),
                        child: Icon(step['icon'], color: Colors.green),
                      ),
                      title: Text(
                        "Step ${index + 1}: ${step['title']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          step['description'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Reset Tutorial Button
            /*  Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_outlined),
                  label: const Text(
                    "Reset Tutorial",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          "Reset Tutorial",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: const Text(
                          "Are you sure you want to reset the tutorial? This will replay all onboarding instructions.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text("Reset"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}

// 🌿 FAQ Screen
class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  static const List<Map<String, String>> faqs = [
    {
      "question": "What is Medify and how does it work?",
      "answer":
          "Medify is a medicinal plant identifier app that uses AI to recognize plants from photos. Simply scan or upload a picture of a plant, and the app will identify it and show details about its medicinal properties.",
    },
    {
      "question": "How can I get the best identification results?",
      "answer":
          "Make sure your photo is clear, taken in good lighting, and focuses on the plant's leaves or flowers. Avoid blurry or cluttered backgrounds for more accurate results.",
    },
    {
      "question": "Can Medify identify all types of plants?",
      "answer":
          "Medify focuses mainly on medicinal and common local plants. Some rare or ornamental plants might not be recognized yet, but the database is continuously expanding.",
    },
    {
      "question": "Where does the medicinal information come from?",
      "answer":
          "The information is collected from trusted botanical and herbal medicine references. Each plant's description is based on credible research and verified herbal sources.",
    },
    {
      "question": "Is the app free to use?",
      "answer":
          "Yes! The core features of Medify are free, including plant scanning and viewing basic medicinal details.",
    },
    {
      "question": "Can I use photos from my gallery instead of scanning live?",
      "answer":
          "Absolutely. You can either take a live photo using your camera or upload an existing image from your gallery for identification.",
    },
    {
      "question":
          "Does Medify provide medical advice or treatment recommendations?",
      "answer":
          "No. Medify is for educational purposes only. Always consult a healthcare professional before using any plant for treatment.",
    },
    {
      "question":
          "How can I report a wrong identification or suggest new plants?",
      "answer":
          "You can go to the Support & Feedback section in the app to report errors, suggest new species, or request improvements.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Help Center / FAQs",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(screenWidth * 0.043),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: FAQTile(question: faq['question']!, answer: faq['answer']!),
          );
        },
      ),
    );
  }
}

// 🌿 FAQ Tile with pure white panel & shadows, no black lines
class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({super.key, required this.question, required this.answer});

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Text(
              widget.question,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.green,
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            onExpansionChanged: (val) {
              setState(() {
                _isExpanded = val;
              });
            },
            children: [
              Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🧠 Generic InfoPage (for text-only content)
class InfoPage extends StatelessWidget {
  final String title;
  final String content;

  const InfoPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.043),
        child: SingleChildScrollView(
          child: SelectableText(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

// 🌿 Custom About Page with proper UI layout
class AboutInfoPage extends StatelessWidget {
  const AboutInfoPage({super.key});

  Widget buildSection(String title, IconData icon, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 31, 31, 31),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, top: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.8),
          height: 1.5,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget buildDeveloper(
    String name,
    String role,
    IconData icon, {
    double iconSize = 40,
    double nameFontSize = 16,
    double roleFontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: iconSize),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: nameFontSize,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.7),
              fontSize: roleFontSize,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.green),
        title: const Text(
          "About the App",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.053),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSection("App Info", Icons.apps, [
              buildText("🌿 Medify v1.0 (Build 1.0.0 Stable)"),
              buildText(
                "A smart medicinal plant identifier and learning tool.",
              ),
            ]),
            buildSection("Developers", Icons.person_outline, [
              const SizedBox(height: 12),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 60,
                  runSpacing: 30,
                  children: [
                    SizedBox(
                      width: 140,
                      child: buildDeveloper(
                        "Axle Lawrence Dangautan",
                        "Model Training & App Developer",
                        Icons.computer_outlined,
                        iconSize: 36,
                        nameFontSize: 14,
                        roleFontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: buildDeveloper(
                        "Maureen Shane Hisula",
                        "UI Design & Dataset Lead",
                        Icons.design_services_outlined,
                        iconSize: 36,
                        nameFontSize: 14,
                        roleFontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: buildDeveloper(
                        "Tricia Marie Balidio",
                        "Image Capture & Documentation",
                        Icons.camera_alt_outlined,
                        iconSize: 36,
                        nameFontSize: 14,
                        roleFontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: buildDeveloper(
                        "Shaira Jyka Nablo",
                        "Data Support & Testing",
                        Icons.science_outlined,
                        iconSize: 36,
                        nameFontSize: 14,
                        roleFontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ]),

            const SizedBox(height: 16),
            buildSection("Purpose", Icons.spa_outlined, [
              buildText(
                "Medify helps identify medicinal plants and provides accurate information about their traditional and scientific uses.",
              ),
            ]),
            buildSection("Technology Used", Icons.memory_outlined, [
              buildText("• Flutter for mobile development"),
              buildText("• TensorFlow Lite for AI model"),
              buildText("• MobileNet V2 architecture for plant classification"),
              buildText("• Open Medicinal Plant Dataset for training"),
            ]),
            buildSection("Licenses & Credits", Icons.library_books_outlined, [
              buildText("• Flutter & Dart"),
              buildText("• TensorFlow Lite"),
              buildText("• DenseNet Architecture"),
              buildText("• Open Medicinal Plant Dataset"),
              buildText("• Freepik & Local Capture for image resources"),
            ]),
            buildSection("Privacy", Icons.privacy_tip_outlined, [
              buildText(
                "All plant scans are processed locally on your device. No personal images are stored or shared.",
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
