import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../model/trip_model.dart';
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
  String _filterType = 'all'; // all, today, week, month
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

  List _getFilteredTrips(List trips) {
    final now = DateTime.now();
    List filtered = trips;

    if (_filterType == 'today') {
      filtered = filtered
          .where(
            (t) =>
                t.startTime.year == now.year &&
                t.startTime.month == now.month &&
                t.startTime.day == now.day,
          )
          .toList();
    } else if (_filterType == 'week') {
      filtered = filtered
          .whereType<
            Trip
          >() // 🌟 Yeh line batati hai ki sirf Trip objects pick karo
          .where(
            (t) => t.startTime.isAfter(now.subtract(const Duration(days: 7))),
          )
          .toList();
    } else if (_filterType == 'month') {
      filtered = filtered
          .whereType<
            Trip
          >() // 🌟 Yahan bhi strict type inference enforce kar di
          .where(
            (t) =>
                t.startTime.year == now.year && t.startTime.month == now.month,
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        final dist = t.distance.toStringAsFixed(2);
        final date =
            '${t.startTime.day}/${t.startTime.month}/${t.startTime.year}';
        final monthNames = [
          'jan',
          'feb',
          'mar',
          'apr',
          'may',
          'jun',
          'jul',
          'aug',
          'sep',
          'oct',
          'nov',
          'dec',
        ];
        final monthName = monthNames[(t.startTime.month as int) - 1];
        //final monthName = monthNames[t.startTime.month - 1];
        return (dist as String).contains(q as String) ||
            date.contains(q) ||
            monthName.contains(q);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final homeVM = context.watch<HomeViewModel>();
    final w = MediaQuery.of(context).size.width;
    final trips = _getFilteredTrips(homeVM.trips);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Trip History',
          style: GoogleFonts.inter(
            color: theme.textTheme.titleLarge?.color ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: theme.iconTheme.color),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: theme.iconTheme.color),
            onPressed: _loadTrips,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.inter(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 14,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search by distance, date or month name...',
                  hintStyle: GoogleFonts.inter(
                    color: theme.hintColor.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.hintColor.withOpacity(0.6),
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: theme.hintColor.withOpacity(0.6),
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: theme.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: theme.dividerColor.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF3B82F6)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Filter chips - Fixed layout height container to protect landscape view
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                children: [
                  _filterChip('All', 'all', w),
                  const SizedBox(width: 8),
                  _filterChip('Today', 'today', w),
                  const SizedBox(width: 8),
                  _filterChip('This Week', 'week', w),
                  const SizedBox(width: 8),
                  _filterChip('This Month', 'month', w),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Trip count
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${trips.length} trip${trips.length == 1 ? '' : 's'} found',
                    style: GoogleFonts.inter(
                      color: theme.hintColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 8),

            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading trips...',
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ],
                      ),
                    )
                  : trips.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.route,
                              color: theme.hintColor.withOpacity(0.3),
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty || _filterType != 'all'
                                  ? 'No trips match your search'
                                  : 'No trips yet',
                              style: GoogleFonts.inter(
                                color: theme.hintColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            if (_searchQuery.isEmpty && _filterType == 'all')
                              Text(
                                'Start your first trip from the home screen',
                                style: GoogleFonts.inter(
                                  color: theme.hintColor.withOpacity(0.6),
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF3B82F6),
                      onRefresh: _loadTrips,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          final trip = trips[index];
                          return Dismissible(
                            key: Key((trip as Trip).id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  backgroundColor: theme.cardColor,
                                  title: Text(
                                    'Delete Trip?',
                                    style: GoogleFonts.inter(
                                      color: theme.textTheme.titleLarge?.color,
                                    ),
                                  ),
                                  content: Text(
                                    'This trip will be permanently deleted.',
                                    style: GoogleFonts.inter(
                                      color: theme.textTheme.bodyMedium?.color,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.inter(
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.inter(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) {
                              homeVM.deleteTripById((trip as Trip).id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Trip deleted',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: theme.cardColor,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.shade700,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            child: Card(
                              color: theme.cardColor,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: theme.dividerColor.withOpacity(0.1),
                                ), // <-- FIXED
                              ),
                              child: TripCard(
                                trip: trip,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        TripDetailScreen(trip: trip as Trip),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value, double w) {
    final theme = Theme.of(context);
    final isSelected = _filterType == value;
    return GestureDetector(
      onTap: () => setState(() => _filterType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B82F6) : theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF3B82F6)
                : theme.dividerColor.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: isSelected ? Colors.white : theme.hintColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
