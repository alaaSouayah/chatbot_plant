import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  double _fontSize = 16.0;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Animated App Bar
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade500,
                      Colors.green.shade300,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Settings Content
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Account'),
                  _buildProfileCard(),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Preferences'),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        title: 'Dark Mode',
                        subtitle: 'Toggle dark theme',
                        leading: Icon(
                          _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          color: Colors.green.shade700,
                        ),
                        trailing: Switch(
                          value: _isDarkMode,
                          onChanged: (value) {
                            setState(() => _isDarkMode = value);
                            Get.snackbar(
                              'Theme Changed',
                              'App theme has been updated',
                              backgroundColor: Colors.green.shade100,
                              colorText: Colors.green.shade900,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          activeColor: Colors.green.shade700,
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        title: 'Notifications',
                        subtitle: 'Enable push notifications',
                        leading: Icon(
                          Icons.notifications_active,
                          color: Colors.green.shade700,
                        ),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                          },
                          activeColor: Colors.green.shade700,
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        title: 'Location Services',
                        subtitle: 'Enable location access',
                        leading: Icon(
                          Icons.location_on,
                          color: Colors.green.shade700,
                        ),
                        trailing: Switch(
                          value: _locationEnabled,
                          onChanged: (value) {
                            setState(() => _locationEnabled = value);
                          },
                          activeColor: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('Appearance'),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        title: 'Font Size',
                        subtitle: 'Adjust text size',
                        leading: Icon(
                          Icons.text_fields,
                          color: Colors.green.shade700,
                        ),
                        trailing: Slider(
                          value: _fontSize,
                          min: 12.0,
                          max: 24.0,
                          divisions: 4,
                          label: _fontSize.round().toString(),
                          onChanged: (value) {
                            setState(() => _fontSize = value);
                          },
                          activeColor: Colors.green.shade700,
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        title: 'Language',
                        subtitle: 'Choose your preferred language',
                        leading: Icon(
                          Icons.language,
                          color: Colors.green.shade700,
                        ),
                        trailing: DropdownButton<String>(
                          value: _selectedLanguage,
                          items: ['English', 'French', 'Spanish', 'Arabic']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() => _selectedLanguage = newValue!);
                          },
                          underline: Container(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle('About'),
                  _buildSettingsCard(
                    children: [
                      _buildSettingsTile(
                        title: 'Version',
                        subtitle: '1.0.0',
                        leading: Icon(
                          Icons.info_outline,
                          color: Colors.green.shade700,
                        ),
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        title: 'Terms of Service',
                        subtitle: 'Read our terms and conditions',
                        leading: Icon(
                          Icons.description,
                          color: Colors.green.shade700,
                        ),
                        onTap: () {
                          // Navigate to Terms of Service
                        },
                      ),
                      _buildDivider(),
                      _buildSettingsTile(
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        leading: Icon(
                          Icons.privacy_tip,
                          color: Colors.green.shade700,
                        ),
                        onTap: () {
                          // Navigate to Privacy Policy
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade900,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.green.shade100,
              child: Icon(
                Icons.person,
                size: 35,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.green.shade700,
              ),
              onPressed: () {
                // Edit profile action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    String? subtitle,
    required Icon leading,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
      indent: 70,
      endIndent: 20,
    );
  }
}



