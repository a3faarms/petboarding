import 'package:flutter/material.dart';
import '../../widgets/modern_header.dart';
import '../../widgets/modern_capacity_card.dart';
import '../../widgets/modern_booking_card.dart';
import '../../core/theme/app_colors.dart';
import '../booking/booking_form.dart';
import '../booking/booking_list.dart';
import '../../data/booking_model.dart';
import '../../data/hive_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String catCurrent = '0';
  String catTotal = '4';
  String dogCurrent = '0';
  String dogTotal = '2';
  List<Booking> todayBookings = [];
  List<Booking> recentBookings = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await _loadCapacity();
    await _loadBookings();
  }

  Future<void> _loadCapacity() async {
    final counts = await HiveService().getRoomOccupancyCount(DateTime.now());
    setState(() {
      catCurrent = counts['cat'].toString();
      dogCurrent = counts['dog'].toString();
    });
  }

  Future<void> _loadBookings() async {
    final allBookings = await HiveService().getAllBookings();
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    final todayList = <Booking>[];
    for (var booking in allBookings) {
      final checkInNormalized = DateTime(
        booking.checkIn.year,
        booking.checkIn.month,
        booking.checkIn.day,
      );
      final checkOutNormalized = DateTime(
        booking.checkOut.year,
        booking.checkOut.month,
        booking.checkOut.day,
      );

      if (!checkInNormalized.isAfter(todayNormalized) &&
          checkOutNormalized.isAfter(todayNormalized)) {
        todayList.add(booking);
      }
    }

    setState(() {
      todayBookings = todayList;
      recentBookings = allBookings.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ModernHeader()),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildCapacitySection(),
                  const SizedBox(height: 32),
                  _buildQuickActions(),
                  const SizedBox(height: 32),
                  _buildTodayBookings(),
                  const SizedBox(height: 32),
                  _buildRecentBookings(),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingFormPage()),
        ).then((_) => _loadData()),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Booking'),
      ),
    );
  }

  Widget _buildCapacitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Capacity Overview',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              children: [
                Expanded(
                  child: ModernCapacityCard(
                    title: 'Cat Rooms',
                    current: catCurrent,
                    total: catTotal,
                    icon: Icons.pets,
                    gradient: AppColors.catGradient,
                    accentColor: AppColors.catPrimary,
                  ),
                ),
                SizedBox(
                  width: isWide ? 20 : 0,
                  height: isWide ? 0 : 20,
                ),
                Expanded(
                  child: ModernCapacityCard(
                    title: 'Dog Spaces',
                    current: dogCurrent,
                    total: dogTotal,
                    icon: Icons.pets,
                    gradient: AppColors.dogGradient,
                    accentColor: AppColors.dogPrimary,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                title: 'New Booking',
                subtitle: 'Add a new pet booking',
                icon: Icons.add_circle_outline,
                color: AppColors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingFormPage()),
                ).then((_) => _loadData()),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActionCard(
                title: 'All Bookings',
                subtitle: 'View all bookings',
                icon: Icons.list_alt,
                color: AppColors.secondary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookingListPage()),
                ).then((_) => _loadData()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodayBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Bookings',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${todayBookings.length}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (todayBookings.isEmpty)
          _EmptyState(
            icon: Icons.calendar_today_outlined,
            title: 'No bookings today',
            subtitle: 'All pets are checked out for today',
          )
        else
          ...todayBookings.map((booking) => ModernBookingCard(
                booking: booking,
                onTap: () {
                  // Handle booking tap
                },
              )),
      ],
    );
  }

  Widget _buildRecentBookings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Bookings',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingListPage()),
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (recentBookings.isEmpty)
          _EmptyState(
            icon: Icons.pets_outlined,
            title: 'No bookings yet',
            subtitle: 'Add your first booking to get started',
          )
        else
          ...recentBookings.map((booking) => ModernBookingCard(
                booking: booking,
                onTap: () {
                  // Handle booking tap
                },
              )),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}