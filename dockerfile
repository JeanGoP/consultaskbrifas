# Imagen base de Ubuntu
FROM ubuntu:20.04

# Configuración para evitar preguntas interactivas
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    curl gnupg apt-transport-https \
    unixodbc-dev libssl1.1 \
    python3 python3-pip python3-dev \
    gcc g++ make

# Agrega el repositorio de Microsoft para ODBC Driver 17
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17

# Configura el entorno de Python y las dependencias
WORKDIR /app
COPY . /app

# Instala las dependencias de Python
RUN pip3 install --no-cache-dir -r requirements.txt

# Expone el puerto para Flask
EXPOSE 5000

# Comando para iniciar la aplicación Flask
CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app"]
