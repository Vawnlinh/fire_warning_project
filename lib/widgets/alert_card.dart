import 'package:flutter/material.dart';
import '../models/fire_alert.dart';

class AlertCard extends StatelessWidget {
  final FireAlert alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 3,
      color: alert.isHandled ? Colors.grey[300] : Colors.white,
      child: ExpansionTile(
        leading: Icon(
          alert.isHandled ? Icons.check_circle : Icons.warning,
          color: alert.isHandled ? Colors.green : Colors.red,
        ),
        title: Text(
          alert.message.replaceAll(r'\n', '\n'),  // Đảm bảo giữ ký tự xuống dòng đúng
          softWrap: true,
          style: TextStyle(
            color: alert.isHandled ? Colors.grey : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Chỉ hiển thị khi có thông tin hình ảnh và trạng thái xử lý
        children: [
          if (alert.imageUrl != null) 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(alert.imageUrl!), // Hiển thị hình ảnh nếu có
            ),
          // Trạng thái đã xử lý và thời gian xử lý
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              alert.isHandled
                  ? '✅ Đã xử lý lúc: ${alert.handledTime?.toLocal().toString().substring(0, 19)}'
                  : '⚠️ Chưa xử lý',
              style: TextStyle(
                color: alert.isHandled ? Colors.green : Colors.red,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Nút để đánh dấu là đã xử lý
          if (!alert.isHandled)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Đánh dấu đã xử lý'),
                onPressed: () {
                  alert.isHandled = true;
                  alert.handledTime = DateTime.now();
                },
              ),
            ),
        ],
      ),
    );
  }
}
