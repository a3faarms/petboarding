import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/modern_booking_card.dart';
import '../../data/booking_model.dart';
import '../../data/hive_service.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List<Booking> bookings = [];
  List<Booking> filteredBookings = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedFilter = 'all'; // all, cat, dog, active, upcoming

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  void _loadBookings() async {
    setState(() => isLoading = true);
    try {
      final results = await HiveService().getBookings();
      setState(() {
        bookings = results;
        _applyFilters();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load bookings: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _applyFilters() {
    List<Booking> filtered = List.from(bookings);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        return booking.petName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            booking.ownerName.toLowerCase().contains(searchQuery.toLowerCase()) ||
            booking.petType.toLowerCase().contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    switch (selectedFilter) {
      case 'cat':
        filtered = filtered.where((b) => b.petType.toLowerCase() == 'cat').toList();
        break;
      case 'dog':
        filtered = filtered.where((b) => b.petType.toLowerCase() == 'dog').toList();
        break;
      case 'active':
        filtered = filtered.where((b) {
          final checkIn = DateTime(b.checkIn.year, b.checkIn.month, b.checkIn.day);
          final checkOut = DateTime(b.checkOut.year, b.checkOut.month, b.checkOut.day);
          return !checkIn.isAfter(today) && checkOut.isAfter(today);
        }).toList();
        break;
      case 'upcoming':
        filtered = filtered.where((b) {
          final checkIn = DateTime(b.checkIn.year, b.checkIn.month, b.checkIn.day);
          return checkIn.isAfter(today);
        }).toList();
        break;
    }

    // Sort by check-in date (most recent first)
    filtered.sort((a, b) => b.checkIn.compareTo(a.checkIn));

    setState(() {
      filteredBookings = filtered;
    });
  }

  void _removeBooking(int index) async {
    final booking = bookings[index];
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Booking'),
        content: Text('Are you sure you want to delete the booking for ${booking.petName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await HiveService().deleteBooking(index);
        _loadBookings();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Booking for ${booking.petName} deleted'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Failed to delete booking'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBookings.isEmpty
                    ? _buildEmptyState()
                    : _buildBookingsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: (value) {
              setState(() => searchQuery = value);
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search bookings...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        setState(() => searchQuery = '');
                        _applyFilters();
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: selectedFilter == 'all',
                  onTap: () {
                    setState(() => selectedFilter = 'all');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Active',
                  isSelected: selectedFilter == 'active',
                  onTap: () {
                    setState(() => selectedFilter = 'active');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Upcoming',
                  isSelected: selectedFilter == 'upcoming',
                  onTap: () {
                    setState(() => selectedFilter = 'upcoming');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Cats',
                  isSelected: selectedFilter == 'cat',
                  onTap: () {
                    setState(() => selectedFilter = 'cat');
                    _applyFilters();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Dogs',
                  isSelected: selectedFilter == 'dog',
                  onTap: () {
                    setState(() => selectedFilter = 'dog');
                    _applyFilters();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          final originalIndex = bookings.indexOf(booking);
          
          return ModernBookingCard(
            booking: booking,
            onDelete: () => _removeBooking(originalIndex),
            onTap: () {
              // Handle booking details view
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;

    if (searchQuery.isNotEmpty) {
      title = 'No results found';
      subtitle = 'Try adjusting your search or filters';
      icon = Icons.search_off;
    } else if (selectedFilter != 'all') {
      title = 'No bookings found';
      subtitle = 'No bookings match the selected filter';
      icon = Icons.filter_list_off;
    } else {
      title = 'No bookings yet';
      subtitle = 'Add your first booking to get started';
      icon = Icons.pets_outlined;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}