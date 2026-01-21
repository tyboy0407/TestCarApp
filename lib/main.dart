import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/evaluation_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/vehicle_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const CarEvaluationApp());
}

class CarEvaluationApp extends StatelessWidget {
  const CarEvaluationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EvaluationProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: MaterialApp(
        title: '購車評估助手',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            filled: true,
          ),
        ),
        // 使用 Consumer 來監聽 AuthProvider 的變化
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // 如果已登入顯示首頁，否則顯示登入頁
            return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}
