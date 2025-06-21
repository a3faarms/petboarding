import 'package:flutter/material.dart';
import 'package:pet_boarding_manager/data/booking_model.dart';
import 'package:pet_boarding_manager/data/hive_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 New Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Pet Name', _petNameController),
              _buildPetTypeDropdown(),
              _buildTextField('Owner Name', _ownerNameController),
              _buildTextField('Owner Phone', _ownerPhoneController, inputType: TextInputType.phone),
              _buildDatePicker('Check-in Date', _checkIn, (date) => setState(() => _checkIn = date)),
              _buildDatePicker('Check-out Date', _checkOut, (date) => setState(() => _checkOut = date)),
              _buildTextField('Special Notes', _notesController, lines: 3),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: lines,
        decoration: InputDecoration(labelText: label),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildPetTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Pet Type'),
        value: _petType,
        items: const [
          DropdownMenuItem(value: 'cat', child: Text('Cat')),
          DropdownMenuItem(value: 'dog', child: Text('Dog')),
        ],
        onChanged: (val) => setState(() => _petType = val),
        validator: (value) => value == null ? 'Please select pet type' : null,
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onPick) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: date ?? DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (picked != null) onPick(picked);
        },
        child: InputDecorator(
          decoration: InputDecoration(labelText: label),
          child: Text(
            date != null
                ? '${date.month}/${date.day}/${date.year}'
                : 'Select date',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_checkIn == null || _checkOut == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select both dates')),
        );
        return;
      }

      if (!_checkOut!.isAfter(_checkIn!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-out must be after check-in')),
        );
        return;
      }

      // Booking data can now be passed to DB or logic layer
      print('Booking confirmed for ${_petNameController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking added!')),
      );

      _formKey.currentState!.reset();
      setState(() {
        _petType = null;
        _checkIn = null;
        _checkOut = null;
      });
    }
    if (_petType == null || _checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.')),
      );
      return;
    }

    final booking = Booking(
      petName: _petNameController.text,
      petType: _petType!,
      ownerName: _ownerNameController.text,
      ownerPhone: _ownerPhoneController.text,
      checkIn: _checkIn!,
      checkOut: _checkOut!,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
    );

    await HiveService().addBooking(booking);
  }
}
