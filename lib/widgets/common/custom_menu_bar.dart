import 'package:flutter/material.dart';

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
    // 라인과 원을 탭바 하단에 딱 맞게 내림
    final y = size.height - 2;

    // shader의 시작점/끝점을 (0, y) ~ (width, y)로 맞춤
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
      ).createShader(Rect.fromPoints(
        Offset(0, y),
        Offset(width, y),
      ))
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // 전체 라인을 원 중심 기준으로 그리기
    canvas.drawLine(
      Offset(0, y),
      Offset(width, y),
      linePaint,
    );

    // 연두색 원 (크기 0.8배: 반지름 8 → 6.4)
    final circlePaint = Paint()..color = color;
    canvas.drawCircle(
      Offset(centerX, y),
      6.4,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TabIndicatorPainter oldDelegate) =>
      centerX != oldDelegate.centerX || color != oldDelegate.color || width != oldDelegate.width;
}
