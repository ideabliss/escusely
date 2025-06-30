import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedContext = 'Select';
  double urgencyValue = 0.3;
  double believabilityValue = 0.3;
  String generatedExcuse = '';
  String description = '';
  int _selectedIndex = 0;

  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
  }

  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
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
  }

  Future<void> generateExcuse() async {
  final prompt =
      "Give a realistic and creative excuse in 1 sentence for the context '$selectedContext' considering the urgency level ${urgencyValue.toStringAsFixed(1)} and believability ${believabilityValue.toStringAsFixed(1)}. Here's the description: $description";

  const geminiApiKey = 'AIzaSyDvdjXjEaA5rLPzfD61ViI9ZaY6iKRQl0c';
  final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$geminiApiKey');

  final response = await http.post(
    uri,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    final text = decoded['candidates'][0]['content']['parts'][0]['text'];

    setState(() {
      generatedExcuse = text;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('excuses')
            .add({
          'context': selectedContext,
          'urgency': urgencyValue,
          'believability': believabilityValue,
          'description': description,
          'excuse': text,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (e) {
      debugPrint("Error writing to Firestore: $e");
    }
  } else {
    setState(() {
      generatedExcuse = 'Failed to generate excuse.';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141A1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141A1F),
        elevation: 0,
        title: const Text(
          'Escusely',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Get Out Gracefully',
              style: TextStyle(color: Color(0xFF9DAEBE), fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Dropdown
            _buildDropdown(),

            const SizedBox(height: 16),

            // Description box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F272E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF3D4D5C)),
              ),
              child: TextField(
                controller: _descController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Describe your situation...",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: (val) {
                  description = val;
                },
              ),
            ),

            const SizedBox(height: 24),

            _buildSliderRow('Urgency', 'High', urgencyValue, (val) {
              setState(() => urgencyValue = val);
            }),
            _buildSliderRow('Believability', 'Serious', believabilityValue,
                (val) {
              setState(() => believabilityValue = val);
            }),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDCE8F3),
                foregroundColor: const Color(0xFF141A1F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () async {
                if (selectedContext == 'Select' || description.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please select context and enter description")));
                  return;
                }
                await generateExcuse();
              },
              child: const Text(
                'Generate Excuse',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Text(
                  generatedExcuse.isEmpty
                      ? 'Your generated excuse will appear here.'
                      : generatedExcuse,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F272E),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.image_outlined), label: 'Proofs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F272E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3D4D5C)),
      ),
      child: DropdownButton<String>(
        dropdownColor: const Color(0xFF1F272E),
        value: selectedContext,
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        items: ['Select', 'Work', 'School', 'Social', 'Family']
            .map((String value) => DropdownMenuItem<String>(
                  value: value,
                  child:
                      Text(value, style: const TextStyle(color: Colors.white)),
                ))
            .toList(),
        onChanged: (String? newValue) {
          setState(() => selectedContext = newValue!);
        },
      ),
    );
  }

  Widget _buildSliderRow(
      String label, String endText, double value, ValueChanged<double> onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(endText,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: 0,
          max: 1,
          activeColor: const Color(0xFFDCE8F3),
          inactiveColor: const Color(0xFF3D4D5C),
        ),
      ],
    );
  }
}
