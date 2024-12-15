# Usa una imagen base compatible con Microsoft SQL Server ODBC
FROM python:3.11-slim

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg \
    unixodbc \
    unixodbc-dev \
    libgssapi-krb5-2 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configura el repositorio de Microsoft para msodbcsql17
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Verifica la instalación del driver
RUN odbcinst -j && ls /usr/lib/x86_64-linux-gnu/ | grep odbc

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos de la aplicación
COPY . /app

# Instala las dependencias de Python
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Expone el puerto para Flask
EXPOSE 5000

# Ejecuta la aplicación Flask con Gunicorn
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
