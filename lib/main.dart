import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/view/splash/splash.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const SplashScreen(),
    );
  }
}