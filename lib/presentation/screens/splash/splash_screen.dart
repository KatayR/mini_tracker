import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mini_tracker/presentation/core/constants/app_icons.dart';
import 'package:mini_tracker/presentation/core/theme/app_palette.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // Navigate to the initial tab
      context.go(AppRoutes.tasks);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(AppIcons.splashLogo, size: 80, color: AppPalette.brandPurple),
            const SizedBox(height: 20),
            Text(
              'Mini Tracker',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF6750A4)),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
