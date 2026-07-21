// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:provider/provider.dart';
// import '../model/trip_model.dart';
// import '../viewmodels/settings_viewmodel.dart';
// import 'cards/map_widget.dart';
//
// class TripCompleteSheet extends StatelessWidget {
//   final Trip trip;
//   final VoidCallback onViewHistory;
//   final VoidCallback onDone;
//
//   const TripCompleteSheet({
//     super.key,
//     required this.trip,
//     required this.onViewHistory,
//     required this.onDone,
//   });
//
//   static Future<void> show(
//     BuildContext context, {
//     required Trip trip,
//     required VoidCallback onViewHistory,
//   }) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (ctx) => TripCompleteSheet(
//         trip: trip,
//         onViewHistory: () {
//           Navigator.pop(ctx);
//           onViewHistory();
//         },
//         onDone: () => Navigator.pop(ctx),
//       ),
//     );
//   }
//
//   String _formatDuration(Trip trip) {
//     if (trip.endTime == null) return '00:00:00';
//     final diff = trip.endTime!.difference(trip.startTime);
//     final h = diff.inHours.toString().padLeft(2, '0');
//     final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
//     final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
//     return '$h:$m:$s';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     final h = MediaQuery.of(context).size.height;
//     final settings = context.watch<SettingsViewModel>();
//     final route = trip.route.map((p) => LatLng(p.lat, p.lng)).toList();
//
//     return Container(
//       margin: EdgeInsets.all(w * 0.04),
//       padding: EdgeInsets.all(w * 0.05),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1A2E),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.4)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 48,
//             height: 5,
//             decoration: BoxDecoration(
//               color: Colors.white24,
//               borderRadius: BorderRadius.circular(4),
//             ),
//           ),
//           SizedBox(height: h * 0.02),
//           Icon(
//             Icons.check_circle,
//             color: Colors.green.shade400,
//             size: w * 0.14,
//           ),
//           SizedBox(height: h * 0.012),
//           Text(
//             'Trip Complete!',
//             style: GoogleFonts.inter(
//               color: Colors.white,
//               fontSize: w * 0.055,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: h * 0.006),
//           Text(
//             trip.isSynced
//                 ? 'Saved and synced'
//                 : 'Saved locally — will sync when online',
//             style: GoogleFonts.inter(
//               color: trip.isSynced
//                   ? Colors.green.shade300
//                   : Colors.orange.shade300,
//               fontSize: w * 0.032,
//             ),
//           ),
//           SizedBox(height: h * 0.02),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _stat('Duration', _formatDuration(trip), w),
//               _stat('Distance', settings.formatDistance(trip.distance), w),
//               _stat('Avg Speed', settings.formatSpeed(trip.avgSpeed), w),
//             ],
//           ),
//           SizedBox(height: h * 0.012),
//           Text(
//             'CO₂ saved: ${settings.co2SavedKg(trip.distance).toStringAsFixed(2)} kg',
//             style: GoogleFonts.inter(
//               color: Colors.green.shade300,
//               fontSize: w * 0.033,
//             ),
//           ),
//           SizedBox(height: h * 0.016),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: SizedBox(
//               height: h * 0.18,
//               width: double.infinity,
//               child: MapWidget(
//                 route: route,
//                 currentLocation: route.isNotEmpty ? route.last : null,
//               ),
//             ),
//           ),
//           SizedBox(height: h * 0.02),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: onViewHistory,
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: const Color(0xFF3B82F6),
//                     side: const BorderSide(color: Color(0xFF3B82F6)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: h * 0.016),
//                   ),
//                   child: Text(
//                     'View History',
//                     style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//               SizedBox(width: w * 0.03),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: onDone,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF3B82F6),
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(vertical: h * 0.016),
//                   ),
//                   child: Text(
//                     'Done',
//                     style: GoogleFonts.inter(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: h * 0.01),
//         ],
//       ),
//     );
//   }
//
//   Widget _stat(String label, String value, double w) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.028),
//         ),
//         SizedBox(height: 4),
//         Text(
//           value,
//           style: GoogleFonts.inter(
//             color: Colors.white,
//             fontSize: w * 0.035,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../model/trip_model.dart';
import '../viewmodels/settings_viewmodel.dart';
import 'cards/map_widget.dart';

class TripCompleteSheet extends StatelessWidget {
  final Trip trip;
  final VoidCallback onViewHistory;
  final VoidCallback onDone;

  const TripCompleteSheet({
    super.key,
    required this.trip,
    required this.onViewHistory,
    required this.onDone,
  });

  static Future<void> show(
      BuildContext context, {
        required Trip trip,
        required VoidCallback onViewHistory,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => TripCompleteSheet(
        trip: trip,
        onViewHistory: () {
          Navigator.pop(ctx);
          onViewHistory();
        },
        onDone: () => Navigator.pop(ctx),
      ),
    );
  }

  String _formatDuration(Trip trip) {
    if (trip.endTime == null) return '00:00:00';
    final diff = trip.endTime!.difference(trip.startTime);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final settings = context.watch<SettingsViewModel>();
    final route = trip.route.map((p) => LatLng(p.lat, p.lng)).toList();

    return Container(
      margin: EdgeInsets.all(w * 0.04),
      padding: EdgeInsets.all(w * 0.05),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.4)),
      ),
      child: SingleChildScrollView( // Keeps layout safe when rotated to landscape
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: h * 0.02),
            Icon(
              Icons.check_circle,
              color: Colors.green.shade400,
              size: w * 0.14,
            ),
            SizedBox(height: h * 0.012),
            Text(
              'Trip Complete!',
              style: GoogleFonts.inter(
                color: theme.colorScheme.onSurface,
                fontSize: w * 0.055,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.006),
            Text(
              trip.isSynced
                  ? 'Saved and synced'
                  : 'Saved locally — will sync when online',
              style: GoogleFonts.inter(
                color: trip.isSynced
                    ? Colors.green.shade300
                    : Colors.orange.shade300,
                fontSize: w * 0.032,
              ),
            ),
            SizedBox(height: h * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat('Duration', _formatDuration(trip), w, theme),
                _stat('Distance', settings.formatDistance(trip.distance), w, theme),
                _stat('Avg Speed', settings.formatSpeed(trip.avgSpeed), w, theme),
              ],
            ),
            SizedBox(height: h * 0.012),
            Text(
              'CO₂ saved: ${settings.co2SavedKg(trip.distance).toStringAsFixed(2)} kg',
              style: GoogleFonts.inter(
                color: Colors.green.shade300,
                fontSize: w * 0.033,
              ),
            ),
            SizedBox(height: h * 0.016),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: h * 0.18,
                width: double.infinity,
                child: MapWidget(
                  route: route,
                  currentLocation: route.isNotEmpty ? route.last : null,
                ),
              ),
            ),
            SizedBox(height: h * 0.02),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewHistory,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: h * 0.016),
                    ),
                    child: Text(
                      'View History',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(width: w * 0.03),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: h * 0.016),
                    ),
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.01),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value, double w, ThemeData theme) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: w * 0.028,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: theme.colorScheme.onSurface,
            fontSize: w * 0.035,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}