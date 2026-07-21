// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:trackflow/themes/app_theme.dart';
// import 'package:trackflow/viewmodels/auth_viewmodel.dart';
// import 'package:trackflow/viewmodels/connectivity_viewmodel.dart';
// import 'package:trackflow/viewmodels/home_viewmodel.dart';
// import 'package:trackflow/viewmodels/settings_viewmodel.dart';
// import 'package:trackflow/views/home/home_screen.dart';
// import 'package:trackflow/views/auth/login_screen.dart';
// import 'package:trackflow/views/auth/reset_password_screen.dart';
// import 'package:trackflow/views/profile/profile_screen.dart';
// import 'package:trackflow/views/settings/settings_screen.dart';
// import 'package:trackflow/views/onboarding/onboarding_screen.dart';
// import 'package:trackflow/service/settings_service.dart';
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     DevicePreview(
//       enabled: !kReleaseMode, // Only enables preview in debug mode
//       builder: (context) => MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => AuthViewModel()),
//           ChangeNotifierProvider(create: (_) => HomeViewModel()),
//           // ChangeNotifierProvider(create: (_) => TripViewModel()),
//           ChangeNotifierProvider(create: (_) => SettingsViewModel()),
//           ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
//         ],
//         child: const MyApp(),
//       ),
//     ),
//   );
// }
//
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final settingsVM = context.watch<SettingsViewModel>();
//
//     return MaterialApp(
//       title: 'TrackFlow',
//       debugShowCheckedModeBanner: false,
//
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//
//       themeMode: settingsVM.themeMode,
//
//       home: const SplashRouter(),
//
//       routes: {
//         '/home': (_) => const HomeScreen(),
//         '/login': (_) => const LoginScreen(),
//         '/profile': (_) => const ProfileScreen(),
//         '/settings': (_) => const SettingsScreen(),
//         '/reset-password': (_) => const ResetPasswordScreen(),
//       },
//     );
//   }
// }
//
// class SplashRouter extends StatefulWidget {
//   const SplashRouter({super.key});
//
//   @override
//   State<SplashRouter> createState() => _SplashRouterState();
// }
//
// class _SplashRouterState extends State<SplashRouter>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   late Animation<double> _pulseAnimation;
//
//   late Animation<double> _fadeAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//
//     _pulseAnimation = Tween<double>(
//       begin: 1,
//       end: 1.3,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//
//     _fadeAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
//
//     _controller.repeat(reverse: true);
//
//     _checkLogin();
//   }
//
//   Future<void> _checkLogin() async {
//     final onboardingDone = await SettingsService().isOnboardingComplete();
//
//     if (!mounted) return;
//
//     if (!onboardingDone) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const OnboardingScreen()),
//       );
//       return;
//     }
//
//     final authVM = context.read<AuthViewModel>();
//
//     final isLoggedIn = await authVM.checkLoginStatus();
//
//     if (!mounted) return;
//
//     if (isLoggedIn) {
//       Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//     } else {
//       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1628),
//
//       body: Center(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//
//             children: [
//               AnimatedBuilder(
//                 animation: _pulseAnimation,
//
//                 builder: (_, child) {
//                   return Transform.scale(
//                     scale: _pulseAnimation.value,
//
//                     child: Container(
//                       width: 120,
//                       height: 120,
//
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//
//                         border: Border.all(
//                           color: const Color(0xFF3B82F6),
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//
//               Transform.translate(
//                 offset: const Offset(0, -120),
//
//                 child: const Icon(
//                   Icons.location_on,
//                   size: 72,
//                   color: Color(0xFF3B82F6),
//                 ),
//               ),
//
//               const SizedBox(height: 24),
//
//               const Text(
//                 'TrackFlow',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 30,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               const Text(
//                 'Smart Trip Tracking',
//                 style: TextStyle(color: Colors.white54, fontSize: 14),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackflow/themes/app_theme.dart';
import 'package:trackflow/viewmodels/auth_viewmodel.dart';
import 'package:trackflow/viewmodels/connectivity_viewmodel.dart';
import 'package:trackflow/viewmodels/home_viewmodel.dart';
import 'package:trackflow/viewmodels/settings_viewmodel.dart';
import 'package:trackflow/views/home/home_screen.dart';
import 'package:trackflow/views/auth/login_screen.dart';
import 'package:trackflow/views/auth/reset_password_screen.dart';
import 'package:trackflow/views/profile/profile_screen.dart';
import 'package:trackflow/views/settings/settings_screen.dart';
import 'package:trackflow/views/onboarding/onboarding_screen.dart';
import 'package:trackflow/service/settings_service.dart';
void main() {
  //debugPrintRebuildDirtyWidgets = true;

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewModel()),
          ChangeNotifierProvider(create: (_) => SettingsViewModel()),
          ChangeNotifierProvider(create: (_) => ConnectivityViewModel()),
        ],
        child: const MyApp(), //
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();

    return MaterialApp(
      title: 'TrackFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settingsVM.themeMode,
      home: const SplashRouter(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.textScalerOf(context).clamp(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.25,
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: child!,
          ),
        );
      },
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/reset-password': (_) => const ResetPasswordScreen(),
      },
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseAnimation = Tween<double>(
      begin: 0.85,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _fadeAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    final onboardingDone = await SettingsService().isOnboardingComplete();

    if (!mounted) return;

    if (!onboardingDone) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();
    final isLoggedIn = await authVM.checkLoginStatus();

    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Use media query text scaling factor to compute safe responsive limits
    final textScaleFactor = MediaQuery.textScalerOf(context).scale(1.0);

    // Dynamic responsive clamp equations: baseSize * textScaleFactor constrained between min and max bounds
    final titleFontSize = (32.0 * textScaleFactor).clamp(26.0, 38.0);
    final subtitleFontSize = (14.0 * textScaleFactor).clamp(12.0, 18.0);

    final primaryTextColor = isDark ? Colors.white : Colors.black87;
    final secondaryTextColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF3B82F6).withOpacity(0.08),
                            border: Border.all(
                              color: const Color(0xFF3B82F6).withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: (_pulseAnimation.value * 0.85),
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF3B82F6).withOpacity(0.12),
                          ),
                        ),
                      ),
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3B82F6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.explore,
                          size: 44,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        top: 22,
                        right: 22,
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              Text(
                'TrackFlow',
                style: TextStyle(
                  color: primaryTextColor,
                  fontSize: titleFontSize, // 🌟 Responsive clamped size
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Smart Trip Tracking',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: subtitleFontSize, // 🌟 Responsive clamped size
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}