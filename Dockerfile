# Usa una imagen oficial de Python
FROM python:3.10-slim

# Instala las dependencias necesarias para ODBC
RUN apt-get update && apt-get install -y \
    unixodbc-dev \
    curl && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de tu aplicación
COPY . .

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponer el puerto 5000 para Flask
EXPOSE 5000

# Comando para ejecutar la aplicación
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
