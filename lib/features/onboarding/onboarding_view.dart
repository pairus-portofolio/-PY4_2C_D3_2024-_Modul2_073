import 'package:flutter/material.dart';
import 'package:logbook_app_073/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _step = 1;

  void _nextStep() {
    if (_step >= 3) {
      // Jika sudah di langkah 3, langsung navigasi ke LoginView
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      // Jika belum langkah 3, increment step
      setState(() {
        _step++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Langkah $_step dari 3"),
            const SizedBox(height: 20),
            Text("Ini adalah halaman $_step"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextStep,
              child: const Text("Lanjut"),
            ),
          ],
        ),
      ),
    );
  }
}
