import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/booking_model.dart';
import '../../data/hive_service.dart';

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({super.key});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerPhoneController = TextEditingController();
  final _notesController = TextEditingController();

  String? _petType;
  DateTime? _checkIn;
  DateTime? _checkOut;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Booking'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Pet Information'),
              const SizedBox(height: 16),
              _buildTextField(
                'Pet Name',
                _petNameController,
                icon: Icons.pets,
                validator: (value) => value?.isEmpty == true ? 'Pet name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildPetTypeSelector(),
              const SizedBox(height: 32),
              _buildSectionHeader('Owner Information'),
              const SizedBox(height: 16),
              _buildTextField(
                'Owner Name',
                _ownerNameController,
                icon: Icons.person,
                validator: (value) => value?.isEmpty == true ? 'Owner name is required' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Phone Number',
                _ownerPhoneController,
                icon: Icons.phone,
                inputType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true ? 'Phone number is required' : null,
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('Booking Details'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      'Check-in Date',
                      _checkIn,
                      (date) => setState(() => _checkIn = date),
                      Icons.login,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateSelector(
                      'Check-out Date',
                      _checkOut,
                      (date) => setState(() => _checkOut = date),
                      Icons.logout,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Special Notes (Optional)',
                _notesController,
                icon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Create Booking',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType inputType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.textSecondary) : null,
      ),
    );
  }

  Widget _buildPetTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pet Type',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _PetTypeCard(
                title: 'Cat',
                icon: Icons.pets,
                isSelected: _petType == 'cat',
                color: AppColors.catPrimary,
                backgroundColor: AppColors.catSecondary,
                onTap: () => setState(() => _petType = 'cat'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _PetTypeCard(
                title: 'Dog',
                icon: Icons.pets,
                isSelected: _petType == 'dog',
                color: AppColors.dogPrimary,
                backgroundColor: AppColors.dogSecondary,
                onTap: () => setState(() => _petType = 'dog'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? date,
    Function(DateTime) onSelect,
    IconData icon,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) onSelect(picked);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date != null
                  ? '${date.month}/${date.day}/${date.year}'
                  : 'Select date',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: date != null ? AppColors.textPrimary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_petType == null) {
      _showErrorSnackBar('Please select a pet type');
      return;
    }

    if (_checkIn == null || _checkOut == null) {
      _showErrorSnackBar('Please select both check-in and check-out dates');
      return;
    }

    if (!_checkOut!.isAfter(_checkIn!)) {
      _showErrorSnackBar('Check-out date must be after check-in date');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final booking = Booking(
        petName: _petNameController.text.trim(),
        petType: _petType!,
        ownerName: _ownerNameController.text.trim(),
        ownerPhone: _ownerPhoneController.text.trim(),
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      await HiveService().addBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Booking created successfully!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to create booking. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _petNameController.dispose();
    _ownerNameController.dispose();
    _ownerPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

class _PetTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _PetTypeCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? backgroundColor : AppColors.surface,
        border: Border.all(
          color: isSelected ? color : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.2) : AppColors.textTertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : AppColors.textTertiary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}