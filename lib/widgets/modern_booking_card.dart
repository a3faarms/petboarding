import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/booking_model.dart';

class ModernBookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ModernBookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPetCat = booking.petType.toLowerCase() == 'cat';
    final petColor = isPetCat ? AppColors.catPrimary : AppColors.dogPrimary;
    final petBackgroundColor = isPetCat ? AppColors.catSecondary : AppColors.dogSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: petBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isPetCat ? Icons.pets : Icons.pets,
                        color: petColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking.petName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: petBackgroundColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              booking.petType.toUpperCase(),
                              style: TextStyle(
                                color: petColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onDelete != null)
                      IconButton(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.error.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'Owner',
                  value: booking.ownerName,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: booking.ownerPhone,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Stay Period',
                  value: '${_formatDate(booking.checkIn)} → ${_formatDate(booking.checkOut)}',
                ),
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.note_outlined,
                    label: 'Notes',
                    value: booking.notes!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}