import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blood_bank/core/routes/app_router.dart';
import 'package:blood_bank/core/services/firebase_service.dart';
import 'package:blood_bank/core/constants/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DonoraApp());
}

class DonoraApp extends StatelessWidget {
  const DonoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DONORA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8474C),
          primary: const Color(0xFFE8474C),
        ),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRouter.routes,
    );
  }
}
