from flask import Flask, request, jsonify, render_template
import pyodbc
import os

app = Flask(__name__, static_folder='static')

# Configuración de la base de datos (debería estar en variables de entorno para mayor seguridad)
db_config = {
    'driver': 'ODBC Driver 17 for SQL Server',
    'server': 'stecno.dyndns.org',
    'database': 'kbrifas',
    'username': 'sa',
    'password': 'Sintesis2018*'
}

@app.route('/prueba-conexion', methods=['GET'])
def prueba_conexion():
    try:
        conn = pyodbc.connect(
            f"DRIVER={db_config['driver']};"
            f"SERVER={db_config['server']};"
            f"DATABASE={db_config['database']};"
            f"UID={db_config['username']};"
            f"PWD={db_config['password']}"
        )
        conn.close()
        return jsonify({"mensaje": "Conexión exitosa"})
    except Exception as e:
        return jsonify({"error": f"Error de conexión: {str(e)}"}), 500
