import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import 'package:blood_bank/core/widgets/home_bottom_nav.dart';
import 'package:blood_bank/core/widgets/home_header.dart';
import 'package:blood_bank/core/widgets/home_body.dart';

import '../../blood/screens/select_blood_group_screen.dart';
import '../../emergency/screens/emergency_screen.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String? _urgentBloodType;
  String? _urgentLocation;

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

 
  void _setIndex(int index) {
    setState(() => _selectedIndex = index);
  }

  void _setUrgentAlert(String bloodType, String location) {
    setState(() {
      _urgentBloodType = bloodType;
      _urgentLocation = location;
      _selectedIndex = 0;
    });
  }


  @override
  Widget build(BuildContext context) {
    final screens = [
   
      Column(
        children: [
          const HomeHeader(userName: 'Donor'),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
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

                  final distance = _distanceKm(lat, lng);

                  donors.add({
                    'name': data['fullName'] ?? '',
                    'blood': data['bloodType'] ?? '',
                    'distance': distance.toStringAsFixed(1),
                  });
                }

                
                donors.sort((a, b) {
                  return double.parse(a['distance'])
                      .compareTo(double.parse(b['distance']));
                });

            
                if (_urgentBloodType != null) {
                  donors = donors
                      .where((d) => d['blood'] == _urgentBloodType)
                      .toList();
                }

                return HomeBody(
                  urgentBloodType: _urgentBloodType,
                  urgentLocation: _urgentLocation,
                  nearbyDonors: donors,
                  onEmergencyTap: () => _setIndex(1),
                );
              },
            ),
          ),
        ],
      ),

      
      EmergencyScreen(
        onBackToHome: () => _setIndex(0),
        onAlertSent: _setUrgentAlert,
      ),

     
      const DonorScreen(),

      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: screens[_selectedIndex],
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onTap: _setIndex,
      ),
    );
  }
}