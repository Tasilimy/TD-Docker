import os
import time
from flask import Flask, jsonify
import pymysql
import pymysql.cursors

app = Flask(__name__)

# Config via variables d'environnement
API_PORT = int(os.environ.get("API_PORT", 8080))
DB_HOST = os.environ.get("DB_HOST")
DB_USER = os.environ.get("DB_USER")
DB_PASSWORD = os.environ.get("DB_PASSWORD")
DB_NAME = os.environ.get("DB_NAME")

def get_db_connection(max_retries=5):
    """Connexion DB avec retries."""
    for i in range(max_retries):
        try:
            conn = pymysql.connect(
                host=DB_HOST,
                user=DB_USER,
                password=DB_PASSWORD,
                db=DB_NAME,
                charset='utf8mb4',
                cursorclass=pymysql.cursors.DictCursor
            )
            return conn
        except Exception as e:
            if i < max_retries - 1:
                print(f"La DB n'est pas encore prête, nouvelle tentative dans 2s... ({e})")
                time.sleep(2)
            else:
                print(f"Echec connexion DB : {e}")
                return None
    return None

@app.route('/status')
def status():
    """Healthcheck API/DB."""
    conn = get_db_connection(max_retries=1)
    db_status = "KO"
    if conn:
        conn.close()
        db_status = "OK"

    return jsonify({
        "status": "OK",
        "database_connection": db_status,
        "message": "<<< OK >>"
    }), 200

@app.route('/items')
def get_items():
    """Liste des items."""
    conn = get_db_connection()
    if not conn:
        return jsonify({"error": "Base de données indisponible"}), 503

    try:
        with conn.cursor() as cursor:
            sql = "SELECT id, name, description FROM items"
            cursor.execute(sql)
            result = cursor.fetchall()
            return jsonify(result)
    except Exception as e:
        print(f"Erreur SQL : {e}")
        return jsonify({"error": "Erreur interne"}), 500
    finally:
        if conn:
             conn.close()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=API_PORT)