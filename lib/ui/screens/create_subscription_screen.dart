import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../data/models/subscription.dart';
import '../../data/providers/subscription_provider.dart';
import '../../data/providers/package_provider.dart';

class CreateSubscriptionScreen extends ConsumerStatefulWidget {
  const CreateSubscriptionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateSubscriptionScreen> createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState
    extends ConsumerState<CreateSubscriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedPackage;
  String? errorMessage;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (_selectedPackage != null && _startDate != null && _endDate != null) {
        final subscription = Subscription(
          packageId: _selectedPackage!,
          startDate: _startDate!,
          endDate: _endDate!,
        );

        try {
          // Menggunakan provider untuk membuat subscription
          final response =
              await ref.read(createSubscriptionProvider(subscription).future);

          if (response['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Subscription created successfully')),
            );
            Navigator.pop(context);
          } else {
            setState(() {
              errorMessage =
                  response['message'] ?? 'Failed to create subscription';
            });
          }
        } catch (e) {
          setState(() {
            errorMessage = e.toString();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final packagesAsyncValue = ref.watch(packageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Subscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              packagesAsyncValue.when(
                data: (packages) {
                  return DropdownButtonFormField<int>(
                    value: _selectedPackage,
                    decoration:
                        const InputDecoration(labelText: 'Select Package'),
                    items: packages.map<DropdownMenuItem<int>>((package) {
                      return DropdownMenuItem<int>(
                        value: package['id'],
                        child: Text(package['name'] ?? 'Unknown Package'),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedPackage = value),
                    validator: (value) =>
                        value == null ? 'Please select a package' : null,
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error loading packages: $error'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                    'Start Date: ${_startDate != null ? DateFormat.yMd().format(_startDate!) : 'Not selected'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, true),
                ),
              ),
              ListTile(
                title: Text(
                    'End Date: ${_endDate != null ? DateFormat.yMd().format(_endDate!) : 'Not selected'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, false),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
