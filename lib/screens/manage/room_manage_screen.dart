import 'package:flutter/material.dart';

// 탑승자 정보 모델
class Rider {
  final String name;
  final String status; // '입금 대기중' or '입금 완료'
  const Rider({required this.name, required this.status});
}

// 방 관리 공통 위젯
class RoomManageScreen extends StatelessWidget {
  final String title; // 상단 타이틀
  final String? period; // 기간 (고정카풀만)
  final String? days; // 요일 (고정카풀만)
  final String? dateTime; // 날짜 및 시간 (카풀/택시)
  final String? time; // 시간 (고정카풀)
  final String bank;
  final String? price;
  final String? carNumber;
  final List<String> stops;
  final List<Rider> riders;
  final String? riderStatusTitle; // 고정카풀만
  final String notice;

  const RoomManageScreen({
    super.key,
    required this.title,
    this.period,
    this.days,
    this.dateTime,
    this.time,
    required this.bank,
    this.price,
    this.carNumber,
    required this.stops,
    required this.riders,
    this.riderStatusTitle,
    required this.notice,
  });

  @override
  Widget build(BuildContext context) {
    final isFixed = title.contains('고정카풀');
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444C39)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title, style: const TextStyle(color: Color(0xFF222222))),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (period != null) ...[
              const Text('기간', style: _labelStyle),
              const SizedBox(height: 4),
              Text(period!, style: _valueStyle),
              const SizedBox(height: 16),
            ],
            if (days != null) ...[
              const Text('요일', style: _labelStyle),
              const SizedBox(height: 4),
              Text(days!, style: _valueStyle),
              const SizedBox(height: 16),
            ],
            if (dateTime != null) ...[
              const Text('날짜 및 시간', style: _labelStyle),
              const SizedBox(height: 4),
              Text(dateTime!, style: _valueStyle),
              const SizedBox(height: 16),
            ],
            if (time != null) ...[
              const Text('시간', style: _labelStyle),
              const SizedBox(height: 4),
              Text(time!, style: _valueStyle),
              const SizedBox(height: 16),
            ],
            const Text('계좌번호', style: _labelStyle),
            const SizedBox(height: 4),
            Text(bank, style: _valueStyle),
            const SizedBox(height: 16),
            if (price != null) ...[
              const Text('가격', style: _labelStyle),
              const SizedBox(height: 4),
              Text(price!, style: _valueStyle),
              const SizedBox(height: 16),
            ],
            const Text('차량번호', style: _labelStyle),
            const SizedBox(height: 4),
            TextField(
              decoration: InputDecoration(
                hintText: '차량번호를 입력하세요',
                filled: true,
                fillColor: const Color(0xFFF3F3F3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              controller: TextEditingController(text: carNumber ?? ''),
              style: _valueStyle,
              readOnly: carNumber != null && carNumber!.isNotEmpty,
            ),
            const SizedBox(height: 16),
            const Text('승하차지점', style: _labelStyle),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Wrap(
                spacing: 12,
                children: stops.map((e) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Color(0xFFB2FF59)),
                    const SizedBox(width: 5),
                    Text(e, style: const TextStyle(fontSize: 15, color: Color(0xFF444C39))),
                  ],
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text('탑승자', style: _labelStyle),
            if (riderStatusTitle != null) ...[
              const SizedBox(height: 4),
              Text(riderStatusTitle!, style: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD))),
            ],
            const SizedBox(height: 8),
            Wrap(
              runSpacing: 14,
              spacing: 16,
              children: riders.map((r) => _RiderChip(rider: r)).toList(),
            ),
            const SizedBox(height: 24),
            const Text('안내사항', style: _labelStyle),
            const SizedBox(height: 4),
            Text(notice, style: _valueStyle),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // 방 삭제 로직
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A3D),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                child: const Text('방 삭제하기'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

const _labelStyle = TextStyle(color: Color(0xFFBDBDBD), fontSize: 14);
const _valueStyle = TextStyle(color: Color(0xFF222222), fontSize: 16, fontWeight: FontWeight.w500);

class _RiderChip extends StatelessWidget {
  final Rider rider;
  const _RiderChip({required this.rider});
  @override
  Widget build(BuildContext context) {
    final isPaid = rider.status == '입금 완료';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF444C39),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: const Color(0xFFB2FF59),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(rider.name, style: const TextStyle(fontSize: 14, color: Color(0xFF444C39))),
        const SizedBox(height: 2),
        Text(rider.status, style: TextStyle(fontSize: 13, color: isPaid ? Color(0xFFB2FF59) : Color(0xFFBDBDBD))),
        const SizedBox(height: 4),
        SizedBox(
          width: 90,
          height: 32,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: isPaid ? const Color(0xFFB2FF59) : const Color(0xFFBDBDBD)),
              foregroundColor: Color(0xFF444C39),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
            child: const Text('방 내보내기'),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: RoomManageScreen(
      title: '카풀_관리하기',
      dateTime: '2025.05.01 15:00',
      bank: '1101-328-16399 토스뱅크 김한동',
      price: '1,200원',
      carNumber: '11가 2222',
      stops: ['오흠', '비벤', '다이소', '유아', '이원'],
      riders: [
        Rider(name: '김한동', status: '입금 대기중'),
        Rider(name: '김한서', status: '입금 완료'),
        Rider(name: '김한빈', status: '입금 대기중'),
        Rider(name: '김한복', status: '입금 완료'),
      ],
      notice: '깨끗하게 이용 부탁드립니다.',
    ),
    debugShowCheckedModeBanner: false,
  ));
}
