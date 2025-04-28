// lib/screens/mypage/mypage_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body:
          userData == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Profile header
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userData['name'] ?? 'User',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      userData['email'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),

                    // User information
                    const Divider(),
                    if (userData['bankAccount'] != null &&
                        userData['bankAccount'].isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.account_balance),
                        title: const Text('Bank Account'),
                        subtitle: Text(userData['bankAccount']),
                      ),
                    if (userData['carNumber'] != null &&
                        userData['carNumber'].isNotEmpty)
                      ListTile(
                        leading: const Icon(Icons.directions_car),
                        title: const Text('Car Number'),
                        subtitle: Text(userData['carNumber']),
                      ),

                    const Spacer(),

                    // Sign out button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await authProvider.signOut();
                          if (context.mounted) {
                            context.go('/login');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Sign Out'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
