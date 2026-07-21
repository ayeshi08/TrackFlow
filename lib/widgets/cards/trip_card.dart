// import 'package:flutter/material.dart';
//
// import '../../model/trip_model.dart';
//
// class TripCard extends StatelessWidget {
//   final Trip trip;
//   final VoidCallback onTap;
//
//   const TripCard({required this.trip, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(8),
//       child: ListTile(
//         title: Text(
//           'Trip on ${trip.startTime.toLocal().toString().split(' ')[0]}',
//         ),
//         subtitle: Text('Distance: ${trip.distance.toStringAsFixed(2)} km'),
//         trailing: const Icon(Icons.arrow_forward_ios),
//         onTap: onTap,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../model/trip_model.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback onTap;

  const TripCard({super.key, required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          'Trip on ${trip.startTime.toLocal().toString().split(' ')[0]}',
        ),
        subtitle: Text('Distance: ${trip.distance.toStringAsFixed(2)} km'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}