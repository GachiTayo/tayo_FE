import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/providers/auth_provider.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userData = authProvider.userData;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // 프로필 원형 + 연두색 점
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Color(0xFF444C39), // 짙은 초록색
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
                      color: Color(0xFFB2FF59), // 연두색
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color(0xFFF9F9F7), // 배경색과 맞춤
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              userData['name'] ?? '이름없음',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 40),

            // 메뉴 리스트
            Column(
              children: [
                ListTile(
                  title: const Text(
                    '내 정보',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
                  onTap: () {
                    // 내 정보 페이지로 이동
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                const Divider(indent: 24, endIndent: 24, thickness: 1, height: 0),
                ListTile(
                  title: const Text(
                    '이용 내역',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Color(0xFFBDBDBD)),
                  onTap: () {
                    // 이용 내역 페이지로 이동
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
                const Divider(indent: 24, endIndent: 24, thickness: 1, height: 0),
                ListTile(
                  title: const Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF222222),
                    ),
                  ),
                  onTap: () async {
                    await authProvider.signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                  dense: true,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
