import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../service/settings_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../../widgets/cards/map_widget.dart';
import '../../widgets/trip_complete_sheet.dart';
import '../onboarding/background_location_disclosure_screen.dart';
import '../tripHistory/trip_history_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final w = MediaQuery.sizeOf(context).width;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       // Prevents the keyboard from forcing overflows on static elements
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor:
//             theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
//         elevation: 0,
//         title: Text(
//           'TrackFlow',
//           style: GoogleFonts.inter(
//             color: theme.colorScheme.onSurface,
//             fontWeight: FontWeight.bold,
//             fontSize: w > 600 ? 22 : 18,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.settings_outlined,
//               color: theme.colorScheme.onSurface,
//             ),
//             tooltip: 'Settings',
//             onPressed: () => Navigator.pushNamed(context, '/settings'),
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.person_outline,
//               color: theme.colorScheme.onSurface,
//             ),
//             tooltip: 'Profile',
//             onPressed: () => Navigator.pushNamed(context, '/profile'),
//           ),
//           IconButton(
//             icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
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
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Guest alert header strip
//             if (context.watch<AuthViewModel>().isGuest)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 10,
//                 ),
//                 color: Colors.orange.shade900.withOpacity(0.15),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.info_outline,
//                       color: Colors.orange,
//                       size: 16,
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         "You're in guest mode. Register to sync your trips.",
//                         style: GoogleFonts.inter(
//                           color: Colors.orange,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () => Navigator.pushNamed(context, '/login'),
//                       child: Text(
//                         'Sign In',
//                         style: GoogleFonts.inter(
//                           color: Colors.orange,
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//             Expanded(
//               child: Consumer2<HomeViewModel, SettingsViewModel>(
//                 builder: (context, vm, settingsVM, child) {
//                   // Post frame triggers for notices/modals
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     if (vm.tripDiscardReason != null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Row(
//                             children: [
//                               const Icon(
//                                 Icons.warning_amber,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Text(
//                                   vm.tripDiscardReason!,
//                                   style: GoogleFonts.inter(color: Colors.white),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           backgroundColor: Colors.orange.shade800,
//                           behavior: SnackBarBehavior.floating,
//                           duration: const Duration(seconds: 4),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       );
//                       vm.clearDiscardReason();
//                     }
//
//                     if (vm.hasRecoveredTrip && vm.recoveredTrip != null) {
//                       _showRecoveryDialog(context, vm);
//                     }
//                   });
//
//                   // Adaptive Layout Delivery using Orientation Builder
//                   return OrientationBuilder(
//                     builder: (context, orientation) {
//                       final isLandscape = orientation == Orientation.landscape;
//
//                       if (isLandscape) {
//                         return Row(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // Landscape Column Left: Map element gets the main visual gravity
//                             Expanded(
//                               flex: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(16),
//                                   child: MapWidget(
//                                     currentLocation: vm.currentLocation,
//                                     route:
//                                         vm.currentTrip?.route
//                                             .map((p) => LatLng(p.lat, p.lng))
//                                             .toList() ??
//                                         [],
//                                     followLive: vm.isTripActive,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Landscape Column Right: Scrolling controls dashboard
//                             Expanded(
//                               flex: 6,
//                               child: SingleChildScrollView(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Column(
//                                   children: _buildControlWidgets(
//                                     context,
//                                     vm,
//                                     settingsVM,
//                                     isLandscape,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//
//                       // Standard Portrait Workflow
//                       return Column(
//                         children: [
//                           Expanded(
//                             child: SingleChildScrollView(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 children: _buildControlWidgets(
//                                   context,
//                                   vm,
//                                   settingsVM,
//                                   isLandscape,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Sticky alert banner pinned safe at base layer
//                           if (vm.isTripActive && vm.showBackgroundWarning)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: theme.scaffoldBackgroundColor,
//                                 border: Border(
//                                   top: BorderSide(
//                                     color: theme.dividerColor.withOpacity(0.1),
//                                   ),
//                                 ), // <-- FIXED
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.warning_amber_rounded,
//                                     color: Colors.red,
//                                     size: 16,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       "For accurate tracking when screen is off, allow 'All the time' in Settings.",
//                                       style: GoogleFonts.inter(
//                                         color: Colors.red,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () => Geolocator.openAppSettings(),
//                                     child: Text(
//                                       "Fix",
//                                       style: GoogleFonts.inter(
//                                         color: theme.colorScheme.primary,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Unified controller view builder decoupling layout metrics blocks
//   List<Widget> _buildControlWidgets(
//     BuildContext context,
//     HomeViewModel vm,
//     SettingsViewModel settingsVM,
//     bool isLandscape,
//   ) {
//     final theme = Theme.of(context);
//     final w = MediaQuery.sizeOf(context).width;
//
//     return [
//       // Primary Trip Meter Wrapper
//       Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: theme.colorScheme.primary.withOpacity(0.25),
//           ),
//         ),
//         child: Column(
//           children: [
//             Text(
//               "Current Trip",
//               style: GoogleFonts.inter(
//                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//                 fontSize: 13,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               vm.duration,
//               style: GoogleFonts.inter(
//                 color: theme.colorScheme.onSurface,
//                 fontSize: isLandscape ? 32 : 38,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.5,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (vm.isTripActive)
//                   const _PulsingDot(color: Colors.green, size: 8)
//                 else
//                   Container(
//                     width: 8,
//                     height: 8,
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.onSurface.withOpacity(0.2),
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 const SizedBox(width: 6),
//                 Text(
//                   vm.isTripActive ? 'Recording trip...' : 'No active trip',
//                   style: GoogleFonts.inter(
//                     color: vm.isTripActive
//                         ? Colors.green
//                         : theme.colorScheme.onSurface.withOpacity(0.4),
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _statTile(
//                   context,
//                   "Distance",
//                   settingsVM.formatDistance(vm.currentTrip?.distance ?? 0),
//                   Icons.straighten,
//                 ),
//                 Container(
//                   width: 1,
//                   height: 32,
//                   color: theme.colorScheme.onSurface.withOpacity(0.1),
//                 ),
//                 _statTile(
//                   context,
//                   "Speed",
//                   settingsVM.formatSpeed(vm.currentSpeed),
//                   Icons.speed,
//                 ),
//               ],
//             ),
//             // Map renders here only when app is running in Portrait Mode
//             if (!isLandscape) ...[
//               const SizedBox(height: 16),
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: SizedBox(
//                   height: 180, // Safe absolute boundary layout footprint
//                   child: MapWidget(
//                     currentLocation: vm.currentLocation,
//                     route:
//                         vm.currentTrip?.route
//                             .map((p) => LatLng(p.lat, p.lng))
//                             .toList() ??
//                         [],
//                     followLive: vm.isTripActive,
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//
//       const SizedBox(height: 16),
//
//       // CORE ACTION CONTROLS INTERFACES
//       if (!vm.isTripActive && !vm.isPaused && !vm.isSaving)
//         SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: () => _handleStartTrip(context, vm),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: theme.colorScheme.primary,
//               foregroundColor: theme.colorScheme.onPrimary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               "START TRIP",
//               style: GoogleFonts.inter(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//
//       if (vm.isTripActive || vm.isPaused) ...[
//         SizedBox(
//           width: double.infinity,
//           height: 46,
//           child: ElevatedButton(
//             onPressed: vm.isTripActive ? vm.pauseTrip : vm.resumeTrip,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: vm.isTripActive ? Colors.orange : Colors.green,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text(
//               vm.isTripActive ? "PAUSE TRIP" : "RESUME TRIP",
//               style: GoogleFonts.inter(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//
//       if (vm.isTripActive || vm.isPaused || vm.isSaving) ...[
//         SizedBox(
//           width: double.infinity,
//           height: 48,
//           child: ElevatedButton(
//             onPressed: vm.isTripActive && !vm.isSaving
//                 ? () async {
//                     final completedTrip = await vm.stopTrip();
//                     if (!context.mounted) return;
//                     if (completedTrip != null) {
//                       await TripCompleteSheet.show(
//                         context,
//                         trip: completedTrip,
//                         onViewHistory: () async {
//                           await vm.loadTrips();
//                           if (context.mounted) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => const TripHistoryScreen(),
//                               ),
//                             );
//                           }
//                         },
//                       );
//                     }
//                   }
//                 : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red.shade700,
//               foregroundColor: Colors.white,
//               disabledBackgroundColor: Colors.red.withOpacity(0.2),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: vm.isSaving
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(
//                         width: 18,
//                         height: 18,
//                         child: CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         "Saving trip...",
//                         style: GoogleFonts.inter(color: Colors.white),
//                       ),
//                     ],
//                   )
//                 : Text(
//                     "STOP TRIP",
//                     style: GoogleFonts.inter(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                     ),
//                   ),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//
//       // VIEW HISTORY BUTTON LINK
//       SizedBox(
//         width: double.infinity,
//         height: 46,
//         child: OutlinedButton(
//           onPressed: () async {
//             await vm.loadTrips();
//             if (context.mounted) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const TripHistoryScreen()),
//               );
//             }
//           },
//           style: OutlinedButton.styleFrom(
//             foregroundColor: theme.colorScheme.primary,
//             side: BorderSide(color: theme.colorScheme.primary),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: Text(
//             "View Trip History",
//             style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
//           ),
//         ),
//       ),
//
//       const SizedBox(height: 16),
//
//       // WEEKLY DASHBOARD METRICS SUMMARY CARD
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _weeklyTile(
//               context,
//               "This Week",
//               "${vm.weeklyTrips} trips",
//               Icons.calendar_today,
//             ),
//             Container(
//               width: 1,
//               height: 32,
//               color: theme.colorScheme.onSurface.withOpacity(0.1),
//             ),
//             _weeklyTile(
//               context,
//               "Distance",
//               settingsVM.formatDistance(vm.weeklyDistance),
//               Icons.route,
//             ),
//             Container(
//               width: 1,
//               height: 32,
//               color: theme.colorScheme.onSurface.withOpacity(0.1),
//             ),
//             _weeklyTile(
//               context,
//               "CO2 Saved",
//               "${settingsVM.co2SavedKg(vm.weeklyDistance).toStringAsFixed(1)} kg",
//               Icons.eco,
//             ),
//           ],
//         ),
//       ),
//     ];
//   }
//
//   Future<void> _handleStartTrip(BuildContext context, HomeViewModel vm) async {
//     final theme = Theme.of(context);
//     final settingsService = SettingsService();
//     final alreadyShown = await settingsService.hasShownLocationDisclosure();
//
//     if (!alreadyShown && context.mounted) {
//       final proceeded = await Navigator.push<bool>(
//         context,
//         MaterialPageRoute(
//           builder: (_) => const BackgroundLocationDisclosureScreen(),
//         ),
//       );
//       if (proceeded != true) return;
//       await settingsService.setLocationDisclosureShown();
//     }
//
//     if (!context.mounted) return;
//
//     final error = await vm.startTrip();
//     if (error == null || !context.mounted) return;
//
//     // Helper closure layout for generating clean alerts dynamically without styling duplication
//     void showLocationAlert(String title, String desc, {List<Widget>? actions}) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           backgroundColor:
//               theme.dialogBackgroundColor ?? theme.colorScheme.surface,
//           title: Text(
//             title,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Text(
//             desc,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//           actions:
//               actions ??
//               [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     "OK",
//                     style: GoogleFonts.inter(color: theme.colorScheme.primary),
//                   ),
//                 ),
//               ],
//         ),
//       );
//     }
//
//     if (error == "GPS_OFF") {
//       showLocationAlert(
//         "GPS Required",
//         "Please turn on GPS to start tracking.",
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel", style: TextStyle(color: theme.hintColor)),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await Geolocator.openLocationSettings();
//             },
//             child: Text(
//               "Turn On",
//               style: TextStyle(color: theme.colorScheme.primary),
//             ),
//           ),
//         ],
//       );
//     } else if (error == "DENIED_FOREVER") {
//       showLocationAlert(
//         "Permission Required",
//         "Location permission was permanently denied. Please enable it in Settings → Apps → TrackFlow → Permissions.",
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Cancel", style: TextStyle(color: theme.hintColor)),
//           ),
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(context);
//               await Geolocator.openAppSettings();
//             },
//             child: Text(
//               "Open Settings",
//               style: TextStyle(color: theme.colorScheme.primary),
//             ),
//           ),
//         ],
//       );
//     } else if (error == "BACKGROUND_ONLY") {
//       showDialog<bool>(
//         context: context,
//         builder: (_) => AlertDialog(
//           backgroundColor:
//               theme.dialogBackgroundColor ?? theme.colorScheme.surface,
//           title: Text(
//             "Limited Tracking",
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Text(
//             "Without 'Allow all the time' location access, TrackFlow can't record your trip accurately when the screen is off.\n\nFor best accuracy, select 'Allow all the time' under Location permissions.",
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface.withOpacity(0.7),
//               fontSize: 14,
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: Text(
//                 "Continue Anyway",
//                 style: TextStyle(color: theme.hintColor),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.pop(context, false);
//                 await Geolocator.openAppSettings();
//               },
//               child: Text(
//                 "Open Settings",
//                 style: TextStyle(color: theme.colorScheme.primary),
//               ),
//             ),
//           ],
//         ),
//       ).then((continueAnyway) async {
//         if (continueAnyway == true && context.mounted) {
//           final hVM = context.read<HomeViewModel>();
//           hVM.showBackgroundWarning = true;
//           await hVM.startTrip(skipBackgroundPermission: true);
//         }
//       });
//     } else {
//       showLocationAlert("Location Error", error);
//     }
//   }
//
//   void _showRecoveryDialog(BuildContext context, HomeViewModel vm) {
//     final theme = Theme.of(context);
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) => AlertDialog(
//         backgroundColor:
//             theme.dialogBackgroundColor ?? theme.colorScheme.surface,
//         title: Text(
//           'Unsaved Trip Found',
//           style: GoogleFonts.inter(
//             color: theme.colorScheme.onSurface,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: Text(
//           'It looks like your last trip didn\'t finish properly. We found ${vm.recoveredTrip!.distance.toStringAsFixed(2)} km of recorded distance.\n\nWould you like to save it or discard it?',
//           style: GoogleFonts.inter(
//             color: theme.colorScheme.onSurface.withOpacity(0.7),
//             fontSize: 14,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               await vm.discardRecoveredTrip();
//             },
//             child: Text(
//               'Discard',
//               style: GoogleFonts.inter(color: Colors.red.shade400),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               Navigator.pop(dialogContext);
//               await vm.saveRecoveredTrip();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: theme.colorScheme.primary,
//             ),
//             child: Text(
//               'Save Trip',
//               style: GoogleFonts.inter(color: theme.colorScheme.onPrimary),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statTile(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//   ) {
//     final theme = Theme.of(context);
//     return Expanded(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: theme.colorScheme.primary, size: 20),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface.withOpacity(0.5),
//               fontSize: 11,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             value,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _weeklyTile(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//   ) {
//     final theme = Theme.of(context);
//     return Expanded(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, color: theme.colorScheme.primary, size: 18),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface.withOpacity(0.5),
//               fontSize: 10,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             value,
//             style: GoogleFonts.inter(
//               color: theme.colorScheme.onSurface,
//               fontSize: 12,
//               fontWeight: FontWeight.bold,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<HomeViewModel>();
      vm.addListener(_handleViewModelNotifications);
    });
  }

  @override
  void dispose() {
    context.read<HomeViewModel>().removeListener(_handleViewModelNotifications);
    super.dispose();
  }

  void _handleViewModelNotifications() {
    final vm = context.read<HomeViewModel>();
    if (!mounted) return;

    if (vm.tripDiscardReason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  vm.tripDiscardReason!,
                  style: GoogleFonts.inter(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
      vm.clearDiscardReason();
    }

    if (vm.hasRecoveredTrip && vm.recoveredTrip != null) {
      _showRecoveryDialog(context, vm);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'TrackFlow',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: w > 600 ? 22 : 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Profile',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: theme.colorScheme.onSurface),
            tooltip: 'Logout',
            onPressed: () async {
              await context.read<AuthViewModel>().logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (context.watch<AuthViewModel>().isGuest)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                color: Colors.orange.shade900.withOpacity(0.15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "You're in guest mode. Register to sync your trips.",
                        style: GoogleFonts.inter(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.inter(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: OrientationBuilder(
                builder: (context, orientation) {
                  final isLandscape = orientation == Orientation.landscape;

                  if (isLandscape) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Selector<HomeViewModel, List<LatLng>>(
                                selector: (_, vm) =>
                                    vm.currentTrip?.route
                                        .map((p) => LatLng(p.lat, p.lng))
                                        .toList() ??
                                    [],
                                builder: (context, routePoints, _) {
                                  final vm = context.read<HomeViewModel>();
                                  return MapWidget(
                                    currentLocation: vm.currentLocation,
                                    route: routePoints,
                                    followLive: vm.isTripActive,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(12.0),
                            child: TripControlPanel(
                              isLandscape: isLandscape,
                              handleStartTrip: _handleStartTrip,
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: TripControlPanel(
                            isLandscape: isLandscape,
                            handleStartTrip: _handleStartTrip,
                          ),
                        ),
                      ),
                      Consumer<HomeViewModel>(
                        builder: (context, vm, _) {
                          if (vm.isTripActive && vm.showBackgroundWarning) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                border: Border(
                                  top: BorderSide(
                                    color: theme.dividerColor.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "For accurate tracking when screen is off, allow 'All the time' in Settings.",
                                      style: GoogleFonts.inter(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Geolocator.openAppSettings(),
                                    child: Text(
                                      "Fix",
                                      style: GoogleFonts.inter(
                                        color: theme.colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStartTrip(BuildContext context, HomeViewModel vm) async {
    final theme = Theme.of(context);
    final settingsService = SettingsService();
    final alreadyShown = await settingsService.hasShownLocationDisclosure();

    if (!alreadyShown && context.mounted) {
      final proceeded = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) => const BackgroundLocationDisclosureScreen(),
        ),
      );
      if (proceeded != true) return;
      await settingsService.setLocationDisclosureShown();
    }

    if (!context.mounted) return;

    final error = await vm.startTrip();
    if (error == null || !context.mounted) return;

    void showLocationAlert(String title, String desc, {List<Widget>? actions}) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor:
              theme.dialogBackgroundColor ?? theme.colorScheme.surface,
          title: Text(
            title,
            style: GoogleFonts.inter(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            desc,
            style: GoogleFonts.inter(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          actions:
              actions ??
              [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "OK",
                    style: GoogleFonts.inter(color: theme.colorScheme.primary),
                  ),
                ),
              ],
        ),
      );
    }

    if (error == "GPS_OFF") {
      showLocationAlert(
        "GPS Required",
        "Please turn on GPS to start tracking.",
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: theme.hintColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: Text(
              "Turn On",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      );
    } else if (error == "DENIED_FOREVER") {
      showLocationAlert(
        "Permission Required",
        "Location permission was permanently denied. Please enable it in Settings → Apps → TrackFlow → Permissions.",
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: theme.hintColor)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openAppSettings();
            },
            child: Text(
              "Open Settings",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      );
    } else if (error == "BACKGROUND_ONLY") {
      showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor:
              theme.dialogBackgroundColor ?? theme.colorScheme.surface,
          title: Text(
            "Limited Tracking",
            style: GoogleFonts.inter(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Without 'Allow all the time' location access, TrackFlow can't record your trip accurately when the screen is off.\n\nFor best accuracy, select 'Allow all the time' under Location permissions.",
            style: GoogleFonts.inter(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                "Continue Anyway",
                style: TextStyle(color: theme.hintColor),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context, false);
                await Geolocator.openAppSettings();
              },
              child: Text(
                "Open Settings",
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        ),
      ).then((continueAnyway) async {
        if (continueAnyway == true && context.mounted) {
          final hVM = context.read<HomeViewModel>();
          hVM.showBackgroundWarning = true;
          await hVM.startTrip(skipBackgroundPermission: true);
        }
      });
    } else {
      showLocationAlert("Location Error", error);
    }
  }

  void _showRecoveryDialog(BuildContext context, HomeViewModel vm) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor:
            theme.dialogBackgroundColor ?? theme.colorScheme.surface,
        title: Text(
          'Unsaved Trip Found',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'It looks like your last trip didn\'t finish properly. We found ${vm.recoveredTrip!.distance.toStringAsFixed(2)} km of recorded distance.\n\nWould you like to save it or discard it?',
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await vm.discardRecoveredTrip();
            },
            child: Text(
              'Discard',
              style: GoogleFonts.inter(color: Colors.red.shade400),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await vm.saveRecoveredTrip();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Text(
              'Save Trip',
              style: GoogleFonts.inter(color: theme.colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class TripControlPanel extends StatelessWidget {
  final bool isLandscape;
  final Future<void> Function(BuildContext, HomeViewModel) handleStartTrip;

  const TripControlPanel({
    super.key,
    required this.isLandscape,
    required this.handleStartTrip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.25),
            ),
          ),
          child: Column(
            children: [
              Text(
                "Current Trip",
                style: GoogleFonts.inter(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Consumer<HomeViewModel>(
                builder: (_, vm, __) => Text(
                  vm.duration,
                  style: GoogleFonts.inter(
                    color: theme.colorScheme.onSurface,
                    fontSize: isLandscape ? 32 : 38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const _TripStatusIndicator(),
              const SizedBox(height: 16),
              const _RealtimeStatsRow(),
              if (!isLandscape) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 180,
                    child: Selector<HomeViewModel, List<LatLng>>(
                      selector: (_, vm) =>
                          vm.currentTrip?.route
                              .map((p) => LatLng(p.lat, p.lng))
                              .toList() ??
                          [],
                      // 🌟 MAGIC LINE: Yeh line check karegi agar list ki length same hai to rebuild nahi karegi
                      shouldRebuild: (previous, next) =>
                          previous.length == next.length,
                      builder: (context, routePoints, _) {
                        final vm = context.read<HomeViewModel>();
                        return MapWidget(
                          currentLocation: vm.currentLocation,
                          route: routePoints,
                          followLive: vm.isTripActive,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _StartTripButtonSection(),
        const _PauseResumeButtonSection(),
        const _StopTripButtonSection(),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: () async {
              final vm = context.read<HomeViewModel>();
              await vm.loadTrips();
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TripHistoryScreen()),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "View Trip History",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const _WeeklyDashboardPanel(),
      ],
    );
  }
}

class _TripStatusIndicator extends StatelessWidget {
  const _TripStatusIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HomeViewModel>(
      builder: (_, vm, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (vm.isTripActive)
            const _PulsingDot(color: Colors.green, size: 8)
          else
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 6),
          Text(
            vm.isTripActive ? 'Recording trip...' : 'No active trip',
            style: GoogleFonts.inter(
              color: vm.isTripActive
                  ? Colors.green
                  : theme.colorScheme.onSurface.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _RealtimeStatsRow extends StatelessWidget {
  const _RealtimeStatsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer2<HomeViewModel, SettingsViewModel>(
      builder: (_, vm, settingsVM, __) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statTile(
            context,
            "Distance",
            settingsVM.formatDistance(vm.currentTrip?.distance ?? 0),
            Icons.straighten,
          ),
          Container(
            width: 1,
            height: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
          _statTile(
            context,
            "Speed",
            settingsVM.formatSpeed(vm.currentSpeed),
            Icons.speed,
          ),
        ],
      ),
    );
  }

  Widget _statTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 11,
            // fontFamily likhne ki zaroorat nahi hai, yeh automatically 'Inter' uthayega!
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight
                .bold, // Bold weights automatically assets se map ho jayenge
          ),
        ),
      ],
    );
  }
}

class _StartTripButtonSection extends StatelessWidget {
  const _StartTripButtonSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HomeViewModel>(
      builder: (context, vm, _) {
        if (!vm.isTripActive && !vm.isPaused && !vm.isSaving) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  final panel = context
                      .findAncestorWidgetOfExactType<TripControlPanel>();
                  if (panel != null) {
                    panel.handleStartTrip(context, vm);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "START TRIP",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _PauseResumeButtonSection extends StatelessWidget {
  const _PauseResumeButtonSection();

  @override
  Widget build(BuildContext context) {
    return Selector<HomeViewModel, TupleFlags>(
      selector: (_, vm) => TupleFlags(vm.isTripActive, vm.isPaused),
      builder: (context, flags, _) {
        final vm = context.read<HomeViewModel>();
        if (flags.isTripActive || flags.isPaused) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: flags.isTripActive ? vm.pauseTrip : vm.resumeTrip,
                style: ElevatedButton.styleFrom(
                  backgroundColor: flags.isTripActive
                      ? Colors.orange
                      : Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  flags.isTripActive ? "PAUSE TRIP" : "RESUME TRIP",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// 🛠️ Iske liye bhi helper class:
class TupleFlags {
  final bool isTripActive;
  final bool isPaused;

  TupleFlags(this.isTripActive, this.isPaused);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TupleFlags &&
          isTripActive == other.isTripActive &&
          isPaused == other.isPaused;

  @override
  int get hashCode => isTripActive.hashCode ^ isPaused.hashCode;
}

class _StopTripButtonSection extends StatelessWidget {
  const _StopTripButtonSection();

  @override
  Widget build(BuildContext context) {
    // ❌ Pehle pooray HomeViewModel ka Consumer tha, ab specific Selector lagayein:
    return Selector<HomeViewModel, TripleFlags>(
      selector: (_, vm) =>
          TripleFlags(vm.isTripActive, vm.isPaused, vm.isSaving),
      builder: (context, flags, _) {
        final vm = context
            .read<HomeViewModel>(); // Data read karne ke liye safe read

        if (flags.isTripActive || flags.isPaused || flags.isSaving) {
          return SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: flags.isTripActive && !flags.isSaving
                  ? () async {
                      final completedTrip = await vm.stopTrip();
                      if (!context.mounted) return;
                      if (completedTrip != null) {
                        await TripCompleteSheet.show(
                          context,
                          trip: completedTrip,
                          onViewHistory: () async {
                            await vm.loadTrips();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const TripHistoryScreen(),
                                ),
                              );
                            }
                          },
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.red.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: flags.isSaving
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Saving trip...",
                          style: GoogleFonts.inter(color: Colors.white),
                        ),
                      ],
                    )
                  : Text(
                      "STOP TRIP",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _WeeklyDashboardPanel extends StatelessWidget {
  const _WeeklyDashboardPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Hamne Consumer2 hata kar pure panel ko static kar diya
    // Aur specific values ke liye independent Selectors lagaye hain
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Selector 1: Sirf trips change hone par chalega (Bohat kam)
          Selector<HomeViewModel, int>(
            selector: (_, vm) => vm.weeklyTrips,
            builder: (context, trips, _) {
              return WeeklyTile(
                title: "This Week",
                value: "$trips trips",
                icon: Icons.calendar_today,
              );
            },
          ),
          Container(
            width: 1,
            height: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),

          // Selector 2: Distance update par chalega
          Selector2<HomeViewModel, SettingsViewModel, String>(
            selector: (_, homeVM, settingsVM) =>
                settingsVM.formatDistance(homeVM.weeklyDistance),
            builder: (context, formattedDistance, _) {
              return WeeklyTile(
                title: "Distance",
                value: formattedDistance,
                icon: Icons.route,
              );
            },
          ),
          Container(
            width: 1,
            height: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),

          // Selector 3: CO2 update par chalega
          Selector2<HomeViewModel, SettingsViewModel, double>(
            selector: (_, homeVM, settingsVM) =>
                settingsVM.co2SavedKg(homeVM.weeklyDistance),
            builder: (context, co2Saved, _) {
              return WeeklyTile(
                title: "CO2 Saved",
                value: "${co2Saved.toStringAsFixed(1)} kg",
                icon: Icons.eco,
              );
            },
          ),
        ],
      ),
    );
  }
}

class WeeklyTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const WeeklyTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 18),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const _PulsingDot({required this.color, required this.size});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: const Icon(Icons.location_on), // 🌟 Cache child
      builder: (context, cachedChild) {
        return Transform.scale(
          scale: _controller.value,
          child: cachedChild, // Dubara rebuild nahi hoga
        );
      },
    );
  }
}

class TripleFlags {
  final bool isTripActive;
  final bool isPaused;
  final bool isSaving;

  TripleFlags(this.isTripActive, this.isPaused, this.isSaving);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripleFlags &&
          runtimeType == other.runtimeType &&
          isTripActive == other.isTripActive &&
          isPaused == other.isPaused &&
          isSaving == other.isSaving;

  @override
  int get hashCode =>
      isTripActive.hashCode ^ isPaused.hashCode ^ isSaving.hashCode;
}

// class TupleFlags {
//   final bool isTripActive;
//   final bool isPaused;
//   TupleFlags(this.isTripActive, this.isPaused);
//
//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TupleFlags &&
//           isTripActive == other.isTripActive &&
//           isPaused == other.isPaused;
//
//   @override
//   int get hashCode => isTripActive.hashCode ^ isPaused.hashCode;
// }
