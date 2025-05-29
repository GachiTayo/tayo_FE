import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/core/utils/icon_paths.dart';
import 'package:tayo_fe/providers/auth_provider.dart';
import 'package:tayo_fe/screens/login/login_modal.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bankAccountController.dispose();
    _carNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 90.h),
            Center(
              child: SvgPicture.asset(
                IconPaths.getIcon('signin'),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 48.h),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('이름', style: TextStyle(fontFamily: 'Six', fontSize: 12)),
                SizedBox(width: 4),
                Text(
                  '●',
                  style: TextStyle(fontSize: 7, color: Color(0xFFA6FE70)),
                ),
              ],
            ),

            SizedBox(height: 14.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름을 입력하세요'),
              ),
            ),
            SizedBox(height: 28.h),

            // 이메일
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('이메일', style: TextStyle(fontFamily: 'Six', fontSize: 12)),
                SizedBox(width: 4),
                Text(
                  '●',
                  style: TextStyle(fontSize: 7, color: Color(0xFFA6FE70)),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일을 입력하세요'),
              ),
            ),
            SizedBox(height: 11.h),
            Text(
              '한동대학교 메일로만 가입이 가능해요',
              style: TextStyle(
                fontFamily: 'Four',
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 28.h),

            // 계좌번호
            Text(
              '계좌번호 및 은행명',
              style: TextStyle(fontFamily: 'Six', fontSize: 12),
            ),
            SizedBox(height: 14.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _bankAccountController,
                decoration: const InputDecoration(
                  labelText: '계좌번호를 입력하세요',
                  hintText: '계좌번호를 입력하세요 ( 필수 X )',
                ),
              ),
            ),
            SizedBox(height: 11.h),
            Text(
              '마이페이지에서 내용을 수정할 수 있어요',
              style: TextStyle(
                fontFamily: 'Four',
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 28.h),

            // 차량번호
            Text('차량번호', style: TextStyle(fontFamily: 'Six', fontSize: 12)),
            SizedBox(height: 11.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _carNumberController,
                decoration: const InputDecoration(
                  labelText: '차량번호를 입력하세요',
                  hintText: '차량번호를 입력하세요 ( 필수 X )',
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '마이페이지에서 내용을 수정할 수 있어요',
              style: TextStyle(
                fontFamily: 'Four',
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 28.h),

            // 버튼
            Row(
              children: [
                // 뒤로가기 버튼 (OutlinedButton, 연한 회색 배경)
                SizedBox(
                  width: 165.w,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () {
                      context.go('/login'); // 이전 페이지로 이동
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey[100], // 연한 회색 배경
                      side: BorderSide.none, // 테두리 제거
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(
                        fontFamily: 'Seven',
                        fontSize: 14,
                        color: Color(0xFF3F473A),
                      ),
                    ),
                  ),
                ),
                Spacer(),

                // 시작하기 버튼 (ElevatedButton, 연두색 배경)
                SizedBox(
                  width: 165.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();

                      if (name.isEmpty || email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이름과 이메일을 모두 입력해주세요.')),
                        );
                        return;
                      }

                      if (!(email.endsWith('@handong.ac.kr') ||
                          email.endsWith('@handong.edu'))) {
                        showDialog(
                          context: context,
                          builder: (context) => const LoginModal(),
                        );
                        return;
                      }

                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      final success = await authProvider.saveAdditionalInfo(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        bankAccount:
                            _bankAccountController.text.trim().isEmpty
                                ? ''
                                : _bankAccountController.text.trim(),
                        carNumber:
                            _carNumberController.text.trim().isEmpty
                                ? ''
                                : _carNumberController.text.trim(),
                      );

                      if (success && context.mounted) {
                        context.go('/home');
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('이 이메일은 이미 가입되어 있어요!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA6FE70),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      '시작하기',
                      style: TextStyle(
                        fontFamily: 'Seven',
                        fontSize: 14,
                        color: Color(0xFF3F473A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
