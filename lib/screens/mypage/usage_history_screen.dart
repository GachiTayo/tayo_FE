import 'package:flutter/material.dart';

class UsageHistoryScreen extends StatelessWidget {
  const UsageHistoryScreen({super.key});

  // 샘플 데이터
  List<Map<String, dynamic>> get sampleHistory => [
    {
      "user": "김한동",
      "date": "4월 3일",
      "time": "15:00",
      "start": "오흠",
      "via": "다이소",
      "end": "유아",
      "bank": "1101-328-16399 토스뱅크 김한동",
      "type": "카풀",
      "amount": "1,200원",
    },
    {
      "user": "김한동",
      "date": "4월 3일",
      "time": "15:00",
      "start": "오흠",
      "via": "다이소",
      "end": "유아",
      "bank": "1101-328-16399 토스뱅크 김한동",
      "type": "택시",
      "amount": null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '이용 내역',
          style: TextStyle(
            color: Color(0xFF444C39),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444C39)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: sampleHistory.length,
        separatorBuilder: (context, idx) => const Divider(
          color: Color(0xFFE0E0E0),
          height: 40,
          thickness: 1,
        ),
        itemBuilder: (context, idx) {
          final item = sampleHistory[idx];
          return _UsageHistoryCard(item: item);
        },
      ),
    );
  }
}

class _UsageHistoryCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _UsageHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단: 닉네임
        Row(
          children: [
            const Icon(Icons.circle, size: 8, color: Color(0xFF444C39)),
            const SizedBox(width: 6),
            Text(
              item['user'],
              style: const TextStyle(
                color: Color(0xFF444C39),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 날짜, 시간, 경로
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜, 시간
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['date'],
                  style: const TextStyle(
                    color: Color(0xFF444C39),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item['time'],
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            // 경로
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        item['start'],
                        style: const TextStyle(
                          color: Color(0xFF444C39),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // 경로 선
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 2,
                              color: const Color(0xFFDADADA),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 0),
                                const Icon(Icons.circle, size: 6, color: Color(0xFFDADADA)),
                                const SizedBox(width: 0),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['via'],
                        style: const TextStyle(
                          color: Color(0xFF444C39),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 2,
                              color: const Color(0xFFDADADA),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.circle, size: 6, color: Color(0xFFDADADA)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['end'],
                        style: const TextStyle(
                          color: Color(0xFF444C39),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.location_on, size: 18, color: Color(0xFFBDBDBD)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // 계좌 정보
        Row(
          children: [
            Text(
              item['bank'],
              style: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.copy, size: 14, color: Color(0xFFBDBDBD)),
          ],
        ),
        const SizedBox(height: 8),
        // 타입 및 금액
        Row(
          children: [
            Text(
              item['type'],
              style: TextStyle(
                color: item['type'] == '카풀'
                    ? const Color(0xFFBDBDBD)
                    : const Color(0xFFDADADA),
                fontSize: 15,
              ),
            ),
            if (item['amount'] != null) ...[
              const SizedBox(width: 8),
              Text(
                item['amount'],
                style: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
