import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 4;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    // Navigation logic
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
        Navigator.pushReplacementNamed(context, '/proofs');
        break;
      case 4:
        // Already on settings
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
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionTitle('Account'),
          _buildSettingTile(Icons.account_circle_outlined, 'Account', 'Manage your account'),
          
          _buildSectionTitle('Preferences'),
          _buildSettingTile(Icons.settings_outlined, 'Preferences', 'Customize your experience'),

          _buildSectionTitle('Support'),
          _buildSettingTile(Icons.help_outline, 'Help', 'Get help and support'),
          _buildSettingTile(Icons.mail_outline, 'Contact Us', 'Contact us for assistance'),

          _buildSectionTitle('App'),
          _buildSettingTile(Icons.star_border, 'Rate App', 'Rate us on the app store'),
          _buildSettingTile(Icons.share_outlined, 'Share App', 'Share the app with friends'),
          _buildSettingTile(Icons.article_outlined, 'Terms of Service', 'View our terms of service'),
          _buildSettingTile(Icons.privacy_tip_outlined, 'Privacy Policy', 'Read our privacy policy'),
        ],
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2C3A48),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          )),
      subtitle: Text(subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
          )),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
      onTap: () {
        // Navigation logic for each setting can be added here
      },
    );
  }
}
