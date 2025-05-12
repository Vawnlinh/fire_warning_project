from flask import Flask, jsonify, Response
import psycopg2
from datetime import datetime
import time
import random
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Cho phép CORS để frontend có thể gọi API

# Cấu hình kết nối PostgreSQL
def get_db_connection():
    conn = psycopg2.connect(
        dbname="fire_warning",
        user="huy2004",  # Thay bằng username của bạn
        password="123456",  # Thay bằng password của bạn
        host="localhost",
        port="5432"
    )
    return conn

# Lớp để lưu trữ thông tin đồ vật và thời gian cảnh báo cuối cùng
class HouseholdItem:
    def __init__(self, area, name, current_temp, safe_threshold):
        self.area = area
        self.name = name
        self.current_temp = current_temp
        self.safe_threshold = safe_threshold
        self.last_alert_time = 0

# API cung cấp dữ liệu cho trang web
@app.route('/api/data', methods=['GET'])
def get_data():
    conn = get_db_connection()
    c = conn.cursor()
    c.execute("SELECT * FROM data ORDER BY timestamp DESC LIMIT 50")
    rows = c.fetchall()
    conn.close()

    data = [{"area": row[1], "name": row[2], "temperature": row[3], "safe_threshold": row[4], "timestamp": row[5]} for row in rows]
    return jsonify(data)

# API Server-Sent Events để gửi thông báo thời gian thực
@app.route('/api/alerts')
def alerts():
    def generate():
        while True:
            # Lấy dữ liệu mới nhất từ PostgreSQL
            conn = get_db_connection()
            c = conn.cursor()
            c.execute("""
                SELECT DISTINCT ON (area, name) area, name, temperature, safe_threshold, timestamp
                FROM data
                ORDER BY area, name, timestamp DESC
            """)
            rows = c.fetchall()
            conn.close()

            # Kiểm tra từng đồ vật
            for row in rows:
                item = HouseholdItem(row[0], row[1], row[2], row[3])
                current_time = time.time()
                if item.current_temp > item.safe_threshold:
                    if current_time - item.last_alert_time >= 60:
                        current_datetime = datetime.now()
                        formatted_date = current_datetime.strftime("%d/%m/%Y %H:%M:%S")
                        message = (
                            f"🔥 CẢNH BÁO HỎA HOẠN\n"
                            f"📍 [{item.area}] - {item.name}\n"
                            f"🌡️ Nhiệt độ: {item.current_temp:.1f}°C (Ngưỡng an toàn: {item.safe_threshold}°C)\n"
                            f"⏰ Thời gian: {formatted_date}"
                        )
                        # Gửi thông báo qua SSE
                        yield f"data: {message}\n\n"
                        item.last_alert_time = current_time

            # Đợi 5 giây trước khi kiểm tra lại
            time.sleep(5)

    return Response(generate(), mimetype='text/event-stream')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)