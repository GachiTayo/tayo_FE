import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tayo_fe/screens/home/home_screen.dart';
import 'package:tayo_fe/services/ride_services.dart';

class RideTestPage extends StatefulWidget {
  const RideTestPage({Key? key}) : super(key: key);

  @override
  State<RideTestPage> createState() => _RideTestPageState();
}

class _RideTestPageState extends State<RideTestPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> oneWayRides = [];
  List<dynamic> fixedRides = [];
  List<dynamic> taxiRides = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRides();
  }

  Future<void> _loadRides() async {
    try {
      final service = RideService();
      final oneWay = await service.fetchUpcomingRides('ONEWAY');
      final fixed = await service.fetchUpcomingRides('FIXED');
      final taxi = await service.fetchUpcomingRides('TAXI');
      setState(() {
        oneWayRides = oneWay;
        fixedRides = fixed;
        taxiRides = taxi;
      });
    } catch (e) {
      print('❌ Error fetching rides: $e');
    }
  }

  Widget buildRideList(List<dynamic> rides) {
    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        return buildRideTile(rides[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: '카풀/택시'), Tab(text: '고정카풀')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildRideList([...oneWayRides, ...taxiRides]),
          buildRideList(fixedRides),
          buildRideList(taxiRides),
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
    );
  }

  Widget buildRideTile(Map<String, dynamic> ride) {
    final hostName = ride['host']['name'] ?? '호스트 없음';
    final type = ride['type'] ?? 'UNKNOWN';
    final startDay = ride['startDay'] ?? '날짜 없음';
    final endDay = ride['endDay'];
    final departureTime = ride['departureTime'] ?? '시간 없음';
    final stops =
        (ride['stops'] as List<dynamic>?)
            ?.where((s) => s.toString().isNotEmpty)
            .toList() ??
        [];
    final price = ride['price'] ?? 0;
    final guestNumber = ride['guestNumber'] ?? 0;
    final guestCount = (ride['guests'] as List<dynamic>?)?.length ?? 0;

    String rideTypeLabel = '';
    switch (type) {
      case 'ONEWAY':
        rideTypeLabel = '카풀';
        break;
      case 'TAXI':
        rideTypeLabel = '택시';
        break;
      case 'FIXED':
        rideTypeLabel = '';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Host row
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Color(0xFF444C39)),
                const SizedBox(width: 6),
                Text(
                  hostName,
                  style: const TextStyle(
                    color: Color(0xFF444C39),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date/Time + Stops
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startDay,
                      style: const TextStyle(
                        color: Color(0xFF444C39),
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      departureTime,
                      style: const TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (type == 'FIXED' && endDay != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '~ $endDay',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 24),

                // Stops
                Expanded(
                  child: Text(
                    stops.join(' → '),
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Type, price, guests, button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (rideTypeLabel.isNotEmpty)
                      Text(
                        rideTypeLabel,
                        style: TextStyle(
                          color:
                              rideTypeLabel == '카풀'
                                  ? const Color(0xFFBDBDBD)
                                  : const Color(0xFFDADADA),
                          fontSize: 15,
                        ),
                      ),
                    const SizedBox(width: 8),
                    SizedBox(),
                    Text(
                      '₩$price',
                      style: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Text('$guestCount / $guestNumber 명'),

                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to ride detail
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // ✅ black background
                    foregroundColor: Colors.white, // ✅ white text
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, // ⬅ narrower than 16
                      vertical: 6, // ⬅ shorter height
                    ),
                    minimumSize: Size.zero, // ⬅ prevents default min size
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap, // ⬅ avoids extra padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ), // ⬅ slightly smaller corners
                    ),
                  ),
                  child: const Text(
                    '입장',
                    style: TextStyle(fontSize: 13), // ⬅ smaller font
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
