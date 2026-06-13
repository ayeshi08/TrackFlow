
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trackflow/viewmodels/auth_viewmodel.dart';
import 'package:trackflow/viewmodels/home_viewmodel.dart';
import 'package:trackflow/viewmodels/trip_viewmodel.dart';
import 'package:trackflow/views/home/home_screen.dart';
import 'package:trackflow/views/auth/login_screen.dart';
import 'package:trackflow/views/auth/reset_password_screen.dart';
import 'package:trackflow/views/profile/profile_screen.dart';
import 'package:trackflow/service/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BackgroundService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TripViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashRouter(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/reset-password': (_) => const ResetPasswordScreen(),
      },
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  State<SplashRouter> createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final authVM = context.read<AuthViewModel>();
    final isLoggedIn = await authVM.checkLoginStatus();
    if (!mounted) return;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.route, color: Color(0xFF3B82F6), size: 56),
            SizedBox(height: 24),
            Text('TrackFlow',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 32),
            CircularProgressIndicator(
                color: Color(0xFF3B82F6), strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}