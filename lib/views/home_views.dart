import 'dart:async';
import 'package:earthquake_flutter_app/services/earthquake_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/earthquake_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final EarthquakeService _service = EarthquakeService();
  late Timer _timer;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xff0118D8),
        title: Column(
          children: [
            Text("ZelZele", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text(
              'Tarih: ${DateFormat('dd.MM.yyyy').format(_selectedDate)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<EarthquakeModel>>(
              future: _service.fetchEarthquakesForDay(date: _selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Seçilen tarihte Türkiye için deprem verisi bulunamadı.'));
                }
                final quakes = snapshot.data!;
                return ListView.builder(
                  itemCount: quakes.length,
                  itemBuilder: (context, index) {
                    final quake = quakes[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Container(
                        height: 80,
                        width: 200,
                        decoration: const BoxDecoration(),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                quake.magnitude >= 4.0
                                    ? Color(0xff8E1616)
                                    : quake.magnitude >= 3.0
                                    ? Color(0xffFF9B17)
                                    : Color(0xff169976),
                            child: Text(
                              quake.magnitude.toStringAsFixed(1),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(quake.place),
                          subtitle: Text(DateFormat('dd.MM.yyyy – HH:mm').format(quake.time)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
