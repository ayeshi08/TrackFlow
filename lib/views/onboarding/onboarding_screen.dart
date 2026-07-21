// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import '../../service/background_service.dart';
// import '../../service/settings_service.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});
//
//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }
//
// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _pageController = PageController();
//   final SettingsService _settingsService = SettingsService();
//   int _currentPage = 0;
//   bool _isRequestingPermissions = false;
//
//   final List<_OnboardingPage> _pages = const [
//     _OnboardingPage(
//       icon: Icons.route,
//       title: 'Welcome to TrackFlow',
//       description:
//           'Record your journeys automatically. See distance, speed, and your route on a map.',
//       color: Color(0xFF3B82F6),
//     ),
//     _OnboardingPage(
//       icon: Icons.map_outlined,
//       title: 'Track Every Trip',
//       description:
//           'Start a trip before you travel. TrackFlow records your route even when the screen is off.',
//       color: Color(0xFF10B981),
//     ),
//     _OnboardingPage(
//       icon: Icons.location_on_outlined,
//       title: 'Location Access',
//       description:
//           'TrackFlow needs your location to measure distance and draw your route. '
//           'We only use location while a trip is active.',
//       color: Color(0xFFF59E0B),
//     ),
//     _OnboardingPage(
//       icon: Icons.battery_charging_full,
//       title: 'Reliable Tracking',
//       description:
//           'For best results, allow notifications and disable battery optimization for TrackFlow. '
//           'This keeps GPS running during your trip.',
//       color: Color(0xFF8B5CF6),
//     ),
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _finishOnboarding() async {
//     setState(() => _isRequestingPermissions = true);
//
//     // Request notification permission directly — no BackgroundService needed
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     await _settingsService.setOnboardingComplete();
//     if (!mounted) return;
//
//     final authVM = context.read<AuthViewModel>();
//     final isLoggedIn = await authVM.checkLoginStatus();
//     if (!mounted) return;
//
//     if (isLoggedIn) {
//       Navigator.pushReplacementNamed(context, '/home');
//     } else {
//       Navigator.pushReplacementNamed(context, '/login');
//     }
//   }
//
//   void _nextPage() {
//     if (_currentPage < _pages.length - 1) {
//       _pageController.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _finishOnboarding();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//     final isLastPage = _currentPage == _pages.length - 1;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * 0.05,
//                 vertical: h * 0.02,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (_currentPage > 0)
//                     TextButton(
//                       onPressed: () => _pageController.previousPage(
//                         duration: const Duration(milliseconds: 300),
//                         curve: Curves.easeInOut,
//                       ),
//                       child: Text(
//                         'Back',
//                         style: GoogleFonts.inter(color: Colors.white54),
//                       ),
//                     )
//                   else
//                     const SizedBox(width: 64),
//                   TextButton(
//                     onPressed: _finishOnboarding,
//                     child: Text(
//                       'Skip',
//                       style: GoogleFonts.inter(color: Colors.white38),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: PageView.builder(
//                 controller: _pageController,
//                 itemCount: _pages.length,
//                 onPageChanged: (i) => setState(() => _currentPage = i),
//                 itemBuilder: (context, index) {
//                   final page = _pages[index];
//                   return Padding(
//                     padding: EdgeInsets.symmetric(horizontal: w * 0.08),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: w * 0.28,
//                           height: w * 0.28,
//                           decoration: BoxDecoration(
//                             color: page.color.withOpacity(0.15),
//                             shape: BoxShape.circle,
//                           ),
//                           child: Icon(
//                             page.icon,
//                             color: page.color,
//                             size: w * 0.14,
//                           ),
//                         ),
//                         SizedBox(height: h * 0.04),
//                         Text(
//                           page.title,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: w * 0.065,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: h * 0.02),
//                         Text(
//                           page.description,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.inter(
//                             color: Colors.white60,
//                             fontSize: w * 0.04,
//                             height: 1.5,
//                           ),
//                         ),
//                         if (index == 2) ...[
//                           SizedBox(height: h * 0.03),
//                           Container(
//                             padding: EdgeInsets.all(w * 0.04),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF1A1A1A),
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(
//                                 color: Colors.orange.withOpacity(0.3),
//                               ),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.info_outline,
//                                   color: Colors.orange,
//                                   size: 18,
//                                 ),
//                                 SizedBox(width: w * 0.03),
//                                 Expanded(
//                                   child: Text(
//                                     'Background location is used only during active trips to record your full route.',
//                                     style: GoogleFonts.inter(
//                                       color: Colors.orange.shade200,
//                                       fontSize: w * 0.032,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(w * 0.06),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(_pages.length, (i) {
//                       return Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                         width: _currentPage == i ? 24 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: _currentPage == i
//                               ? const Color(0xFF3B82F6)
//                               : Colors.white24,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       );
//                     }),
//                   ),
//                   SizedBox(height: h * 0.025),
//                   SizedBox(
//                     width: double.infinity,
//                     height: h * 0.065,
//                     child: ElevatedButton(
//                       onPressed: _isRequestingPermissions ? null : _nextPage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: _isRequestingPermissions
//                           ? const SizedBox(
//                               width: 22,
//                               height: 22,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : Text(
//                               isLastPage
//                                   ? 'Enable Location & Get Started'
//                                   : 'Next',
//                               style: GoogleFonts.inter(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: w * 0.04,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _OnboardingPage {
//   final IconData icon;
//   final String title;
//   final String description;
//   final Color color;
//
//   const _OnboardingPage({
//     required this.icon,
//     required this.title,
//     required this.description,
//     required this.color,
//   });
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../service/settings_service.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final SettingsService _settingsService = SettingsService();
  int _currentPage = 0;
  bool _isRequestingPermissions = false;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(
      icon: Icons.route,
      title: 'Welcome to TrackFlow',
      description:
      'Record your journeys automatically. See distance, speed, and your route on a map.',
      color: Color(0xFF3B82F6),
    ),
    _OnboardingPage(
      icon: Icons.map_outlined,
      title: 'Track Every Trip',
      description:
      'Start a trip before you travel. TrackFlow records your route even when the screen is off.',
      color: Color(0xFF10B981),
    ),
    _OnboardingPage(
      icon: Icons.location_on_outlined,
      title: 'Location Access',
      description:
      'TrackFlow needs your location to measure distance and draw your route. '
          'We only use location while a trip is active.',
      color: Color(0xFFF59E0B),
    ),
    _OnboardingPage(
      icon: Icons.battery_charging_full,
      title: 'Reliable Tracking',
      description:
      'For best results, allow notifications and disable battery optimization for TrackFlow. '
          'This keeps GPS running during your trip.',
      color: Color(0xFF8B5CF6),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    setState(() => _isRequestingPermissions = true);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    await _settingsService.setOnboardingComplete();
    if (!mounted) return;

    final authVM = context.read<AuthViewModel>();
    final isLoggedIn = await authVM.checkLoginStatus();
    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: h * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(
                        'Back',
                        style: GoogleFonts.inter(color: Colors.white54),
                      ),
                    )
                  else
                    const SizedBox(width: 64),
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(color: Colors.white38),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: w * 0.28,
                          height: w * 0.28,
                          decoration: BoxDecoration(
                            color: page.color.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            color: page.color,
                            size: w * 0.14,
                          ),
                        ),
                        SizedBox(height: h * 0.04),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: w * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: h * 0.02),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: w * 0.04,
                            height: 1.5,
                          ),
                        ),
                        if (index == 2) ...[
                          SizedBox(height: h * 0.03),
                          Container(
                            padding: EdgeInsets.all(w * 0.04),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.orange.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Text(
                                    'Background location is used only during active trips to record your full route.',
                                    style: GoogleFonts.inter(
                                      color: Colors.orange.shade200,
                                      fontSize: w * 0.032,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(w * 0.06),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? const Color(0xFF3B82F6)
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: h * 0.025),
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: _isRequestingPermissions ? null : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isRequestingPermissions
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        isLastPage
                            ? 'Enable Location & Get Started'
                            : 'Next',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.04,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}