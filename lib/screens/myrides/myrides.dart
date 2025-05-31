import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:auto_size_text/auto_size_text.dart';


void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyRidesScreen(),
  ));
}

// -------------------- 커스텀 탭바 --------------------
class CustomMenuBar extends StatelessWidget {
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController? tabController = DefaultTabController.of(context);
    final primary = Theme.of(context).colorScheme.primary; // 연두색

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black45,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: -1,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: -1,
            ),
            indicator: const BoxDecoration(), // 인디케이터 숨김
            tabs: const [
              Tab(text: '카풀 / 택시'),
              Tab(text: '고정카풀'),
            ],
          ),
          // 커스텀 그라데이션 라인 + 원
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabCount = 2;
                final tabWidth = constraints.maxWidth / tabCount;
                final selected = tabController?.index ?? 0;
                final centerX = tabWidth * (selected + 0.5);

                return IgnorePointer(
                  child: AnimatedBuilder(
                    animation: tabController!.animation!,
                    builder: (context, child) {
                      final value = tabController.animation!.value;
                      final animatedCenterX = tabWidth * (value + 0.5);

                      return CustomPaint(
                        painter: _TabIndicatorPainter(
                          centerX: animatedCenterX,
                          width: constraints.maxWidth,
                          color: primary,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabIndicatorPainter extends CustomPainter {
  final double centerX;
  final double width;
  final Color color;

  _TabIndicatorPainter({
    required this.centerX,
    required this.width,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height - 2;
    final linePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          color.withOpacity(0.0),
          color.withOpacity(0.5),
          color,
          color.withOpacity(0.5),
          color.withOpacity(0.0),
        ],
        stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
      ).createShader(Rect.fromPoints(Offset(0, y), Offset(width, y)))
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(0, y), Offset(width, y), linePaint);

    final circlePaint = Paint()..color = color;
    canvas.drawCircle(Offset(centerX, y), 6.4, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _TabIndicatorPainter oldDelegate) =>
      centerX != oldDelegate.centerX ||
          color != oldDelegate.color ||
          width != oldDelegate.width;
}

// -------------------- 메인 화면 --------------------
class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F7),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const SizedBox.shrink(),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: CustomMenuBar(),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            // 카풀/택시 탭
            MyRidesTab(isFixed: false),
            // 고정카풀 탭 (데이터만 다름)
            MyRidesTab(isFixed: true),
          ],
        ),
      ),
    );
  }
}

// -------------------- 탭별 본문 --------------------
class MyRidesTab extends StatelessWidget {
  final bool isFixed;
  const MyRidesTab({super.key, required this.isFixed});

  @override
  Widget build(BuildContext context) {
    // 실제 데이터는 서버에서 받아오겠지만 예시로 고정
    final myCreatedRooms = isFixed
        ? []
        : [
      {
        'isMine': true,
        'name': '김한동',
        'date': '4월 3일',
        'time': '15:00',
        'route': ['오흠', '다이소', '유야'],
        'price': '1,200원',
        'status': '입금현황 2 / 4',
        'isTaxi': false,
      },
    ];
    final myJoinedRooms = isFixed
        ? []
        : [
      {
        'isMine': false,
        'name': '김한동',
        'date': '4월 3일',
        'time': '15:00',
        'route': ['오흠', '다이소', '유야'],
        'price': '1,200원',
        'status': '2 / 4',
        'account': '1101-328-16399 토스뱅크 김한동',
        'isTaxi': false,
      },
      {
        'isMine': false,
        'name': '김한동',
        'date': '4월 3일',
        'time': '15:00',
        'route': ['오흠', '다이소', '유야'],
        'price': '택시',
        'status': '2 / 4',
        'account': '1101-328-16399 토스뱅크 김한동',
        'isTaxi': true,
      },
    ];

    return ListView(
      children: [
        _SectionHeader(title: '남이 타요'),
        if (myCreatedRooms.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                '내가 만든 방이 없어요.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        else
          ...myCreatedRooms.map((room) => _RideCard(room: room)).toList(),
        const Divider(height: 1, thickness: 8, color: Color(0xFFF3F3F3)),
        _SectionHeader(title: '내가 타요'),
        if (myJoinedRooms.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                '이용중인 방이 없어요.',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          )
        else
          ...myJoinedRooms.map((room) => _RideCard(room: room)).toList(),
        const SizedBox(height: 24),
      ],
    );
  }
}

// -------------------- 섹션 헤더 --------------------
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF222222),
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}

// -------------------- 카드 --------------------
class _RideCard extends StatelessWidget {
  final Map<String, dynamic> room;
  const _RideCard({required this.room});

  @override
  Widget build(BuildContext context) {
    final isMine = room['isMine'] == true;
    final isTaxi = room['isTaxi'] == true;
    final route = (room['route'] as List<dynamic>?) ?? ['오흠', '다이소', '유야'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단: 프로필 점 + 이름
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFF888888),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                room['name'] ?? '',
                style: const TextStyle(fontSize: 13, color: Color(0xFF444C39)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 날짜/시간
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                room['date'] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                room['time'] ?? '',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // 경로 타임라인
          Row(
            children: [
              for (var i = 0; i < route.length; i++) ...[
                Text(
                  route[i],
                  style: const TextStyle(fontSize: 13, color: Color(0xFF444C39)),
                ),
                if (i < route.length - 1) ...[
                  const SizedBox(width: 8),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
              const SizedBox(width: 2),
              Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF888888)),
            ],
          ),
          if (!isMine) ...[
            const SizedBox(height: 12),
            // 계좌 정보
    Row(
    children: [
    Text(
    room['account'] ?? '',
    style: const TextStyle(fontSize: 13, color: Color(0xFF888888)),
    ),
    const SizedBox(width: 4),
    InkWell(
    onTap: () async {
    final text = room['account'] ?? '';
    if (text.isNotEmpty) {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('계좌번호가 복사되었습니다.'),
    duration: Duration(seconds: 1),
    ),
    );
    }
    },
    child: const Icon(Icons.copy, size: 13, color: Color(0xFFB6E388)),
    ),
    ],
    ),
    ],
          const SizedBox(height: 12),
          // 하단: 금액, 인원, 버튼
          Row(
            children: [
              Text(
                isTaxi
                    ? '택시'
                    : '카풀 ${room['price'] ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF222222),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                room['status'] ?? '2 / 4',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF888888),
                ),
              ),
              const Spacer(),
              Icon(Icons.person_outline, size: 18, color: Color(0xFF888888)),
              const SizedBox(width: 2),
              Text(
                room['status']?.split(' ').last ?? '2 / 4',
                style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
              const SizedBox(width: 16),
              if (isMine)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //TODO 이거 builder를 백 연결되야 뜨게 해서 연결하고 풀면 될 것 같아요
                      //context.go('/manage'); // 원하는 경로로 이동
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF444C39),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: const Text('관리하기'),
                  ),
                )
              else ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '입금이 완료되었습니다.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF222222),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // 모달 닫기
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF444C39),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text('확인'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF444C39),
                      side: const BorderSide(color: Color(0xFF888888)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(0, 40),
                    ),
                    child: const Text('입금완료'),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Container(
                              width: 300,
                              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '방을 나가시겠습니까?',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF222222),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 모달 닫기
                                          },
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(0xFF222222),
                                            side: const BorderSide(color: Color(0xFF888888)),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: const Text('취소'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 모달 닫기
                                            // 실제 나가기 동작 추가 (예: setState, API 호출 등)
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF444C39),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            minimumSize: const Size(0, 40),
                                          ),
                                          child: const Text('나가기'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF444C39),
                      side: const BorderSide(color: Color(0xFF888888)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('나가기'),
                  ),
                ),

              ],
            ],
          ),
        ],
      ),
    );
  }
}