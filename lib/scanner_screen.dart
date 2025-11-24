import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'result_screen.dart';
import 'home_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  Interpreter? _interpreter;
  final List<String> _labels = [
    "Aeugbati",
    "Akapulko",
    "Aloe vera",
    "Ampalaya",
    "Adgaw",
    "Bayawas",
    "Buyo",
    "Cassava",
    "Damong Maria",
    "Kataka-taka",
    "Oregano",
    "Lagundi",
    "Lampunaya",
    "Malunggay",
    "Sambong",
    "Takip Kuhol",
    "Tanglad",
    "Tawa-Tawa",
    "Tsaang Gubat",
    "Ulasimang Bato",
    "Unknown",
  ];

  File? _image;
  String _prediction = "";
  double _accuracy = 0.0;
  File? _galleryImage;

  bool isScanning = false;
  bool scanSuccess = false;
  bool detailsTapped = false;

  late AnimationController scanController;
  late Animation<double> scanAnimation;

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _setupCamera();
    _checkFirstLaunchScanner();

    scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    scanAnimation = Tween<double>(begin: 0, end: 1).animate(scanController);

    scanController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        scanController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (isScanning && scanController.value != 1.0) {
          scanController.forward();
        }
      }
    });
  }

  Future<void> _checkFirstLaunchScanner() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenScannerTutorial =
        prefs.getBool('hasSeenScannerTutorial') ?? false;

    if (!hasSeenScannerTutorial) {
      // Wait a bit for the screen to render
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _showInfoBottomSheet();
        await prefs.setBool('hasSeenScannerTutorial', true);
      }
    }
  }

  Future<void> _setupCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        debugPrint("No cameras available on this device.");
        return;
      }

      final firstCamera = cameras.first;

      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _initializeControllerFuture = _cameraController!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    scanController.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/densenet_plant_model_final.tflite',
      );

      debugPrint("✅ TFLite model loaded!");
    } catch (e) {
      debugPrint("❌ Failed to load model: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
        _galleryImage = File(pickedFile.path);
        _prediction = "";
        _accuracy = 0.0;
        scanSuccess = false;
        isScanning = false;
      });

      _scanImage();
    } catch (e) {
      setState(() {
        _prediction = "Error picking image: $e";
      });
    }
  }

  Future<void> _captureImage() async {
    if (_cameraController == null) {
      debugPrint("Camera is not initialized.");
      return;
    }

    try {
      await _initializeControllerFuture;
      final picture = await _cameraController!.takePicture();

      setState(() {
        _image = File(picture.path);
        _prediction = "";
        _accuracy = 0.0;
        scanSuccess = false;
        isScanning = false;
      });

      _scanImage();
    } catch (e) {
      debugPrint("❌ Camera capture failed: $e");
    }
  }

  Future<void> _scanImage() async {
    if (_image == null || isScanning) return;

    setState(() {
      isScanning = true;
      scanSuccess = false;
    });

    int count = 0;
    void startScan() {
      if (count >= 3) return;
      count++;
      scanController.forward().then(
        (_) => scanController.reverse().then((_) {
          if (count < 3) startScan();
        }),
      );
    }

    startScan();

    await _runModel(_image!);

    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        isScanning = false;
        scanSuccess = true;
      });

      // Show alert if prediction is Unknown
      if (_prediction == "Unknown") {
        _showUnknownPlantAlert();
      }
    }
  }

  static Future<List<List<List<List<double>>>>> preprocessImage(
    File imageFile,
  ) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) throw Exception("Cannot decode image");

    image = img.copyResize(image, width: 224, height: 224);

    return List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(224, (x) {
          final pixel = image!.getPixel(x, y);
          double r = pixel.r / 255.0;
          double g = pixel.g / 255.0;
          double b = pixel.b / 255.0;
          return [r, g, b];
        }),
      ),
    );
  }

  Future<void> _runModel(File imageFile) async {
    if (_interpreter == null) return;

    try {
      final input = await compute(preprocessImage, imageFile);
      var output = List.filled(
        _labels.length,
        0.0,
      ).reshape([1, _labels.length]);

      _interpreter!.run(input, output);

      // Convert output to list of label-probability maps
      List<Map<String, double>> predictions = [];
      for (int i = 0; i < _labels.length - 1; i++) {
        // Exclude 'Unknown' from original labels
        predictions.add({_labels[i]: output[0][i]});
      }

      // Sort descending by probability
      predictions.sort((a, b) => b.values.first.compareTo(a.values.first));

      // Take top 2 real predictions
      List<Map<String, double>> top2 = predictions.take(2).toList();

      // Calculate remaining probability for Unknown
      double topSum = top2.fold(0, (sum, p) => sum + p.values.first);
      double unknownProb = (1.0 - topSum).clamp(0.0, 1.0);

      // Build final top 3 predictions including Unknown
      List<Map<String, double>> top3 = List.from(top2);
      top3.add({"Unknown": unknownProb});

      // Update state for display
      setState(() {
        _prediction = top3
            .map((p) {
              String label = p.keys.first;
              double prob = p.values.first;
              return "$label - ${(prob * 100).toStringAsFixed(2)}%";
            })
            .join("\n");

        // Main accuracy shows the top prediction probability
        _accuracy = top2[0].values.first * 100;
      });

      debugPrint("Top 3 Predictions (including Unknown):\n$_prediction");
    } catch (e) {
      setState(() {
        _prediction = "Error: $e";
      });
    }
  }

  String getPlantName(String modelLabel) {
    return modelLabel;
  }

  void _showUnknownPlantAlert() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color.fromARGB(255, 255, 0, 0),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                "Unrecognized Image",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            "Image not recognized. The plant might not be in our database or the photo may not be clear enough.",
            style: TextStyle(fontSize: 17, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Reset to retry
                setState(() {
                  _image = null;
                  _prediction = "";
                  _accuracy = 0.0;
                  scanSuccess = false;
                  isScanning = false;
                });
                _setupCamera();
              },
              child: const Text(
                "Try Again",
                style: TextStyle(
                  color: Color.fromARGB(255, 44, 44, 44),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResultScreen() async {
    if (_prediction.isEmpty || _prediction == "Unknown") return;

    // Extract only the first prediction label (without percentage)
    String firstPrediction = _prediction.split('\n')[0].split(' - ')[0];

    // Save to recent history
    await _saveToRecentHistory(firstPrediction, _image?.path ?? '');

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ResultScreen(plantResult: firstPrediction, accuracy: _accuracy),
      ),
    );
  }

  Widget _buildPopup(double width) {
    // Don't show popup for Unknown predictions
    if (_prediction == "Unknown") {
      return const SizedBox.shrink();
    }

    // Parse predictions to extract individual items
    List<String> predictions = _prediction.split('\n');
    String firstPrediction = predictions.isNotEmpty
        ? predictions[0].split(' - ')[0]
        : '';
    String secondPrediction = predictions.length > 1
        ? predictions[1].split(' - ')[0]
        : '';
    String thirdPrediction = predictions.length > 2
        ? predictions[2].split(' - ')[0]
        : '';

    double secondAccuracy = predictions.length > 1
        ? double.tryParse(
                predictions[1].split(' - ').length > 1
                    ? predictions[1].split(' - ')[1].replaceAll('%', '')
                    : '0',
              ) ??
              0
        : 0;
    double thirdAccuracy = predictions.length > 2
        ? double.tryParse(
                predictions[2].split(' - ').length > 1
                    ? predictions[2].split(' - ')[1].replaceAll('%', '')
                    : '0',
              ) ??
              0
        : 0;

    return Positioned(
      bottom: width * 0.04,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: width * 0.7,
            padding: EdgeInsets.all(width * 0.025), // slightly smaller padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _image != null
                      ? Image.file(
                          _image!,
                          height: width * 0.16, // increased image size
                          width: width * 0.16,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: width * 0.16,
                          width: width * 0.16,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.crop_free,
                            color: Colors.green,
                            size: width * 0.07,
                          ),
                        ),
                ),
                SizedBox(width: width * 0.025),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // First prediction with green percentage panel
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              firstPrediction,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: width * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${_accuracy.toStringAsFixed(2)}%",
                              style: TextStyle(
                                fontSize: width * 0.03,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.015),
                      // Second and third predictions side by side with percentage inside
                      Row(
                        children: [
                          if (secondPrediction.isNotEmpty)
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01, // smaller padding
                                  vertical: width * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      secondPrediction,
                                      style: TextStyle(
                                        fontSize: width * 0.025, // smaller text
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: width * 0.003),
                                    Text(
                                      "${secondAccuracy.toStringAsFixed(2)}%",
                                      style: TextStyle(
                                        fontSize: width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (secondPrediction.isNotEmpty &&
                              thirdPrediction.isNotEmpty)
                            SizedBox(width: width * 0.01),
                          if (thirdPrediction.isNotEmpty)
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.01,
                                  vertical: width * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      thirdPrediction,
                                      style: TextStyle(
                                        fontSize: width * 0.025,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: width * 0.003),
                                    Text(
                                      "${thirdAccuracy.toStringAsFixed(2)}%",
                                      style: TextStyle(
                                        fontSize: width * 0.022,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: width * 0.01),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            detailsTapped = true;
                          });
                          _showResultScreen();
                        },
                        child: Text(
                          "Tap for details",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 80, 80, 80),
                            fontSize: width * 0.032,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return FractionallySizedBox(
          heightFactor: 0.92,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                        const Text(
                          "How to Scan Properly",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStep(
                              "Step 1",
                              "assets/images/wrong1.png",
                              "assets/images/check1.png",
                              "Wrong",
                              "Correct",
                              "Center the plant in the frame, ensuring the image is bright and clear.",
                            ),
                            _buildStep(
                              "Step 2",
                              "assets/images/wrong2.png",
                              "assets/images/check2.png",
                              "Wrong",
                              "Correct",
                              "If the plant is too large to fit, focus on capturing its leaves or flowers.",
                            ),
                            _buildStep(
                              "Step 3",
                              "assets/images/wrong3.jpeg",
                              "assets/images/check3.jpeg",
                              "Wrong",
                              "Correct",
                              "Don't get too close; ensure the leaves or flowers are fully visible and sharp.",
                            ),
                            _buildStep(
                              "Step 4",
                              "assets/images/wrong4.png",
                              "assets/images/check4.png",
                              "Wrong",
                              "Correct",
                              "If the plant has flowers, make them the focal point.",
                            ),
                            _buildStep(
                              "Step 5",
                              "assets/images/wrong5.png",
                              "assets/images/check5.png",
                              "Wrong",
                              "Correct",
                              "Include only one species per photo.",
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveToRecentHistory(String plantName, String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('recentHistory') ?? [];

    // Add new scan at the start
    history.insert(0, '$plantName|$imagePath');

    // Keep only the 3 most recent items
    if (history.length > 3) {
      history = history.sublist(0, 3);
    }

    await prefs.setStringList('recentHistory', history);
  }

  Widget _buildStep(
    String step,
    String wrongImage,
    String rightImage,
    String wrongLabel,
    String rightLabel,
    String instruction,
  ) {
    final stepNumber = step.replaceAll(RegExp(r'[^0-9]'), '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(wrongImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(rightImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.green,
                        child: Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 30,
              height: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(194, 157, 222, 159),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  stepNumber,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 79, 8),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                instruction,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 22, 22, 22),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.02,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.01,
                  left: width * 0.02,
                  right: width * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: width * 0.055,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                    ),
                    Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: width * 0.048,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: width * 0.055,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _showInfoBottomSheet,
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 80, 80, 80),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        _image != null
                            ? Center(
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.contain, // <-- change here
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              )
                            : (_cameraController != null
                                  ? FutureBuilder(
                                      future: _initializeControllerFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return SizedBox.expand(
                                            child: CameraPreview(
                                              _cameraController!,
                                            ),
                                          );
                                        } else {
                                          // Full-size loading state
                                          return Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            color: const Color.fromARGB(
                                              255,
                                              80,
                                              80,
                                              80,
                                            ),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(
                                                    color: Colors.green,
                                                    strokeWidth: width * 0.008,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.015,
                                                  ),
                                                  Text(
                                                    "Loading camera...",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * 0.038,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                  : Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: const Color.fromARGB(
                                        255,
                                        80,
                                        80,
                                        80,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              color: Colors.green,
                                              strokeWidth: width * 0.008,
                                            ),
                                            SizedBox(height: height * 0.015),
                                            Text(
                                              "Loading camera...",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.038,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                        if (isScanning)
                          AnimatedBuilder(
                            animation: scanAnimation,
                            builder: (context, child) {
                              return Positioned(
                                top:
                                    scanAnimation.value *
                                    (MediaQuery.of(context).size.height -
                                        (height * 0.2)),
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 3,
                                  color: Colors.green,
                                ),
                              );
                            },
                          ),
                        if (scanSuccess) _buildPopup(width),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.02,
                  top: height * 0.025,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gallery button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _pickImage(ImageSource.gallery);
                          },
                          child: Container(
                            width: width * 0.11,
                            height: width * 0.11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: _galleryImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        _galleryImage!,
                                        width: width * 0.095,
                                        height: width * 0.095,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.photo_library_outlined,
                                      color: Colors.white,
                                      size: width * 0.055,
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.028,
                          ),
                        ),
                      ],
                    ),

                    // ↓ reduced spacing here
                    SizedBox(width: width * 0.04),

                    // Camera shutter button
                    GestureDetector(
                      onTap: _captureImage,
                      child: Container(
                        width: width * 0.16,
                        height: width * 0.16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: width * 0.008,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.008),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ↓ reduced spacing here too
                    SizedBox(width: width * 0.04),

                    // Retry button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                              _prediction = "";
                              _accuracy = 0.0;
                              scanSuccess = false;
                              isScanning = false;
                            });
                            _setupCamera();
                          },
                          child: Container(
                            width: width * 0.11,
                            height: width * 0.11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.refresh_rounded,
                              size: width * 0.055,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Text(
                          "Retry",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.028,
                          ),
                        ),
                      ],
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

class ThinCornersPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;

  ThinCornersPainter({
    required this.color,
    this.strokeWidth = 3,
    this.cornerLength = 40,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerLength), paint);

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width - cornerLength, 0),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerLength),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(0, size.height - cornerLength),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerLength, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
