import 'package:flutter/material.dart';

class TaxiCreateRoomScreen extends StatefulWidget {
  const TaxiCreateRoomScreen({super.key});

  @override
  State<TaxiCreateRoomScreen> createState() => _TaxiCreateRoomScreenState();
}

class _TaxiCreateRoomScreenState extends State<TaxiCreateRoomScreen> {
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? selectedTime;
  String people = '';
  String bankInfo = '';
  String description = '';
  int descriptionLength = 0;

  final List<String> points = [
    '오흠', '비벤', '야공', '버정', '현동',
    '느헴', '채플', '다이소', '그할마', '궁물촌',
    '유아', '이원'
  ];
  final List<Map<String, String>> recentRooms = [
    {'time': '15:00', 'start': '오흡', 'via': '다이소', 'end': '유아'},
    {'time': '24:00', 'start': '오흡', 'via': '다이소', 'end': '유아'},
    {'time': '15:00', 'start': '비벤', 'via': '이원', 'end': '유아'},
  ];
  List<String> selectedPickup = [];
  List<String> selectedDropoff = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444C39)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 구분
            const Text('구분', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            _TypeChip(label: '택시', selected: true, onTap: () {}),
            const SizedBox(height: 24),
            // 최근 생성 내역
            const Text('최근 고정카풀 생성 내역', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: recentRooms.map((room) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFB2FF59), width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(room['time']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF444C39))),
                        const SizedBox(height: 4),
                        Text('${room['start']} ${room['via']}', style: const TextStyle(fontSize: 12, color: Color(0xFF444C39))),
                        Text('${room['end']}', style: const TextStyle(fontSize: 12, color: Color(0xFF444C39))),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // 시작일/종료일
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('시작일', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: startDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => startDate = picked);
                        },
                        child: _InputBox(
                          text: startDate == null
                              ? '시작일 선택'
                              : '${startDate!.year}.${startDate!.month.toString().padLeft(2, '0')}.${startDate!.day.toString().padLeft(2, '0')}',
                          icon: Icons.calendar_today,
                          isHint: startDate == null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('종료일', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: endDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => endDate = picked);
                        },
                        child: _InputBox(
                          text: endDate == null
                              ? '종료일 선택'
                              : '${endDate!.year}.${endDate!.month.toString().padLeft(2, '0')}.${endDate!.day.toString().padLeft(2, '0')}',
                          icon: Icons.calendar_today,
                          isHint: endDate == null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 시간
            const Text('시간', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
              child: _InputBox(
                text: selectedTime == null
                    ? '시간 선택'
                    : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                icon: Icons.access_time,
                isHint: selectedTime == null,
              ),
            ),
            const SizedBox(height: 20),
            // 인원
            const Text('인원', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('인원수를 입력하세요'),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => people = v),
            ),
            const SizedBox(height: 24),
            // 경로(출발/도착)
            const Text('경로', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _PointSelector(
                    points: points,
                    selected: selectedPickup,
                    onChanged: (list) => setState(() => selectedPickup = list),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Color(0xFFBDBDBD)),
                const SizedBox(width: 8),
                Expanded(
                  child: _PointSelector(
                    points: points,
                    selected: selectedDropoff,
                    onChanged: (list) => setState(() => selectedDropoff = list),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // 계좌
            const Text('계좌번호 및 은행명', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('1000-1111-2222 토스뱅크'),
              onChanged: (v) => setState(() => bankInfo = v),
            ),
            const SizedBox(height: 20),
            // 안내사항
            const Text('안내사항', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              maxLength: 100,
              decoration: _inputDecoration('안내사항을 입력하세요').copyWith(
                counterText: '${description.length}/100',
              ),
              onChanged: (v) => setState(() {
                description = v;
                descriptionLength = v.length;
              }),
            ),
            const SizedBox(height: 24),
            // 생성하기 버튼
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB2FF59),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                child: const Text('생성하기'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// 아래 _TypeChip, _PointSelector, _InputBox, _inputDecoration 등은 위와 동일하게 사용
// 타입 칩
class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _TypeChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB2FF59) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFB2FF59) : const Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : const Color(0xFF444C39),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// 지점 선택 칩 그룹
class _PointSelector extends StatelessWidget {
  final List<String> points;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  const _PointSelector({required this.points, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: points.map((e) {
        final isSelected = selected.contains(e);
        return ChoiceChip(
          label: Text(e),
          selected: isSelected,
          onSelected: (val) {
            final newList = List<String>.from(selected);
            if (val) {
              newList.add(e);
            } else {
              newList.remove(e);
            }
            onChanged(newList);
          },
          selectedColor: const Color(0xFFB2FF59),
          backgroundColor: const Color(0xFFF3F3F3),
          labelStyle: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF444C39),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }).toList()
        ..add(
          ChoiceChip(
            label: const Icon(Icons.add, size: 18, color: Color(0xFF444C39)),
            selected: false,
            onSelected: (_) {},
            backgroundColor: const Color(0xFFF3F3F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
    );
  }
}

// 입력 박스 (날짜/시간 등)
class _InputBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isHint;
  const _InputBox({required this.text, required this.icon, this.isHint = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isHint ? Colors.grey : const Color(0xFF222222),
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Icon(icon, size: 18, color: const Color(0xFFBDBDBD)),
        ],
      ),
    );
  }
}

// 텍스트필드용 공통 데코레이션
InputDecoration _inputDecoration(String hint) => InputDecoration(
  hintText: hint,
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
);
