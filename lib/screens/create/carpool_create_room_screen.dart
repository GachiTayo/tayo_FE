import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarpoolCreateRoomScreen extends StatefulWidget {
  const CarpoolCreateRoomScreen({super.key});

  @override
  State<CarpoolCreateRoomScreen> createState() => _CarpoolCreateRoomScreenState();
}

class _CarpoolCreateRoomScreenState extends State<CarpoolCreateRoomScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String people = '';
  String bankInfo = '';
  String price = '';
  String carNumber = '';
  String description = '';
  int descriptionLength = 0;

  List<String> points = [
    '오흡', '비벤', '야공', '버정', '현동',
    '느헴', '채플', '다이소', '그할마', '궁물촌',
    '유아', '이원'
  ];
  final List<Map<String, String>> recentRooms = [
    {'time': '15:00', 'start': '오흡', 'via': '다이소', 'end': '유아'},
    {'time': '24:00', 'start': '오흡', 'via': '다이소', 'end': '유아'},
    {'time': '15:00', 'start': '오흡', 'via': '비벤', 'end': '유아'},
  ];
  List<String> selectedPickup = [];
  List<String> selectedDropoff = [];
  String selectedType = '카풀';

  // 입력 다이얼로그 함수
  Future<void> _showAddPointDialog({
    required BuildContext context,
    required Function(String) onAdd,
  }) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('지점 추가'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: '지점 이름 입력',
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return '지점명을 입력하세요';
              if (points.contains(v.trim())) return '이미 존재하는 지점입니다';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                onAdd(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF444C39)),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('', style: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.w600, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('구분', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            _TypeChip(
              label: '카풀',
              selected: selectedType == '카풀',
              onTap: () => setState(() => selectedType = '카풀'),
            ),
            const SizedBox(height: 24),
            const Text('최근 카풀 생성 내역', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
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
            const Text('날짜', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
              child: _InputBox(
                text: selectedDate == null ? '날짜 선택' : '${selectedDate!.year % 100}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.day.toString().padLeft(2, '0')}',
                icon: Icons.calendar_today,
                isHint: selectedDate == null,
              ),
            ),
            const SizedBox(height: 20),
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
                text: selectedTime == null ? '시간 선택' : '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}',
                icon: Icons.access_time,
                isHint: selectedTime == null,
              ),
            ),
            const SizedBox(height: 20),
            const Text('인원', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('인원수를 입력하세요'),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => people = v),
            ),
            const SizedBox(height: 24),
            const Text('승차지점', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            _SelectedPointRow(
              selected: selectedPickup,
            ),
            const SizedBox(height: 8),
            _PointSelector(
              points: points,
              selected: selectedPickup,
              onChanged: (list) => setState(() => selectedPickup = list),
              onAddPoint: (context) async {
                await _showAddPointDialog(
                  context: context,
                  onAdd: (newPoint) => setState(() => points.add(newPoint)),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('하차지점', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            _SelectedPointRow(
              selected: selectedDropoff,
            ),
            const SizedBox(height: 8),
            _PointSelector(
              points: points,
              selected: selectedDropoff,
              onChanged: (list) => setState(() => selectedDropoff = list),
              onAddPoint: (context) async {
                await _showAddPointDialog(
                  context: context,
                  onAdd: (newPoint) => setState(() => points.add(newPoint)),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('계좌번호 및 은행명', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('1000-1111-2222 토스뱅크'),
              onChanged: (v) => setState(() => bankInfo = v),
            ),
            const SizedBox(height: 20),
            const Text('가격', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('가격을 입력하세요'),
              keyboardType: TextInputType.number,
              onChanged: (v) => setState(() => price = v),
            ),
            const SizedBox(height: 20),
            const Text('차량번호', style: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              decoration: _inputDecoration('11가 2222'),
              onChanged: (v) => setState(() => carNumber = v),
            ),
            const SizedBox(height: 20),
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
                  textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
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

class _TypeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeChip({required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFB2FF59) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: selected ? null : Border.all(color: const Color(0xFFDADADA), width: 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.black : const Color(0xFFBDBDBD),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _SelectedPointRow extends StatelessWidget {
  final List<String> selected;
  const _SelectedPointRow({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(3, (i) {
        if (i < selected.length) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              height: 40,
              child: Container(
                constraints: const BoxConstraints(minWidth: 96),
                decoration: BoxDecoration(
                  color: const Color(0xFFB2FF59),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    selected[i],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              height: 40,
              child: Container(
                constraints: const BoxConstraints(minWidth: 96),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFDADADA), width: 1),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                ),
                child: const Center(child: Text('')),
              ),
            ),
          );
        }
      }),
    );
  }
}

class _PointSelector extends StatelessWidget {
  final List<String> points;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;
  final Future<void> Function(BuildContext context)? onAddPoint;
  const _PointSelector({
    required this.points,
    required this.selected,
    required this.onChanged,
    this.onAddPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...points.map((e) {
          final isSelected = selected.contains(e);
          return ChoiceChip(
            label: Text(e),
            selected: isSelected,
            onSelected: (val) {
              final newList = List<String>.from(selected);
              if (val) {
                if (!newList.contains(e) && newList.length < 3) newList.add(e);
              } else {
                newList.remove(e);
              }
              onChanged(newList);
            },
            selectedColor: const Color(0xFFB2FF59),
            backgroundColor: const Color(0xFFF3F3F3),
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFF444C39),
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          );
        }),
        ChoiceChip(
          label: const Icon(Icons.add, size: 18, color: Color(0xFF444C39)),
          selected: false,
          onSelected: (_) async {
            if (onAddPoint != null) await onAddPoint!(context);
          },
          backgroundColor: const Color(0xFFF3F3F3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ],
    );
  }
}

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
