import sys
import os

# Ruta al archivo app.py
project_home = os.path.dirname(os.path.abspath(__file__))
if project_home not in sys.path:
    sys.path.append(project_home)

from app import app as application  # Asegúrate de que el nombre coincide con el archivo Flask
