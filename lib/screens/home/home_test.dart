import 'package:flutter/material.dart';
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
        title: const Text('Ride Test Page'),
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1st row: host name
            Text(
              hostName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 2nd row: left - date/time, right - stops
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and Time Column (3 rows for FIXED)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(startDay, style: const TextStyle(fontSize: 14)),
                    Text(departureTime, style: const TextStyle(fontSize: 14)),
                    if (type == 'FIXED' && endDay != null)
                      Text(
                        '~ $endDay',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
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
            const SizedBox(height: 8),

            // 3rd row: type label (카풀/택시) / price / guest count / 입장 button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (rideTypeLabel.isNotEmpty)
                      Text(
                        '$rideTypeLabel  ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    Text('₩$price'),
                  ],
                ),
                Text('$guestCount / $guestNumber 명'),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to ride detail
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB2FF59),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('입장'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
