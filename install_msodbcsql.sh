# #!/bin/bash
# # Agrega el repositorio de Microsoft
# curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
# # Actualiza e instala
# apt-get update
# ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev
