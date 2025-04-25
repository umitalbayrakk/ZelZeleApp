import 'package:earthquake_flutter_app/views/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/earthquake_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _viewModel = HomeViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xff0118D8),
        title: Column(
          children: [
            const Text("ZelZele", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            Text(
              'Tarih: ${DateFormat('dd.MM.yyyy').format(_viewModel.selectedDate)}',
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
              onPressed: () => _viewModel.selectDate(context),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<EarthquakeModel>>(
              future: _viewModel.fetchEarthquakes(),
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
                                    ? const Color(0xff8E1616)
                                    : quake.magnitude >= 3.0
                                    ? const Color(0xffFF9B17)
                                    : const Color(0xff169976),
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
