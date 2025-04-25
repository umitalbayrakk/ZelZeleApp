import 'dart:async';
import 'package:flutter/material.dart';
import '../models/earthquake_model.dart';
import '../services/earthquake_services.dart';

class HomeViewModel extends ChangeNotifier {
  final EarthquakeService _service = EarthquakeService();
  late Timer _timer;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  HomeViewModel() {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      notifyListeners();
    });
  }

  Future<List<EarthquakeModel>> fetchEarthquakes() async {
    return await _service.fetchEarthquakesForDay(date: _selectedDate);
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}