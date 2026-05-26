import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/widgets/nearby_bank_card.dart';

class NearbyBloodBanksScreen extends StatefulWidget {
  const NearbyBloodBanksScreen({super.key});

  @override
  State<NearbyBloodBanksScreen> createState() => _NearbyBloodBanksScreenState();
}

class _NearbyBloodBanksScreenState extends State<NearbyBloodBanksScreen> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = pos;
    });
  }

  
  double _distanceKm(double lat, double lng) {
    if (_currentPosition == null) return 9999;

    return Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          lat,
          lng,
        ) /
        1000;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nearby Blood Bank',
          style: AppTextStyles.screenTitle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                List<Map<String, dynamic>> donors = [];

                for (var doc in docs) {
                  final data = doc.data() as Map<String, dynamic>;

                  final lat = (data['latitude'] ?? 0).toDouble();
                  final lng = (data['longitude'] ?? 0).toDouble();

                  donors.add({
                    'name': data['fullName'] ?? '',
                    'phone': data['phone'] ?? '',
                    'address': data['address'] ?? '',
                    'distance': _distanceKm(lat, lng),
                  });
                }

               
                donors.sort((a, b) {
                  return (a['distance'] as double).compareTo(
                    b['distance'] as double,
                  );
                });

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${donors.length} donors found',
                        style: AppTextStyles.subTitle,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: donors.isEmpty
                            ? const Center(
                                child: Text('No nearby donors found'),
                              )
                            : ListView.builder(
                                itemCount: donors.length,
                                itemBuilder: (context, index) {
                                  final donor = donors[index];
                                  return NearbyBankCard(
                                    hospitalName: donor['name'],
                                    address: donor['address'],
                                    phone: donor['phone'],
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
