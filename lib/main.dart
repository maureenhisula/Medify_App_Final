import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

void main() {
  runApp(const MedifyApp());
}

class MedifyApp extends StatelessWidget {
  const MedifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: InitialScreen(),
        );
      },
    );
  }
}

// 🔍 Initial Screen - Checks if first launch
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (!mounted) return;

    if (isFirstLaunch) {
      // First launch - show splash and onboarding
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SplashScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      // Not first launch - go directly to home with fade transition
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show Medify logo while checking
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/medify_logo.png",
              width: 170.w,
              height: 170.h,
            ),
          ],
        ),
      ),
    );
  }
}

// 🌿 Splash Screen Animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoFadeController;
  late AnimationController _dropController;
  late AnimationController _expandController;
  late AnimationController _textController;
  late AnimationController _popupController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _dropAnimation;
  late Animation<double> _expandAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _popupAnimation;

  int _textIndex = 0;
  bool _showLanding = false;
  bool _showText = false;
  bool _showLogo = true;

  final List<String> _texts = [
    "Welcome to Medify!",
    "Identify Nature's Cure",
    "Unlock the Power of Plants",
  ];

  @override
  void initState() {
    super.initState();

    _logoFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _logoFadeController, curve: Curves.easeOut),
    );

    _dropAnimation = Tween<double>(begin: -50.h, end: 0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.easeOutBack),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _expandController, curve: Curves.easeOutCubic),
    );

    _textFadeAnimation = TweenSequence([
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 60),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_textController);

    _textScaleAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 25),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 3.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_textController);

    _textSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 0),
          end: const Offset(0, -0.05),
        ).animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeInOut),
        );

    _popupAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeOutBack),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    // Show logo for 1.5 seconds
    await Future.delayed(const Duration(milliseconds: 1500));

    // Fade out logo
    await _logoFadeController.forward();
    setState(() => _showLogo = false);

    // Start the green circle animation
    await _dropController.forward();
    await _expandController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _showText = true);

    for (int i = 0; i < _texts.length; i++) {
      setState(() => _textIndex = i);
      await _textController.forward();
      if (i < _texts.length - 1) {
        _textController.reset();
      }
    }

    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _showLanding = true);
    await _popupController.forward();
  }

  @override
  void dispose() {
    _logoFadeController.dispose();
    _dropController.dispose();
    _expandController.dispose();
    _textController.dispose();
    _popupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([
              _logoFadeController,
              _dropController,
              _expandController,
              _textController,
            ]),
            builder: (context, child) {
              final centerY = size.height / 2 + _dropAnimation.value;

              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_showLogo)
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/medify_logo.png",
                            width: 170.w,
                            height: 170.h,
                          ),
                        ],
                      ),
                    ),
                  ClipPath(
                    clipper: CircleRevealClipper(
                      fraction: _expandAnimation.value,
                      center: Offset(size.width / 2, centerY),
                      size: size,
                    ),
                    child: Container(color: Colors.green),
                  ),
                  if (_showText)
                    SlideTransition(
                      position: _textSlideAnimation,
                      child: ScaleTransition(
                        scale: _textScaleAnimation,
                        child: FadeTransition(
                          opacity: _textFadeAnimation,
                          child: Text(
                            _texts[_textIndex],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),

          if (_showLanding)
            ScaleTransition(
              scale: _popupAnimation,
              child: OnboardingScreen(popupController: _popupController),
            ),
        ],
      ),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;
  final Size size;

  CircleRevealClipper({
    required this.fraction,
    required this.center,
    required this.size,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final finalRadius = sqrt(
      pow(this.size.width, 2) + pow(this.size.height, 2),
    );
    final radius = finalRadius * fraction;
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) =>
      fraction != oldClipper.fraction || center != oldClipper.center;
}

// 🌱 Onboarding Screen
class OnboardingScreen extends StatefulWidget {
  final AnimationController popupController;
  const OnboardingScreen({super.key, required this.popupController});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _plantController;
  late AnimationController _panelController;

  late Animation<double> _plantScale;
  late Animation<double> _plantFade;
  late Animation<double> _panelScale;
  late Animation<double> _panelFade;

  @override
  void initState() {
    super.initState();

    _plantController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _plantScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _plantController, curve: Curves.easeOutBack),
    );

    _plantFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _plantController, curve: Curves.easeIn));

    _panelScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _panelController, curve: Curves.easeOutBack),
    );

    _panelFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _panelController, curve: Curves.easeIn));

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _plantController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    await _panelController.forward();
  }

  @override
  void dispose() {
    _plantController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 100.h),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Medify",
                    style: TextStyle(
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(255, 64, 147, 67),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Medicinal Plants Identification",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromARGB(221, 70, 70, 70),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      FadeTransition(
                        opacity: _plantFade,
                        child: ScaleTransition(
                          scale: _plantScale,
                          child: Image.asset(
                            "assets/images/plant.png",
                            width: 350.w,
                            height: 350.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      FadeTransition(
                        opacity: _panelFade,
                        child: ScaleTransition(
                          scale: _panelScale,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 16.h,
                              ),
                              margin: EdgeInsets.only(top: 20.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/plant.png",
                                    width: 50.w,
                                    height: 50.h,
                                  ),
                                  SizedBox(width: 14.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Oregano",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(width: 30.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF4CAF50),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: Text(
                                              "99%",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Tap for details",
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: Text(
                "Identify medicinal plants with ease and confidence – Unlock natural remedies with just a tap.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 26.w),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () => _completeOnboarding(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
    );
  }
}
