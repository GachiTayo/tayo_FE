import 'package:flutter/material.dart';

// 이미지와 같은 커스텀 탭바(메뉴바)
class CustomMenuBar extends StatelessWidget {
  const CustomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    final TabController? tabController = DefaultTabController.of(context);
    final primary = Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // TabBar
          TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black45,
            indicator: const BoxDecoration(), // 인디케이터 숨김
            tabs: const [Tab(text: '카풀 / 택시'), Tab(text: '고정카풀')],
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
                      // 탭 이동 애니메이션에 따라 원 위치 계산
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
    // 라인과 원을 아래로 내림 (탭바 하단에 딱 맞게)
    final y = size.height - 2; // 2px 위쪽에 위치

    // shader의 시작점/끝점을 (0, y) ~ (width, y)로 맞춤
    final linePaint =
        Paint()
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
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    // 라인 그리기 (탭바 하단 전체)
    canvas.drawLine(Offset(0, y), Offset(width, y), linePaint);

    // 연두색 원 (크기 0.8배: 반지름 8 → 6.4)
    final circlePaint = Paint()..color = color;
    canvas.drawCircle(Offset(centerX, y), 6.4, circlePaint);
  }

  @override
  bool shouldRepaint(covariant _TabIndicatorPainter oldDelegate) =>
      centerX != oldDelegate.centerX ||
      color != oldDelegate.color ||
      width != oldDelegate.width;
}

class MyRidesScreen extends StatelessWidget {
  const MyRidesScreen({super.key});

  // 카풀/택시 탭 데이터
  final List<Map<String, dynamic>> myCreatedCarpoolRooms = const [
    {'title': '카풀방1', 'desc': '카풀방 설명1'},
    {'title': '카풀방2', 'desc': '카풀방 설명2'},
  ];
  final List<Map<String, dynamic>> myJoinedCarpoolRooms = const [
    {'title': '참여 카풀방1', 'desc': '참여 설명1'},
  ];

  // 고정카풀 탭 데이터
  final List<Map<String, dynamic>> myCreatedFixedRooms = const [
    {'title': '고정카풀방1', 'desc': '고정카풀 설명1'},
  ];
  final List<Map<String, dynamic>> myJoinedFixedRooms = const [
    {'title': '참여 고정카풀방1', 'desc': '참여 고정 설명1'},
    {'title': '참여 고정카풀방2', 'desc': '참여 고정 설명2'},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // [카풀/택시, 고정카풀]
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const SizedBox.shrink(),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48), // 커스텀 메뉴바 높이(48)로 수정
              child: CustomMenuBar(), // 커스텀 탭바 적용
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF9F9F7),
        body: TabBarView(
          children: [
            // 1. 카풀/택시 탭
            _RidesSection(
              myCreatedRooms: myCreatedCarpoolRooms,
              myJoinedRooms: myJoinedCarpoolRooms,
            ),
            // 2. 고정카풀 탭
            _RidesSection(
              myCreatedRooms: myCreatedFixedRooms,
              myJoinedRooms: myJoinedFixedRooms,
            ),
          ],
        ),
      ),
    );
  }
}

class _RidesSection extends StatelessWidget {
  final List<Map<String, dynamic>> myCreatedRooms;
  final List<Map<String, dynamic>> myJoinedRooms;
  const _RidesSection({
    required this.myCreatedRooms,
    required this.myJoinedRooms,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _SectionHeader(title: '내가 만든 방'),
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
          ...myCreatedRooms.map((room) => _RoomCard(room: room)).toList(),
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
          ...myJoinedRooms.map((room) => _RoomCard(room: room)).toList(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(20, 24, 0, 12),
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

// 방 카드 예시 (실제 방 정보로 교체)
class _RoomCard extends StatelessWidget {
  final Map<String, dynamic> room;
  const _RoomCard({required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            room['title'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF222222),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            room['desc'] ?? '',
            style: const TextStyle(fontSize: 14, color: Color(0xFF444C39)),
          ),
        ],
      ),
    );
  }
}
