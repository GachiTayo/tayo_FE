import 'package:flutter/material.dart';
import 'package:tayo_fe/widgets/common/custom_menu_bar.dart'; // 실제 경로에 맞게 import

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
          preferredSize: const Size.fromHeight(87),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: const SizedBox.shrink(),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: CustomMenuBar(), // TabBar 포함
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
            offset: Offset(0, 1),
          )
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
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF444C39),
            ),
          ),
        ],
      ),
    );
  }
}
