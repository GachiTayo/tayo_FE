import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/providers/auth_provider.dart';
import 'package:tayo_fe/screens/mypage/my_info_screen.dart';
import 'package:tayo_fe/screens/mypage/usage_history_screen.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final info = await authProvider.getUserInfo(); // API 요청

    if (info == null && mounted) {
      context.go('/login'); // userId가 잘못되었거나 삭제됨
      return;
    }

    setState(() {
      userData = info;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    // 프로필
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF444C39),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 24,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Color(0xFFB2FF59),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFFF9F9F7),
                                width: 3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userData?['name'] ?? '이름없음',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 메뉴
                    Column(
                      children: [
                        ListTile(
                          title: const Text(
                            '내 정보',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFBDBDBD),
                            size: 27,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (_) => MyInfoScreen(userData: userData!),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        const Divider(indent: 24, endIndent: 24),
                        ListTile(
                          title: const Text(
                            '이용 내역',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Color(0xFFBDBDBD),
                            size: 27,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UsageHistoryScreen(),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        const Divider(indent: 24, endIndent: 24),
                        ListTile(
                          title: const Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF222222),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () async {
                            final authProvider = Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            );
                            await authProvider.signOut(); // userId 삭제
                            if (context.mounted) context.go('/login');
                          },

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.go('/test-rides'),
                          child: const Text('🧪 Test Rides Page'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
