// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../viewmodels/home_viewmodel.dart';
// import '../../widgets/cards/trip_card.dart';
// import 'trip_detail_screen.dart';
//
// class TripHistoryScreen extends StatefulWidget {
//   const TripHistoryScreen({super.key});
//
//   @override
//   State<TripHistoryScreen> createState() => _TripHistoryScreenState();
// }
//
// class _TripHistoryScreenState extends State<TripHistoryScreen> {
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTrips();
//   }
//
//   Future<void> _loadTrips() async {
//     setState(() => _isLoading = true);
//     await context.read<HomeViewModel>().loadTrips();
//     if (mounted) setState(() => _isLoading = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final homeVM = context.watch<HomeViewModel>();
//     final trips = homeVM.trips;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A0A0A),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0A0A0A),
//         elevation: 0,
//         title: Text('Trip History',
//             style: GoogleFonts.inter(
//                 color: Colors.white, fontWeight: FontWeight.bold)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           // Refresh button
//           IconButton(
//             icon: const Icon(Icons.refresh, color: Colors.white),
//             onPressed: _loadTrips,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircularProgressIndicator(color: Color(0xFF3B82F6)),
//             SizedBox(height: 16),
//             Text('Loading trips...',
//                 style: TextStyle(color: Colors.white54)),
//           ],
//         ),
//       )
//           : trips.isEmpty
//           ? Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.route,
//                 color: Colors.white24, size: 64),
//             const SizedBox(height: 16),
//             Text('No trips yet',
//                 style: GoogleFonts.inter(
//                     color: Colors.white54, fontSize: 18)),
//             const SizedBox(height: 8),
//             Text('Start your first trip from the home screen',
//                 style: GoogleFonts.inter(
//                     color: Colors.white38, fontSize: 13)),
//           ],
//         ),
//       )
//           : RefreshIndicator(
//         color: const Color(0xFF3B82F6),
//         onRefresh: _loadTrips,
//         child: ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: trips.length,
//           itemBuilder: (context, index) {
//             final trip = trips[index];
//             return Dismissible(
//               key: Key(trip.id),
//               direction: DismissDirection.endToStart,
//               confirmDismiss: (direction) async {
//                 return await showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     backgroundColor: const Color(0xFF1A1A1A),
//                     title: Text('Delete Trip?',
//                         style: GoogleFonts.inter(
//                             color: Colors.white)),
//                     content: Text(
//                         'This trip will be permanently deleted.',
//                         style: GoogleFonts.inter(
//                             color: Colors.white70)),
//                     actions: [
//                       TextButton(
//                         onPressed: () =>
//                             Navigator.pop(context, false),
//                         child: Text('Cancel',
//                             style: GoogleFonts.inter(
//                                 color: Colors.white54)),
//                       ),
//                       TextButton(
//                         onPressed: () =>
//                             Navigator.pop(context, true),
//                         child: Text('Delete',
//                             style: GoogleFonts.inter(
//                                 color: Colors.red)),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               onDismissed: (direction) {
//                 homeVM.deleteTripById(trip.id);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Trip deleted',
//                         style: GoogleFonts.inter(
//                             color: Colors.white)),
//                     backgroundColor:
//                     const Color(0xFF1A1A1A),
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                         borderRadius:
//                         BorderRadius.circular(10)),
//                   ),
//                 );
//               },
//               background: Container(
//                 margin: const EdgeInsets.symmetric(
//                     vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.red.shade700,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.only(right: 20),
//                 child: const Icon(Icons.delete,
//                     color: Colors.white),
//               ),
//               child: Card(
//                 color: const Color(0xFF1A1A1A),
//                 margin: const EdgeInsets.symmetric(
//                     vertical: 6),
//                 shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.circular(12)),
//                 child: TripCard(
//                   trip: trip,
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) =>
//                             TripDetailScreen(trip: trip),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../widgets/cards/trip_card.dart';
import 'trip_detail_screen.dart';

class TripHistoryScreen extends StatefulWidget {
  const TripHistoryScreen({super.key});
  @override
  State<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends State<TripHistoryScreen> {
  bool _isLoading = true;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTrips() async {
    setState(() => _isLoading = true);
    await context.read<HomeViewModel>().loadTrips();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Filter trips by search
    final allTrips = homeVM.trips;
    final trips = _searchQuery.isEmpty
        ? allTrips
        : allTrips.where((t) {
      final date = t.startTime.toString().toLowerCase();
      final dist = t.distance.toStringAsFixed(2);
      return date.contains(_searchQuery.toLowerCase()) || dist.contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A), elevation: 0,
        title: Text('Trip History', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: w * 0.048)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _loadTrips),
        ],
      ),
      body: Column(children: [
        // Search bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.01),
          child: TextField(
            controller: _searchController,
            style: GoogleFonts.inter(color: Colors.white),
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search by date or distance...',
              hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 13),
              prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear, color: Colors.white38, size: 18), onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); })
                  : null,
              filled: true, fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2A2A2A))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF3B82F6))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),

        // Trip count
        if (!_isLoading && trips.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.04),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('${trips.length} trip${trips.length == 1 ? '' : 's'}', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
            ),
          ),

        SizedBox(height: h * 0.008),

        Expanded(
          child: _isLoading
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            CircularProgressIndicator(color: Color(0xFF3B82F6)),
            SizedBox(height: 16),
            Text('Loading trips...', style: TextStyle(color: Colors.white54)),
          ]))
              : trips.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.route, color: Colors.white24, size: w * 0.16),
            SizedBox(height: h * 0.016),
            Text(_searchQuery.isNotEmpty ? 'No trips match your search' : 'No trips yet', style: GoogleFonts.inter(color: Colors.white54, fontSize: w * 0.045)),
            SizedBox(height: h * 0.008),
            if (_searchQuery.isEmpty)
              Text('Start your first trip from the home screen', style: GoogleFonts.inter(color: Colors.white38, fontSize: w * 0.033)),
          ]))
              : RefreshIndicator(
            color: const Color(0xFF3B82F6),
            onRefresh: _loadTrips,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: w * 0.04),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return Dismissible(
                  key: Key(trip.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF1A1A1A),
                        title: Text('Delete Trip?', style: GoogleFonts.inter(color: Colors.white)),
                        content: Text('This trip will be permanently deleted.', style: GoogleFonts.inter(color: Colors.white70)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel', style: GoogleFonts.inter(color: Colors.white54))),
                          TextButton(onPressed: () => Navigator.pop(context, true), child: Text('Delete', style: GoogleFonts.inter(color: Colors.red))),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    homeVM.deleteTripById(trip.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Trip deleted', style: GoogleFonts.inter(color: Colors.white)),
                      backgroundColor: const Color(0xFF1A1A1A),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ));
                  },
                  background: Container(
                    margin: EdgeInsets.symmetric(vertical: h * 0.006),
                    decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: const Color(0xFF1A1A1A),
                    margin: EdgeInsets.symmetric(vertical: h * 0.006),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: TripCard(
                      trip: trip,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip))),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}