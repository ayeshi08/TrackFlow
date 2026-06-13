// // // import 'dart:async';
// // // import 'package:flutter/material.dart';
// // // import '../../core/theme.dart';
// // // import '../login/login_screen.dart';
// // //
// // // class SplashScreen extends StatefulWidget {
// // //   const SplashScreen({super.key});
// // //
// // //   @override
// // //   State<SplashScreen> createState() => _SplashScreenState();
// // // }
// // //
// // // class _SplashScreenState extends State<SplashScreen> {
// // //   double progress = 0.0;
// // //
// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     Timer.periodic(const Duration(milliseconds: 100), (timer) {
// // //       setState(() {
// // //         progress += 0.02;
// // //       });
// // //
// // //       if (progress >= 1) {
// // //         timer.cancel();
// // //         Navigator.pushReplacement(
// // //           context,
// // //           MaterialPageRoute(builder: (_) => const LoginScreen()),
// // //         );
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final size = MediaQuery.of(context).size;
// // //
// // //     return Scaffold(
// // //       body: Container(
// // //         width: size.width,
// // //         height: size.height,
// // //         decoration: const BoxDecoration(
// // //           gradient: LinearGradient(
// // //             colors: [Color(0xFFE8CDAF), Color(0xFF8E9EAB)],
// // //             begin: Alignment.topCenter,
// // //             end: Alignment.bottomCenter,
// // //           ),
// // //         ),
// // //         child: Padding(
// // //           padding: const EdgeInsets.symmetric(horizontal: 24),
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               const Icon(Icons.local_shipping,
// // //                   size: 80, color: AppTheme.primaryColor),
// // //               const SizedBox(height: 20),
// // //               const Text(
// // //                 "TrackFlow",
// // //                 style: TextStyle(
// // //                   fontSize: 28,
// // //                   fontWeight: FontWeight.bold,
// // //                 ),
// // //               ),
// // //               const Text("SMART FLEET MANAGEMENT"),
// // //               const SizedBox(height: 50),
// // //               LinearProgressIndicator(
// // //                 value: progress,
// // //                 minHeight: 8,
// // //                 borderRadius: BorderRadius.circular(12),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               Text("${(progress * 100).toInt()}%"),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import '../../viewmodels/splash_viewmodel.dart';
// // import '../login/login_screen.dart';
// //
// // class SplashScreen extends StatefulWidget {
// //   const SplashScreen({super.key});
// //   @override
// //   State<SplashScreen> createState() => _SplashScreenState();
// // }
// //
// // class _SplashScreenState extends State<SplashScreen> {
// //   final SplashViewModel vm = SplashViewModel();
// //   double progress = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     vm.startTimer(
// //           (p) => setState(() => progress = p),
// //           () => Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (_) => const LoginScreen()),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     // keep your UI intact
// //     return Scaffold(
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Icon(Icons.local_shipping, size: 80),
// //             const SizedBox(height: 20),
// //             LinearProgressIndicator(value: progress),
// //             Text("${(progress * 100).toInt()}%"),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../../core/theme.dart';
// import '../login/login_screen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   double progress = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     Timer.periodic(const Duration(milliseconds: 50), (timer) {
//       setState(() {
//         progress += 0.02;
//       });
//       if (progress >= 1) {
//         timer.cancel();
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const LoginScreen()),
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         width: size.width,
//         height: size.height,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFE8CDAF), Color(0xFF8E9EAB)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.local_shipping,
//                   size: 80, color: AppTheme.primaryColor),
//               const SizedBox(height: 20),
//               const Text(
//                 "TrackFlow",
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Text("SMART FLEET MANAGEMENT"),
//               const SizedBox(height: 50),
//               LinearProgressIndicator(
//                 value: progress,
//                 minHeight: 8,
//                 backgroundColor: Colors.white54,
//                 color: AppTheme.primaryColor,
//               ),
//               const SizedBox(height: 12),
//               Text("${(progress * 100).toInt()}%"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
