// lib/screens/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/core/utils/icon_paths.dart';
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
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(flex: 2),
                // App logo placeholder
                SvgPicture.asset(IconPaths.getIcon('login'), fit: BoxFit.cover),
                // App name
                // Text(
                //   'Campus Carpool',
                //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                //SizedBox(height: 224),
                // Tagline
                Spacer(flex: 2),
                Text(
                  '한동대학교 메일로만 가입이 가능해요',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                ),
                //Spacer(flex: 2),
                const SizedBox(height: 17),
                // Google Sign In button
                SizedBox(
                  width: 342.w,
                  height: 58.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );

                      // ✅ Check if user is already logged in via saved userId
                      if (authProvider.userId != null) {
                        debugPrint(
                          '✅ userId already exists: ${authProvider.userId}',
                        );
                        context.go('/home');
                        return;
                      }

                      // Otherwise, perform Google sign-in
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
                    child: Text(
                      '구글 로그인',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF32392E),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
