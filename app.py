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

def get_db_connection():
    try:
        conn = pyodbc.connect(
            f"DRIVER={db_config['driver']};"
            f"SERVER={db_config['server']};"
            f"DATABASE={db_config['database']};"
            f"USERNAME={db_config['username']};"
            f"PASSWORD={db_config['password']}"
        )
        return conn
    except pyodbc.Error as e:
        raise Exception(f"Error al conectar con la base de datos: {str(e)}")


# Ruta para servir el archivo HTML principal
@app.route('/')
def index():
    return render_template('index.html')

# Ruta para la consulta de rifa
@app.route('/consulta-rifa', methods=['POST'])
def consulta_rifa():
    data = request.json
    identificacion = data.get('identificacion')
    email = data.get('email')

    if not identificacion or not email:
        return jsonify({"error": "Identificación y correo electrónico son requeridos"}), 400

    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                SELECT TOP 100 numero
                FROM NumerosRifa n
                INNER JOIN Cargos c ON n.id_transaction = c.id_transaction
                WHERE c.number = ? AND c.ClienteEmail = ?
                """
                print(f"Executing query with params: {identificacion}, {email}")
                cursor.execute(query, (identificacion, email))
                numeros = [row[0] for row in cursor.fetchall()]

        if not numeros:
            return jsonify({"mensaje": "No se encontraron números de rifa para la identificación proporcionada"}), 404

        return jsonify({"numeros": numeros})
    except Exception as e:
        print(f"Database error: {str(e)}")
        return jsonify({"error": f"Ha ocurrido un error: {str(e)}"}), 500


if __name__ == '__main__':
    app.run(debug=True)
