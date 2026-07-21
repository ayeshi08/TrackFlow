// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../viewmodels/connectivity_viewmodel.dart';
//
// class ConnectivityBanner extends StatelessWidget {
//   const ConnectivityBanner({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<ConnectivityViewModel>();
//     @override
//     Widget build(BuildContext context) {
//       final vm = context.watch<ConnectivityViewModel>();
//
//       if (vm.justReconnected) {
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           color: Colors.green,
//           child: const Row(
//             children: [
//               Icon(Icons.cloud_done, color: Colors.white, size: 18),
//               SizedBox(width: 8),
//               Text('Back Online', style: TextStyle(color: Colors.white)),
//             ],
//           ),
//         );
//       }
//
//       if (!vm.isOnline) {
//         return Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           color: Colors.red,
//           child: const Row(
//             children: [
//               Icon(Icons.wifi_off, color: Colors.white, size: 18),
//               SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   'Offline • Trips will sync when internet returns',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//
//       return const SizedBox.shrink();
//     }
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//       color: Colors.red,
//
//       child: const Row(
//         children: [
//           Icon(Icons.wifi_off, color: Colors.white, size: 18),
//
//           SizedBox(width: 8),
//
//           Expanded(
//             child: Text(
//               'Offline • Trips will sync when internet returns',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/connectivity_viewmodel.dart';

class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConnectivityViewModel>();

    if (vm.justReconnected) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.green,
        child: const Row(
          children: [
            Icon(Icons.cloud_done, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Back Online', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (!vm.isOnline) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        color: Colors.red,
        child: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Offline • Trips will sync when internet returns',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}