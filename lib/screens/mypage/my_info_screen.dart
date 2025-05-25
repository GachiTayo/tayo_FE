import 'package:flutter/material.dart';

class MyInfoScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const MyInfoScreen({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '내 정보',
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444C39)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF444C39)),
            onPressed: () {
              // TODO: 수정 기능 구현
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoLabelValue(label: '이름', value: userData['name'] ?? ''),
            const SizedBox(height: 24),
            _InfoLabelValue(label: '이메일', value: userData['email'] ?? ''),
            if ((userData['carNumber'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 24),
              _InfoLabelValue(
                label: '차량번호',
                value: userData['carNumber'] ?? '',
              ),
            ],
            if ((userData['bankAccount'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 24),
              _InfoLabelValue(
                label: '계좌번호',
                value: userData['bankAccount'] ?? '',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoLabelValue extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLabelValue({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
