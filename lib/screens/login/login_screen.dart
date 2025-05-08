// lib/screens/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/providers/auth_provider.dart';

//색깔 따오는거랑 #2345 값으로 넣는 법

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App logo placeholder
                Container(
                  width: 120,
                  height: 120,
                  child: Icon(
                    Icons.directions_car,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                // App name
                // Text(
                //   'Campus Carpool',
                //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                const SizedBox(height: 224),
                // Tagline
                Text(
                  '한동대학교 메일로만 가입이 가능해요',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 17),
                // Google Sign In button
                ElevatedButton.icon(
                  onPressed: () async {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    final success = await authProvider.signInWithGoogle();

                    if (success && context.mounted) {
                      context.go('/signin');
                    } else if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign in failed. Please try again.'),
                        ),
                      );
                    }
                  },
                  // icon: const Icon(Icons.login),
                  label: const Text('구글 로그인'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 135,
                    ),
                    minimumSize: const Size(double.infinity, 58),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
