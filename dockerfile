# Usa una imagen base de Python
FROM python:3.11-slim

# Instalar dependencias necesarias para el controlador ODBC
RUN apt-get update && apt-get install -y \
    curl apt-transport-https gnupg2 unixodbc unixodbc-dev libgssapi-krb5-2

# Agregar el repositorio de Microsoft e instalar el controlador ODBC Driver 17
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Limpiar archivos innecesarios
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos de la aplicación
COPY . /app

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto donde correrá la app Flask
EXPOSE 5000

# Ejecutar la aplicación con Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
