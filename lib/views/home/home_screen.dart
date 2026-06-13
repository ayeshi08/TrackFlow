// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/auth_viewmodel.dart';
// import '../../viewmodels/home_viewmodel.dart';
// import '../../widgets/cards/map_widget.dart';
// import '../tripHistory/trip_history_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//
//
//
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         title: Text('TrackFlow',
//             style: GoogleFonts.inter(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person_outline, color: Colors.white),
//             tooltip: 'Profile',
//             onPressed: () => Navigator.pushNamed(context, '/profile'),
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: Colors.white),
//             tooltip: 'Logout',
//             onPressed: () async {
//               await context.read<AuthViewModel>().logout();
//               if (context.mounted) {
//                 Navigator.pushReplacementNamed(context, '/login');
//               }
//             },
//           ),
//         ],
//       ),
//       body: Consumer<HomeViewModel>(
//         builder: (context, vm, child) {
//
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (vm.tripDiscardReason != null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Row(
//                     children: [
//                       const Icon(Icons.warning_amber,
//                           color: Colors.white, size: 20),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           vm.tripDiscardReason!,
//                           style: GoogleFonts.inter(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                   backgroundColor: Colors.orange.shade800,
//                   behavior: SnackBarBehavior.floating,
//                   duration: const Duration(seconds: 4),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               );
//               vm.clearDiscardReason();
//             }
//           });
//           return SafeArea(
//               child: Column(
//                   children: [
//
//               // Guest banner
//               if (context.watch<AuthViewModel>().isGuest)
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 16, vertical: 10),
//             color: Colors.orange.shade900.withOpacity(0.3),
//             child: Row(
//               children: [
//                 const Icon(Icons.info_outline,
//                     color: Colors.orange, size: 16),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     'You\'re in guest mode. Register to sync your trips.',
//                     style: GoogleFonts.inter(
//                         color: Colors.orange, fontSize: 12),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () =>
//                       Navigator.pushNamed(context, '/login'),
//                   child: Text('Sign Up',
//                       style: GoogleFonts.inter(
//                           color: Colors.orange,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ),
//
//           // Rest of screen
//           Expanded(
//           child: SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   // CURRENT TRIP CARD
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1A1A2E),
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
//                     ),
//                     child: Column(
//                       children: [
//                         Text("Current Trip",
//                             style: GoogleFonts.inter(
//                                 color: Colors.white70, fontSize: 13)),
//
//                         const SizedBox(height: 12),
//
//                         // TIMER — always visible, shows 00:00:00 when no trip
//                         Text(
//                           vm.duration,
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 40,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 2,
//                           ),
//                         ),
//
//                         const SizedBox(height: 4),
//
//                         // Active indicator
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: 8, height: 8,
//                               decoration: BoxDecoration(
//                                 color: vm.isTripActive
//                                     ? Colors.green
//                                     : Colors.white24,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                             const SizedBox(width: 6),
//                             Text(
//                               vm.isTripActive
//                                   ? 'Trip in progress'
//                                   : 'No active trip',
//                               style: GoogleFonts.inter(
//                                 color: vm.isTripActive
//                                     ? Colors.green
//                                     : Colors.white38,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         // Distance and Speed
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             _statTile(
//                               "Distance",
//                               vm.distanceText,
//                               Icons.straighten,
//                             ),
//                             Container(
//                               width: 1, height: 40,
//                               color: Colors.white12,
//                             ),
//                             _statTile(
//                               "Speed",
//                               "${vm.currentSpeed.toStringAsFixed(1)} km/h",
//                               Icons.speed,
//                             ),
//                           ],
//                         ),
//
//                         const SizedBox(height: 16),
//
//                         // MAP
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: SizedBox(
//                             height: 220,
//                             child: MapWidget(
//                               currentLocation: vm.currentLocation,
//                               route: vm.currentTrip?.route
//                                   .map((p) => LatLng(p.lat, p.lng))
//                                   .toList() ??
//                                   [],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // ==============================
//                   // START BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: vm.isTripActive || vm.isSaving
//                           ? null
//                           : () async {
//                         final error = await vm.startTrip();
//                         if (error == null) return;
//                         if (!context.mounted) return;
//                         if (error == "GPS_OFF") {
//                           showDialog(
//                             context: context,
//                             builder: (_) => AlertDialog(
//                               backgroundColor: const Color(0xFF1A1A1A),
//                               title: Text("GPS Required",
//                                   style: GoogleFonts.inter(
//                                       color: Colors.white)),
//                               content: Text(
//                                   "Please turn on GPS to start tracking.",
//                                   style: GoogleFonts.inter(
//                                       color: Colors.white70)),
//                               actions: [
//                                 TextButton(
//                                     onPressed: () =>
//                                         Navigator.pop(context),
//                                     child: Text("Cancel",
//                                         style: GoogleFonts.inter(
//                                             color: Colors.white54))),
//                                 TextButton(
//                                     onPressed: () async {
//                                       Navigator.pop(context);
//                                       await Geolocator
//                                           .openLocationSettings();
//                                     },
//                                     child: Text("Turn On",
//                                         style: GoogleFonts.inter(
//                                             color: const Color(
//                                                 0xFF3B82F6)))),
//                               ],
//                             ),
//                           );
//                           return;
//                         }
//                         showDialog(
//                           context: context,
//                           builder: (_) => AlertDialog(
//                             backgroundColor: const Color(0xFF1A1A1A),
//                             title: Text("Location Error",
//                                 style: GoogleFonts.inter(
//                                     color: Colors.white)),
//                             content: Text(error,
//                                 style: GoogleFonts.inter(
//                                     color: Colors.white70)),
//                             actions: [
//                               TextButton(
//                                   onPressed: () =>
//                                       Navigator.pop(context),
//                                   child: Text("OK",
//                                       style: GoogleFonts.inter(
//                                           color: const Color(
//                                               0xFF3B82F6)))),
//                             ],
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor:
//                         const Color(0xFF3B82F6).withOpacity(0.3),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: Text("START TRIP",
//                           style: GoogleFonts.inter(
//                               fontWeight: FontWeight.bold, fontSize: 15)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // ==============================
//                   // STOP BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: vm.isTripActive && !vm.isSaving
//                           ? () async => vm.stopTrip()
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red.shade700,
//                         foregroundColor: Colors.white,
//                         disabledBackgroundColor:
//                         Colors.red.withOpacity(0.2),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: vm.isSaving
//                           ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const SizedBox(
//                             width: 18, height: 18,
//                             child: CircularProgressIndicator(
//                                 color: Colors.white, strokeWidth: 2),
//                           ),
//                           const SizedBox(width: 10),
//                           Text("Saving trip...",
//                               style: GoogleFonts.inter(
//                                   color: Colors.white)),
//                         ],
//                       )
//                           : Text("STOP TRIP",
//                           style: GoogleFonts.inter(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 15)),
//                     ),
//                   ),
// // TESTING ONLY — remove before release
//                   if (vm.isTripActive)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8),
//                       child: SizedBox(
//                         width: double.infinity,
//                         height: 44,
//                         child: OutlinedButton(
//                           onPressed: () => vm.addFakePoint(),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.yellow,
//                             side: const BorderSide(color: Colors.yellow),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           child: Text('FAKE MOVE (Testing)',
//                               style: GoogleFonts.inter(
//                                   color: Colors.yellow, fontSize: 13)),
//                         ),
//                       ),
//                     ),
//                   const SizedBox(height: 16),
//
//                   // ==============================
//                   // VIEW HISTORY BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     height: 48,
//                     child: OutlinedButton(
//                       onPressed: () async {
//                         await vm.loadTrips();
//                         if (context.mounted) {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (_) =>
//                                   const TripHistoryScreen()));
//                         }
//                       },
//                       style: OutlinedButton.styleFrom(
//                         foregroundColor: Colors.white,
//                         side: const BorderSide(color: Color(0xFF3B82F6)),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       child: Text("View Trip History",
//                           style: GoogleFonts.inter(
//                               color: const Color(0xFF3B82F6),
//                               fontWeight: FontWeight.w600)),
//                     ),
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // ==============================
//                   // WEEKLY STATS
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1A1A1A),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child:
//           Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _weeklyTile("This Week",
//                             "${vm.weeklyTrips} trips", Icons.calendar_today),
//                         Container(width: 1, height: 40, color: Colors.white12),
//                         _weeklyTile("Total Dist",
//                             "${vm.weeklyDistance.toStringAsFixed(2)} km",
//                             Icons.route),
//                         Container(width: 1, height: 40, color: Colors.white12),
//                         _weeklyTile("CO2 Saved",
//                             "${(vm.weeklyDistance * 0.12).toStringAsFixed(2)} kg",
//                             Icons.eco),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//           )])  );
//         },
//       ),
//     );
//   }
//
//   Widget _statTile(String title, String value, IconData icon) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, color: const Color(0xFF3B82F6), size: 20),
//           const SizedBox(height: 4),
//           Text(title,
//               style: GoogleFonts.inter(
//                   color: Colors.white54, fontSize: 11)),
//           Text(value,
//               style: GoogleFonts.inter(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   Widget _weeklyTile(String title, String value, IconData icon) {
//     return Expanded(
//       child: Column(
//         children: [
//           Icon(icon, color: const Color(0xFF3B82F6), size: 18),
//           const SizedBox(height: 4),
//           Text(title,
//               style: GoogleFonts.inter(
//                   color: Colors.white54, fontSize: 11)),
//           Text(value,
//               style: GoogleFonts.inter(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/cards/map_widget.dart';
import '../tripHistory/trip_history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), elevation: 0,
        title: Text('TrackFlow', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: w * 0.05)),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.white), tooltip: 'Profile', onPressed: () => Navigator.pushNamed(context, '/profile')),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white), tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthViewModel>().logout();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, vm, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (vm.tripDiscardReason != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Row(children: [
                  const Icon(Icons.warning_amber, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(vm.tripDiscardReason!, style: GoogleFonts.inter(color: Colors.white))),
                ]),
                backgroundColor: Colors.orange.shade800, behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ));
              vm.clearDiscardReason();
            }
          });

          return SafeArea(
            child: Column(children: [
              // Guest banner
              if (context.watch<AuthViewModel>().isGuest)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.012),
                  color: Colors.orange.shade900.withOpacity(0.3),
                  child: Row(children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 16),
                    SizedBox(width: w * 0.02),
                    Expanded(child: Text('Guest mode — register to sync trips.', style: GoogleFonts.inter(color: Colors.orange, fontSize: w * 0.032))),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text('Sign Up', style: GoogleFonts.inter(color: Colors.orange, fontSize: w * 0.032, fontWeight: FontWeight.bold)),
                    ),
                  ]),
                ),

              Expanded(child: SingleChildScrollView(
                padding: EdgeInsets.all(w * 0.04),
                child: Column(children: [

                  // Current Trip Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
                    ),
                    child: Column(children: [
                      Text("Current Trip", style: GoogleFonts.inter(color: Colors.white70, fontSize: w * 0.033)),
                      SizedBox(height: h * 0.012),
                      // Timer
                      Text(vm.duration, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.1, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      SizedBox(height: h * 0.005),
                      // Active indicator
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: vm.isTripActive ? Colors.green : Colors.white24, shape: BoxShape.circle)),
                        SizedBox(width: w * 0.015),
                        Text(vm.isTripActive ? 'Trip in progress' : 'No active trip', style: GoogleFonts.inter(color: vm.isTripActive ? Colors.green : Colors.white38, fontSize: w * 0.03)),
                      ]),
                      SizedBox(height: h * 0.016),
                      // Distance and Speed
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        _statTile("Distance", vm.distanceText, Icons.straighten, w),
                        Container(width: 1, height: 40, color: Colors.white12),
                        _statTile("Speed", "${vm.currentSpeed.toStringAsFixed(1)} km/h", Icons.speed, w),
                      ]),
                      SizedBox(height: h * 0.016),
                      // Map
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          height: h * 0.28,
                          child: MapWidget(
                            currentLocation: vm.currentLocation,
                            route: vm.currentTrip?.route.map((p) => LatLng(p.lat, p.lng)).toList() ?? [],
                          ),
                        ),
                      ),
                    ]),
                  ),

                  SizedBox(height: h * 0.025),

                  // START BUTTON
                  SizedBox(
                    width: double.infinity, height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: vm.isTripActive || vm.isSaving ? null : () async {
                        final error = await vm.startTrip();
                        if (error == null) return;
                        if (!context.mounted) return;
                        if (error == "GPS_OFF") {
                          showDialog(context: context, builder: (_) => AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1A),
                            title: Text("GPS Required", style: GoogleFonts.inter(color: Colors.white)),
                            content: Text("Please turn on GPS to start tracking.", style: GoogleFonts.inter(color: Colors.white70)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel", style: GoogleFonts.inter(color: Colors.white54))),
                              TextButton(onPressed: () async { Navigator.pop(context); await Geolocator.openLocationSettings(); }, child: Text("Turn On", style: GoogleFonts.inter(color: const Color(0xFF3B82F6)))),
                            ],
                          ));
                          return;
                        }
                        showDialog(context: context, builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A1A),
                          title: Text("Location Error", style: GoogleFonts.inter(color: Colors.white)),
                          content: Text(error, style: GoogleFonts.inter(color: Colors.white70)),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK", style: GoogleFonts.inter(color: const Color(0xFF3B82F6))))],
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6), foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF3B82F6).withOpacity(0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("START TRIP", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: w * 0.038)),
                    ),
                  ),

                  SizedBox(height: h * 0.012),

                  // STOP BUTTON
                  SizedBox(
                    width: double.infinity, height: h * 0.065,
                    child: ElevatedButton(
                      onPressed: vm.isTripActive && !vm.isSaving ? () async => vm.stopTrip() : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700, foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.red.withOpacity(0.2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: vm.isSaving
                          ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                        SizedBox(width: w * 0.025),
                        Text("Saving trip...", style: GoogleFonts.inter(color: Colors.white)),
                      ])
                          : Text("STOP TRIP", style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: w * 0.038)),
                    ),
                  ),

                  // FAKE MOVE button — remove before Play Store release
                  if (vm.isTripActive)
                    Padding(
                      padding: EdgeInsets.only(top: h * 0.01),
                      child: SizedBox(
                        width: double.infinity, height: h * 0.055,
                        child: OutlinedButton(
                          onPressed: () => vm.addFakePoint(),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.yellow, side: const BorderSide(color: Colors.yellow), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          child: Text('FAKE MOVE (Testing)', style: GoogleFonts.inter(color: Colors.yellow, fontSize: w * 0.033)),
                        ),
                      ),
                    ),

                  SizedBox(height: h * 0.016),

                  // VIEW HISTORY
                  SizedBox(
                    width: double.infinity, height: h * 0.06,
                    child: OutlinedButton(
                      onPressed: () async {
                        await vm.loadTrips();
                        if (context.mounted) Navigator.push(context, MaterialPageRoute(builder: (_) => const TripHistoryScreen()));
                      },
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Color(0xFF3B82F6)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: Text("View Trip History", style: GoogleFonts.inter(color: const Color(0xFF3B82F6), fontWeight: FontWeight.w600, fontSize: w * 0.037)),
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  // Weekly Stats
                  Container(
                    padding: EdgeInsets.all(w * 0.04),
                    decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(16)),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _weeklyTile("This Week", "${vm.weeklyTrips} trips", Icons.calendar_today, w),
                      Container(width: 1, height: 40, color: Colors.white12),
                      _weeklyTile("Distance", "${vm.weeklyDistance.toStringAsFixed(2)} km", Icons.route, w),
                      Container(width: 1, height: 40, color: Colors.white12),
                      _weeklyTile("CO2 Saved", "${(vm.weeklyDistance * 0.12).toStringAsFixed(2)} kg", Icons.eco, w),
                    ]),
                  ),

                  SizedBox(height: h * 0.016),
                ]),
              )),
            ]),
          );
        },
      ),
    );
  }

  Widget _statTile(String title, String value, IconData icon, double w) {
    return Expanded(child: Column(children: [
      Icon(icon, color: const Color(0xFF3B82F6), size: w * 0.05),
      SizedBox(height: 4),
      Text(title, style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.028)),
      Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.038, fontWeight: FontWeight.bold)),
    ]));
  }

  Widget _weeklyTile(String title, String value, IconData icon, double w) {
    return Expanded(child: Column(children: [
      Icon(icon, color: const Color(0xFF3B82F6), size: w * 0.045),
      SizedBox(height: 4),
      Text(title, style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.026)),
      Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.032, fontWeight: FontWeight.bold)),
    ]));
  }
}