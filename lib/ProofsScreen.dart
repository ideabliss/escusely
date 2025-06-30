import 'package:flutter/material.dart';

class ProofsScreen extends StatefulWidget {
  const ProofsScreen({super.key});

  @override
  State<ProofsScreen> createState() => _ProofsScreenState();
}

class _ProofsScreenState extends State<ProofsScreen> {
  String selectedContext = 'Work';
  TextEditingController promptController = TextEditingController();
  int _selectedIndex = 3;

  final List<Map<String, String>> proofs = [
    {
      'context': 'Work',
      'title': 'Proof 1',
      'date': '2024-01-20 10:00 AM',
      'image': 'https://via.placeholder.com/60x60.png?text=1'
    },
    {
      'context': 'School',
      'title': 'Proof 2',
      'date': '2024-01-19 03:30 PM',
      'image': 'https://via.placeholder.com/60x60.png?text=2'
    },
    {
      'context': 'Social',
      'title': 'Proof 3',
      'date': '2024-01-18 08:15 PM',
      'image': 'https://via.placeholder.com/60x60.png?text=3'
    },
  ];

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 3:
        // Current screen
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141A1F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Proof Generator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Excuse Context',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: ['Work', 'School', 'Social'].map((context) {
                bool isSelected = selectedContext == context;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(context),
                    selected: isSelected,
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Color(0xFF141A1F) : Colors.white,
                    ),
                    backgroundColor: const Color(0xFF1F272E),
                    onSelected: (_) {
                      setState(() => selectedContext = context);
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F272E),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: promptController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Describe your proof',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Placeholder for generation logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proof generation not implemented')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDCE8F3),
                foregroundColor: const Color(0xFF141A1F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text(
                'Generate Proof',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Generated Proofs',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: proofs.length,
                itemBuilder: (context, index) {
                  final item = proofs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['image']!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['title']!,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['context']!, style: const TextStyle(color: Colors.grey)),
                        Text(item['date']!, style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                    trailing: const Icon(Icons.download, color: Colors.white),
                    onTap: () {},
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F272E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
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
}
