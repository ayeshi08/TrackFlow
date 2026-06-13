import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final List<LatLng> route;
  final LatLng? currentLocation;
  final LatLng? startLocation;
  final LatLng? endLocation;

  const MapWidget({
    super.key,
    required this.route,
    this.currentLocation,
    this.startLocation,
    this.endLocation,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentLocation != null) {
      _mapController.move(widget.currentLocation!, 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final route = widget.route;
    final hasRoute = route.length > 1;
    final hasSinglePoint = route.length == 1;
    final center =
        widget.currentLocation ??
            (widget.route.isNotEmpty ? widget.route.first : LatLng(0, 0));

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 15,
      ),
      children: [
       // TileLayer(
        //   urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        //  // userAgentPackageName: "com.example.trackflow",
        // ),
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.trackflow",
        ),
        if (hasRoute)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ],
          )
        else if (hasSinglePoint)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                color: Colors.grey,
                strokeWidth: 2,
                isDotted: true, // 👈 important
              ),
            ],
          ),
        // if (widget.route.isNotEmpty)
        //   PolylineLayer(
        //     polylines: [
        //       Polyline(
        //         points: widget.route,
        //         color: Colors.blue,
        //         strokeWidth: 4,
        //       ),
        //     ],
        //   ),

        MarkerLayer(
          markers: [
            // START MARKER
            if (route.isNotEmpty)
              Marker(
                point: route.first,
                width: 40,
                height: 40,
                child: const Icon(Icons.location_on, color: Colors.green),
              ),

            // END MARKER (only if more than 1 point)
            if (route.length > 1)
              Marker(
                point: route.last,
                width: 40,
                height: 40,
                child: const Icon(Icons.flag, color: Colors.red),
              ),

            // SINGLE POINT (invalid trip)
            if (route.length == 1)
              Marker(
                point: route.first,
                width: 40,
                height: 40,
                child: const Icon(Icons.radio_button_checked, color: Colors.orange),
              ),

            // CURRENT LOCATION (live tracking)
            if (widget.currentLocation != null)
              Marker(
                point: widget.currentLocation!,
                width: 40,
                height: 40,
                child: const Icon(Icons.my_location, color: Colors.blue),
              ),
          ],
        ),
      ],
    );
  }
}