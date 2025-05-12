import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/fire_alert.dart';
import '../widgets/alert_card.dart';
import '../widgets/filter.dart';

enum SortOrder { newestFirst, oldestFirst }

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final List<FireAlert> _alerts = [];
  String _lastMessage = "";
  AlertFilterType _selectedFilter = AlertFilterType.all;
  SortOrder _sortOrder = SortOrder.newestFirst;

  // Lắng nghe thông báo từ /api/alerts
  void _startForAlerts() async {
    final Uri url = Uri.parse('http://192.168.1.50:5000/api/alerts');  // Đảm bảo IP chính xác
    final client = http.Client();
    final request = client.send(http.Request('GET', url));

    request.then((response) { 
      response.stream.listen((data) {
        String message = json.decode(utf8.decode(data))['message'];

        // Kiểm tra nếu thông báo khác thông báo trước
        if (message != _lastMessage) {
          setState(() {
            _lastMessage = message;
            _alerts.add(
              FireAlert(message: message)
            );
          });
        }
      });
    }).catchError((e) {
      // ignore: avoid_print
      print("Error connecting to SSE: $e");
    });
  }

  @override
  void initState() {
    super.initState();
    _startForAlerts();  // Lắng nghe các thông báo mới
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlerts = getFilteredAlerts(_alerts, _selectedFilter);

    // Sắp xếp theo thứ tự mới nhất/cũ nhất
    filteredAlerts.sort((a, b) =>
      _sortOrder == SortOrder.newestFirst
          ? b.timestamp.compareTo(a.timestamp)
          : a.timestamp.compareTo(b.timestamp)
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách cảnh báo'),
      ),
      body: _alerts.isEmpty
          ? const Center(child: Text("Không có cảnh báo nào."))
          : Column(
              children: [
                // Dropdown chọn bộ lọc
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Text("Lọc theo: ", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButton<AlertFilterType>(
                          isExpanded: true,
                          value: _selectedFilter,
                          items: filterOptions.entries.map((entry) {
                            return DropdownMenuItem<AlertFilterType>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedFilter = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Dropdown chọn sắp xếp theo Mới nhất / Cũ nhất
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      const Text("Sắp xếp: ", style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      DropdownButton<SortOrder>(
                        value: _sortOrder,
                        items: const [
                          DropdownMenuItem(
                            value: SortOrder.newestFirst,
                            child: Text("Mới nhất"),
                          ),
                          DropdownMenuItem(
                            value: SortOrder.oldestFirst,
                            child: Text("Cũ nhất"),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _sortOrder = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Danh sách cảnh báo
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredAlerts.length,
                    itemBuilder: (context, index) {
                      return AlertCard(alert: filteredAlerts[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
