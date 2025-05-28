import 'package:flutter/material.dart';
import 'package:tayo_fe/widgets/common/custom_menu_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  List<String> pickupSelected = [];
  List<String> dropoffSelected = [];

  final List<String> points = [
    '오흠',
    '비벤',
    '야공',
    '버정',
    '현동',
    '느헴',
    '채플',
    '다이소',
    '그할마',
    '궁물촌',
    '유아',
    '이원',
  ];

  @override
  Widget build(BuildContext context) {
    double chipMaxWidth = MediaQuery.of(context).size.width / 5.0;
    final primary = Theme.of(context).colorScheme.primary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(55),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(28),
              child: CustomMenuBar(),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // 1. 카풀/택시 탭
            Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '날짜',
                            isSelected: selectedDate != null,
                            onTap: () async {
                              final result = await showCustomDatePicker(
                                context,
                                selectedDate,
                              );
                              if (result != null) {
                                setState(() {
                                  selectedDate = result;
                                });
                              }
                            },
                            selectedText:
                                selectedDate == null
                                    ? '날짜'
                                    : '${selectedDate!.year % 100}.${selectedDate!.month.toString().padLeft(2, '0')}.${selectedDate!.day.toString().padLeft(2, '0')} (${_weekday(selectedDate!)})',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '승차지점',
                            isSelected: pickupSelected.isNotEmpty,
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<List<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return _PointFilterSheet(
                                        title: '승차지점',
                                        allPoints: points,
                                        initSelected: pickupSelected,
                                      );
                                    },
                                  );
                              if (result != null) {
                                setState(() {
                                  pickupSelected = result;
                                });
                              }
                            },
                            selectedText:
                                pickupSelected.isEmpty
                                    ? '승차지점'
                                    : pickupSelected.join(', '),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '하차지점',
                            isSelected: dropoffSelected.isNotEmpty,
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<List<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return _PointFilterSheet(
                                        title: '하차지점',
                                        allPoints: points,
                                        initSelected: dropoffSelected,
                                      );
                                    },
                                  );
                              if (result != null) {
                                setState(() {
                                  dropoffSelected = result;
                                });
                              }
                            },
                            selectedText:
                                dropoffSelected.isEmpty
                                    ? '하차지점'
                                    : dropoffSelected.join(', '),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Center(child: Text('카풀/택시 탭 내용'))),
              ],
            ),
            // 2. 고정카풀 탭
            Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '시작일',
                            isSelected: selectedStartDate != null,
                            onTap: () async {
                              final result = await showCustomDatePicker(
                                context,
                                selectedStartDate,
                              );
                              if (result != null) {
                                setState(() {
                                  selectedStartDate = result;
                                });
                              }
                            },
                            selectedText:
                                selectedStartDate == null
                                    ? '시작일'
                                    : '${selectedStartDate!.year % 100}.${selectedStartDate!.month.toString().padLeft(2, '0')}.${selectedStartDate!.day.toString().padLeft(2, '0')} (${_weekday(selectedStartDate!)})',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '종료일',
                            isSelected: selectedEndDate != null,
                            onTap: () async {
                              final result = await showCustomDatePicker(
                                context,
                                selectedEndDate,
                              );
                              if (result != null) {
                                setState(() {
                                  selectedEndDate = result;
                                });
                              }
                            },
                            selectedText:
                                selectedEndDate == null
                                    ? '종료일'
                                    : '${selectedEndDate!.year % 100}.${selectedEndDate!.month.toString().padLeft(2, '0')}.${selectedEndDate!.day.toString().padLeft(2, '0')} (${_weekday(selectedEndDate!)})',
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '승차지점',
                            isSelected: pickupSelected.isNotEmpty,
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<List<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return _PointFilterSheet(
                                        title: '승차지점',
                                        allPoints: points,
                                        initSelected: pickupSelected,
                                      );
                                    },
                                  );
                              if (result != null) {
                                setState(() {
                                  pickupSelected = result;
                                });
                              }
                            },
                            selectedText:
                                pickupSelected.isEmpty
                                    ? '승차지점'
                                    : pickupSelected.join(', '),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: chipMaxWidth,
                          child: _FilterChip(
                            label: '하차지점',
                            isSelected: dropoffSelected.isNotEmpty,
                            onTap: () async {
                              final result =
                                  await showModalBottomSheet<List<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return _PointFilterSheet(
                                        title: '하차지점',
                                        allPoints: points,
                                        initSelected: dropoffSelected,
                                      );
                                    },
                                  );
                              if (result != null) {
                                setState(() {
                                  dropoffSelected = result;
                                });
                              }
                            },
                            selectedText:
                                dropoffSelected.isEmpty
                                    ? '하차지점'
                                    : dropoffSelected.join(', '),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Center(child: Text('고정카풀 탭 내용'))),
              ],
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 24, bottom: 32),
          child: PlusButton(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) => const RoomTypeDialog(),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  String _weekday(DateTime date) {
    const week = ['월', '화', '수', '목', '금', '토', '일'];
    return week[date.weekday - 1];
  }
}

// 56x56px 연두색 + 버튼 위젯
class PlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const PlusButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFB2FF59), // 연두색
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.black, size: 32),
        ),
      ),
    );
  }
}

// 이미지와 동일한 모달 다이얼로그
class RoomTypeDialog extends StatelessWidget {
  const RoomTypeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '만들고 싶은 방을 선택해 주세요',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF222222),
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                _RoomTypeButton(
                  label: '카풀',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/create-carpool');
                  },
                ),
                const SizedBox(width: 16),
                _RoomTypeButton(
                  label: '택시',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/create-taxi');
                  },
                ),
                const SizedBox(width: 16),
                _RoomTypeButton(
                  label: '고정카풀',
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go('/create-fixed-carpool');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 각 방 타입 버튼 위젯
class _RoomTypeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _RoomTypeButton({required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 108,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF222222),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 이하 기존 _FilterChip, showCustomDatePicker, _PointFilterSheet, _FilterModalContainer 그대로 사용 ---
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? selectedText;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.selectedText,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return OutlinedButton.icon(
      icon: Icon(Icons.arrow_drop_down, size: 20, color: Colors.grey),
      label: Text(
        selectedText ?? label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: isSelected ? Colors.black : Colors.grey),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor:
            isSelected ? primary.withOpacity(0.15) : Color(0xFFF7F8F8),
        side: BorderSide.none, // 테두리 완전히 제거
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      ),
      onPressed: onTap,
    );
  }
}

Future<DateTime?> showCustomDatePicker(
  BuildContext context,
  DateTime? initialDate,
) {
  final primary = Theme.of(context).colorScheme.primary;
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: primary, // 선택된 날짜(원)
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, // OK, Cancel 버튼
              textStyle: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );
}

class _PointFilterSheet extends StatefulWidget {
  final String title;
  final List<String> allPoints;
  final List<String> initSelected;
  const _PointFilterSheet({
    required this.title,
    required this.allPoints,
    required this.initSelected,
  });

  @override
  State<_PointFilterSheet> createState() => _PointFilterSheetState();
}

class _PointFilterSheetState extends State<_PointFilterSheet> {
  late List<String> selected;

  @override
  void initState() {
    super.initState();
    selected = List.from(widget.initSelected);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return _FilterModalContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...widget.allPoints.map((e) {
                final isSelected = selected.contains(e);
                return FilterChip(
                  label: Text(e),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        selected.add(e);
                      } else {
                        selected.remove(e);
                      }
                    });
                  },
                  selectedColor: primary,
                  backgroundColor: Color(0xFFF7F8F8),
                  labelStyle: TextStyle(color: Colors.black),
                  shape: StadiumBorder(),
                  side: BorderSide.none, // 테두리 완전히 제거
                );
              }),
              ActionChip(
                label: Icon(Icons.add, color: Colors.black),
                backgroundColor: Color(0xFFF7F8F8),
                onPressed: () {
                  // TODO: 새로운 장소 추가 로직
                },
                side: BorderSide.none, // 테두리 제거
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context, selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('적용하기', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterModalContainer extends StatelessWidget {
  final Widget child;
  const _FilterModalContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 80,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: SingleChildScrollView(child: child),
    );
  }
}
