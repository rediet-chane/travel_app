import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(TravelApp());
}

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Travel App',
      theme: ThemeData(useMaterial3: true),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
