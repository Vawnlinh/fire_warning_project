import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  // ignore: use_super_parameters
  const SettingsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Danh sách các cài đặt
  List<Map<String, dynamic>> settings = [
    {
      'title': 'Ngôn ngữ',
      'activeIcon': Icons.language,
      'inactiveIcon': Icons.g_translate,
      'isActive': false,
    },
    {
      'title': 'Âm thanh',
      'activeIcon': Icons.volume_up,
      'inactiveIcon': Icons.volume_off,
      'isActive': true,
    },
    {
      'title': 'Thông báo',
      'activeIcon': Icons.notifications_active,
      'inactiveIcon': Icons.notifications_off,
      'isActive': true,
    },
    {
      'title': 'Kết nối',
      'activeIcon': Icons.wifi,
      'inactiveIcon': Icons.wifi_off,
      'isActive': true,
    },
    {
      'title': 'Giao diện',
      'activeIcon': Icons.dark_mode,
      'inactiveIcon': Icons.light_mode,
      'isActive': false,
    },
    {
      'title': 'Bảo mật',
      'activeIcon': Icons.lock,
      'inactiveIcon': Icons.lock_open,
      'isActive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt hệ thống'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: settings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 ô mỗi hàng
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final setting = settings[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  setting['isActive'] = !setting['isActive'];
                });
              },
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: setting['isActive'] ? Colors.green[100] : Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      setting['isActive']
                          ? setting['activeIcon']
                          : setting['inactiveIcon'],
                      size: 36,
                      color: setting['isActive'] ? Colors.green : Colors.grey[700],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      setting['title'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
