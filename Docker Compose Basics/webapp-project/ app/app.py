from flask import Flask, render_template_string
import mysql.connector
import os
import time

app = Flask(__name__)

def get_db_connection():
    max_retries = 5
    retry_count = 0
    
    while retry_count < max_retries:
        try:
            connection = mysql.connector.connect(
                host=os.environ.get('DB_HOST', 'db'),
                user=os.environ.get('DB_USER', 'webapp'),
                password=os.environ.get('DB_PASSWORD', 'webapp123'),
                database=os.environ.get('DB_NAME', 'webapp_db')
            )
            return connection
        except mysql.connector.Error as err:
            retry_count += 1
            print(f"Database connection attempt {retry_count} failed: {err}")
            if retry_count < max_retries:
                time.sleep(5)
            else:
                raise

@app.route('/')
def home():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) FROM visits")
        visit_count = cursor.fetchone()[0]
        
        cursor.execute("INSERT INTO visits (timestamp) VALUES (NOW())")
        conn.commit()
        
        cursor.close()
        conn.close()
        
        return render_template_string('''
        <html>
            <head><title>Docker Compose Web App</title></head>
            <body>
                <h1>Welcome to Docker Compose Lab!</h1>
                <p>This page has been visited {{ count }} times.</p>
                <p>Application is running in a Docker container managed by Docker Compose.</p>
            </body>
        </html>
        ''', count=visit_count + 1)
    except Exception as e:
        return f"Database connection error: {str(e)}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
