// lib/screens/login/signin_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tayo_fe/providers/auth_provider.dart';

import '../../core/utils/icon_paths.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  @override
  void dispose() {
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

            Center(child: SvgPicture.asset(IconPaths.getIcon('signin'), fit: BoxFit.cover)),
            SizedBox(height: 48.h),
            // 이름
            Text('이름', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 14.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _bankAccountController,
                decoration: const InputDecoration(labelText: '이름을 입력하세요'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 28.h),
            // 이메일
            Text('이메일', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 14.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _bankAccountController,
                decoration: const InputDecoration(labelText: '이메일을 입력하세요'),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 11.h),
            Text(
              '한동대학교 메일로만 가입이 가능해요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 28.h),
            // 계좌번호
            Text('계좌번호 및 은행명', style: Theme.of(context).textTheme.titleMedium),
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
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 11.h),
            Text(
              '마이페이지에서 내용을 수정할 수 있어요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 28.h),

            // 차량번호
            Text('차량번호', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 11.h),
            SizedBox(
              width: 342.w,
              height: 52.h,
              child: TextField(
                controller: _bankAccountController,
                decoration: const InputDecoration(
                  labelText: '계좌번호를 입력하세요',
                  hintText: '계좌번호를 입력하세요 ( 필수 X )',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              '마이페이지에서 내용을 수정할 수 있어요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            SizedBox(height: 28.h),

            const SizedBox(height: 48),

            // TODO: 수정
            Row(
              children: [
                SizedBox(
                  width: 165.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      final success = await authProvider.saveAdditionalInfo(
                        bankAccount: _bankAccountController.text,
                        carNumber: _carNumberController.text,
                      );

                      if (success && context.mounted) { // 이것도 아닌것 같고..
                        context.go('../'); //이거 맞는지..
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to save information. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('뒤로가기'),
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 165.w,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final authProvider = Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      );
                      final success = await authProvider.saveAdditionalInfo(
                        bankAccount: _bankAccountController.text,
                        carNumber: _carNumberController.text,
                      );

                      if (success && context.mounted) {
                        context.go('/home');
                      } else if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Failed to save information. Please try again.',
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('시작하기'),
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
