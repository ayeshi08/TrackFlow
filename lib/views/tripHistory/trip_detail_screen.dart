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
    final theme = Theme.of(context);
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

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

    final mapWidgetBlock = startLocation != null
        ? MapWidget(
            route: route,
            startLocation: startLocation,
            endLocation: endLocation,
            currentLocation: endLocation,
          )
        : Container(
            color: theme.cardColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    color: theme.hintColor.withOpacity(0.3),
                    size: 44,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No GPS data recorded',
                    style: GoogleFonts.inter(
                      color: theme.hintColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );

    final detailsContentBlock = [
      Text(
        'Trip Summary',
        style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.titleLarge?.color,
        ),
      ),
      const SizedBox(height: 12),

      // Stats grid
      Row(
        children: [
          _statBox(
            context,
            'Distance',
            '${trip.distance.toStringAsFixed(2)} km',
            Icons.straighten,
          ),
          const SizedBox(width: 12),
          _statBox(
            context,
            'Duration',
            _formatDuration(trip.startTime, trip.endTime),
            Icons.timer,
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _statBox(
            context,
            'Avg Speed',
            '${trip.avgSpeed.toStringAsFixed(1)} km/h',
            Icons.speed,
          ),
          const SizedBox(width: 12),
          _statBox(
            context,
            'GPS Points',
            '${trip.route.length} recorded',
            Icons.location_on,
          ),
        ],
      ),

      const SizedBox(height: 16),
      _row(context, 'Start Time', _formatTime(trip.startTime)),
      _row(context, 'End Time', _formatTime(trip.endTime)),
      const SizedBox(height: 16),

      // Status badge
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: hasMovement
              ? Colors.green.withOpacity(0.1)
              : Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasMovement
                ? Colors.green.withOpacity(0.3)
                : Colors.orange.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasMovement ? Icons.check_circle : Icons.warning,
              color: hasMovement ? Colors.green : Colors.orange,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hasMovement
                    ? 'Trip completed with movement recorded'
                    : 'No movement recorded',
                style: GoogleFonts.inter(
                  color: hasMovement ? Colors.green : Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Trip Details',
          style: GoogleFonts.inter(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconTheme.color),
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return Row(
                children: [
                  Expanded(flex: 5, child: mapWidgetBlock),
                  Expanded(
                    flex: 6,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailsContentBlock,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  SizedBox(height: h * 0.40, child: mapWidgetBlock),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(w * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: detailsContentBlock,
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _statBox(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF3B82F6), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: theme.hintColor,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
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

  Widget _row(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(color: theme.hintColor, fontSize: 13),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
