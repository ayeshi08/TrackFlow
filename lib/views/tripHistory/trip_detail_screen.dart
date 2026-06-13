// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import '../../model/trip_model.dart';
// import '../../widgets/cards/map_widget.dart';
//
// class TripDetailScreen extends StatelessWidget {
//   final Trip trip;
//
//   const TripDetailScreen({super.key, required this.trip});
//
//   String _formatDuration(DateTime start, DateTime? end) {
//     if (end == null) return '--';
//     final diff = end.difference(start);
//     final h = diff.inHours.toString().padLeft(2, '0');
//     final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
//     final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
//     return '$h:$m:$s';
//   }
//
//   String _formatTime(DateTime? dt) {
//     if (dt == null) return '--';
//     return '${dt.hour.toString().padLeft(2, '0')}:'
//         '${dt.minute.toString().padLeft(2, '0')} '
//         '${dt.day}/${dt.month}/${dt.year}';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final route =
//     trip.route.map((p) => LatLng(p.lat, p.lng)).toList();
//
//     LatLng? startLocation;
//     LatLng? endLocation;
//
//     if (route.isNotEmpty) {
//       startLocation = route.first;
//       endLocation = route.last;
//     } else if (trip.startLat != 0 && trip.startLng != 0) {
//       startLocation = LatLng(trip.startLat, trip.startLng);
//       endLocation = startLocation;
//     }
//
//     final hasMovement = route.length > 1;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         title: Text('Trip Details',
//             style: GoogleFonts.inter(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           // MAP
//           Expanded(
//             child: startLocation != null
//                 ? MapWidget(
//               route: route,
//               startLocation: startLocation,
//               endLocation: endLocation,
//               currentLocation: endLocation,
//             )
//                 : Container(
//               color: const Color(0xFF1A1A1A),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.location_off,
//                         color: Colors.white24, size: 48),
//                     const SizedBox(height: 12),
//                     Text('No GPS data recorded',
//                         style: GoogleFonts.inter(
//                             color: Colors.white38,
//                             fontSize: 15)),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // INFO PANEL
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             decoration: const BoxDecoration(
//               color: Color(0xFF1A1A1A),
//               borderRadius:
//               BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Trip Summary',
//                     style: GoogleFonts.inter(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white)),
//
//                 const SizedBox(height: 16),
//
//                 // Stats grid
//                 Row(
//                   children: [
//                     _statBox('Distance',
//                         '${trip.distance.toStringAsFixed(2)} km',
//                         Icons.straighten),
//                     const SizedBox(width: 12),
//                     _statBox('Duration',
//                         _formatDuration(trip.startTime, trip.endTime),
//                         Icons.timer),
//                   ],
//                 ),
//
//                 const SizedBox(height: 12),
//
//                 Row(
//                   children: [
//                     _statBox('Avg Speed',
//                         '${trip.avgSpeed.toStringAsFixed(1)} km/h',
//                         Icons.speed),
//                     const SizedBox(width: 12),
//                     _statBox('Points',
//                         '${trip.route.length} recorded',
//                         Icons.location_on),
//                   ],
//                 ),
//
//                 const SizedBox(height: 16),
//
//                 // Time info
//                 _row('Start Time', _formatTime(trip.startTime)),
//                 _row('End Time', _formatTime(trip.endTime)),
//
//                 const SizedBox(height: 12),
//
//                 // Status badge
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: hasMovement
//                         ? Colors.green.withOpacity(0.1)
//                         : Colors.orange.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: hasMovement
//                           ? Colors.green.withOpacity(0.3)
//                           : Colors.orange.withOpacity(0.3),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         hasMovement
//                             ? Icons.check_circle
//                             : Icons.warning,
//                         color: hasMovement
//                             ? Colors.green
//                             : Colors.orange,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           hasMovement
//                               ? 'Trip completed with movement recorded'
//                               : 'No movement recorded',
//                           style: GoogleFonts.inter(
//                             color: hasMovement
//                                 ? Colors.green
//                                 : Colors.orange,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _statBox(String title, String value, IconData icon) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const Color(0xFF0A0A0A),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: const Color(0xFF3B82F6), size: 20),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title,
//                       style: GoogleFonts.inter(
//                           color: Colors.white54, fontSize: 11)),
//                   Text(value,
//                       style: GoogleFonts.inter(
//                           color: Colors.white,
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _row(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: GoogleFonts.inter(
//                   color: Colors.white54, fontSize: 13)),
//           Text(value,
//               style: GoogleFonts.inter(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../model/trip_model.dart';
import '../../widgets/cards/map_widget.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;
  const TripDetailScreen({super.key, required this.trip});

  String _formatDuration(DateTime start, DateTime? end) {
    if (end == null) return '--';
    final diff = end.difference(start);
    final h = diff.inHours.toString().padLeft(2, '0');
    final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
    final s = (diff.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '--';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}/${dt.month}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final route = trip.route.map((p) => LatLng(p.lat, p.lng)).toList();

    LatLng? startLocation;
    LatLng? endLocation;
    if (route.isNotEmpty) {
      startLocation = route.first;
      endLocation = route.last;
    } else if (trip.startLat != 0 && trip.startLng != 0) {
      startLocation = LatLng(trip.startLat, trip.startLng);
      endLocation = startLocation;
    }

    final hasMovement = route.length > 1;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), elevation: 0,
        title: Text('Trip Details', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: w * 0.048)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(children: [
        // Map
        SizedBox(
          height: h * 0.42,
          child: startLocation != null
              ? MapWidget(route: route, startLocation: startLocation, endLocation: endLocation, currentLocation: endLocation)
              : Container(color: const Color(0xFF1A1A1A), child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.location_off, color: Colors.white24, size: 48),
            SizedBox(height: h * 0.012),
            Text('No GPS data recorded', style: GoogleFonts.inter(color: Colors.white38, fontSize: 15)),
          ]))),
        ),

        // Info panel
        Expanded(child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.05),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Trip Summary', style: GoogleFonts.inter(fontSize: w * 0.048, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: h * 0.016),

            // Stats grid
            Row(children: [
              _statBox('Distance', '${trip.distance.toStringAsFixed(2)} km', Icons.straighten, w, h),
              SizedBox(width: w * 0.03),
              _statBox('Duration', _formatDuration(trip.startTime, trip.endTime), Icons.timer, w, h),
            ]),
            SizedBox(height: h * 0.012),
            Row(children: [
              _statBox('Avg Speed', '${trip.avgSpeed.toStringAsFixed(1)} km/h', Icons.speed, w, h),
              SizedBox(width: w * 0.03),
              _statBox('GPS Points', '${trip.route.length} recorded', Icons.location_on, w, h),
            ]),

            SizedBox(height: h * 0.016),
            _row('Start Time', _formatTime(trip.startTime), w),
            _row('End Time', _formatTime(trip.endTime), w),
            SizedBox(height: h * 0.012),

            // Status badge
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.03),
              decoration: BoxDecoration(
                color: hasMovement ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: hasMovement ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3)),
              ),
              child: Row(children: [
                Icon(hasMovement ? Icons.check_circle : Icons.warning, color: hasMovement ? Colors.green : Colors.orange, size: 18),
                SizedBox(width: w * 0.02),
                Expanded(child: Text(
                  hasMovement ? 'Trip completed with movement recorded' : 'No movement recorded',
                  style: GoogleFonts.inter(color: hasMovement ? Colors.green : Colors.orange, fontSize: w * 0.033, fontWeight: FontWeight.w500),
                )),
              ]),
            ),
          ]),
        )),
      ]),
    );
  }

  Widget _statBox(String title, String value, IconData icon, double w, double h) {
    return Expanded(child: Container(
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(10)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF3B82F6), size: w * 0.05),
        SizedBox(width: w * 0.02),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.028)),
          Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.033, fontWeight: FontWeight.w600)),
        ])),
      ]),
    ));
  }

  Widget _row(String title, String value, double w) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.033)),
        Text(value, style: GoogleFonts.inter(color: Colors.white, fontSize: w * 0.033, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}