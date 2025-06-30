import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;
  List<DocumentSnapshot> allExcuses = [];
  List<DocumentSnapshot> favoriteExcuses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchExcuses();
  }

  Future<void> fetchExcuses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('excuses')
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      allExcuses = snapshot.docs;
      favoriteExcuses = allExcuses
          .where((e) => ((e.data() as Map<String, dynamic>)['isFavorite'] ?? false))
          .toList();
    });
  }

  Future<void> toggleFavorite(DocumentSnapshot excuse) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = excuse.reference;
    final data = excuse.data() as Map<String, dynamic>;
    await ref.update({'isFavorite': !(data['isFavorite'] ?? false)});
    fetchExcuses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141A1F),
        elevation: 0,
        title: const Text(
          'Excuse History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'All History'),
              Tab(text: 'Favorites'),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildFilterChip('Date'),
                const SizedBox(width: 8),
                _buildFilterChip('Date Range'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryList(allExcuses),
                _buildHistoryList(favoriteExcuses),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F272E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/proofs');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/settings');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.image_outlined), label: 'Proofs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1F272E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3D4D5C)),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<DocumentSnapshot> data) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: data.length,
      separatorBuilder: (_, __) => const Divider(color: Colors.transparent),
      itemBuilder: (context, index) {
        final excuse = data[index];
        final dataMap = excuse.data() as Map<String, dynamic>;
        final timestamp = dataMap['timestamp'] as Timestamp;
        final formattedTime = DateFormat.yMMMd().add_jm().format(timestamp.toDate());

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C3A48),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.text_snippet_outlined, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dataMap['context'] ?? 'Context',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(formattedTime,
                      style: const TextStyle(color: Colors.grey, fontSize: 12, height: 1.4)),
                  const SizedBox(height: 4),
                  Text(dataMap['excuse'] ?? '',
                      style: const TextStyle(color: Colors.white70, height: 1.4, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                (dataMap['isFavorite'] ?? false)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () => toggleFavorite(excuse),
            ),
          ],
        );
      },
    );
  }
}
