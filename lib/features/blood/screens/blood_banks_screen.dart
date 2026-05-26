import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:blood_bank/core/constants/app_colors.dart';
import 'package:blood_bank/core/constants/app_text_styles.dart';
import 'package:blood_bank/core/widgets/nearby_bank_card.dart';

class BloodBanksScreen extends StatefulWidget {
  const BloodBanksScreen({super.key});

  @override
  State<BloodBanksScreen> createState() => _BloodBanksScreenState();
}

class _BloodBanksScreenState extends State<BloodBanksScreen> {
  Position? _currentPosition;
  List<Map<String, dynamic>> _bloodBanks = [];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadBloodBanks();
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

    _sortByDistance();
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


  void _loadBloodBanks() {
    _bloodBanks = [
      {
        'name': 'مستشفى الزقازيق العام',
        'address': 'شارع الإسماعيلية - الزقازيق',
        'phone': '055-2355888',
        'lat': 30.5853,
        'lng': 31.9169,
        'working_hours': '24 ساعة',
      },
      {
        'name': 'مركز نقل الدم - الشرقية',
        'address': 'شارع النيل - الزقازيق',
        'phone': '055-2320000',
        'lat': 30.5780,
        'lng': 31.9200,
        'working_hours': '8 صباحاً - 6 مساءً',
      },
      {
        'name': 'مستشفى بنها التعليمي',
        'address': 'شارع البحر - بنها',
        'phone': '013-2222500',
        'lat': 30.4622,
        'lng': 31.1900,
        'working_hours': '24 ساعة',
      },
      {
        'name': 'مركز نقل الدم المركزي',
        'address': 'شارع طه حسين - بنها',
        'phone': '013-2288999',
        'lat': 30.4580,
        'lng': 31.1850,
        'working_hours': '7 صباحاً - 8 مساءً',
      },
      {
        'name': 'مستشفى هليوبوليس',
        'address': 'شارع النيل الجديد - هليوبوليس',
        'phone': '02-24181000',
        'lat': 30.0852,
        'lng': 31.3654,
        'working_hours': '24 ساعة',
      },
      {
        'name': 'مركز نقل الدم بالعاشر من رمضان',
        'address': 'المدينة الصناعية - العاشر من رمضان',
        'phone': '016-2329000',
        'lat': 30.3032,
        'lng': 31.7916,
        'working_hours': '8 صباحاً - 6 مساءً',
      },
    ];

    _sortByDistance();
  }

  void _sortByDistance() {
    _bloodBanks.sort((a, b) {
      double distA = _distanceKm(a['lat'], a['lng']);
      double distB = _distanceKm(b['lat'], b['lng']);
      return distA.compareTo(distB);
    });
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
          'Blood Banks Near You',
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
            Text(
              '${_bloodBanks.length} blood banks found',
              style: AppTextStyles.subTitle,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _bloodBanks.isEmpty
                  ? const Center(child: Text('No blood banks found nearby'))
                  : ListView.builder(
                      itemCount: _bloodBanks.length,
                      itemBuilder: (context, index) {
                        final bank = _bloodBanks[index];
                        return NearbyBankCard(
                          hospitalName: bank['name'],
                          address: bank['address'],
                          phone: bank['phone'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
