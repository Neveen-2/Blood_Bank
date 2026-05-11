import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/widgets/nearby_bank_card.dart';

class NearbyBloodBanks extends StatelessWidget {
  const NearbyBloodBanks({super.key});

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
          "Nearby Blood Bank",
          style: AppTextStyles
              .screenTitle, 
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text("9 blood bank found", style: AppTextStyles.subTitle),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const NearbyBankCard(
                    hospitalName: "مستشفي الاحرار - الزقازيق",
                    address: "شارع التحرير - امام شارع الامام",
                    phone: "055 0000000",
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
