FROM python:3.10-slim

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl apt-transport-https unixodbc unixodbc-dev gnupg2

# Agregar el repositorio de Microsoft para el controlador ODBC
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Limpiar para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurar directorio de trabajo
WORKDIR /app

# Copiar los archivos de la aplicación
COPY . /app

# Instalar dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto
EXPOSE 5000

# Ejecutar la aplicación Flask usando Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
