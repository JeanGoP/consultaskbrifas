const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000; // Heroku asigna dinámicamente el puerto

// Configuración de middlewares
app.use(cors());
app.use(bodyParser.json());
app.use(express.static('public'));

// Configuración de conexión a SQL Server
const dbConfig = {
    user: 'sa', // Usuario de SQL Server
    password: 'Sintesis2018*', // Contraseña de SQL Server
    server: 'stecno.dyndns.org', // Nombre del servidor (localhost o dirección IP)
    database: 'kbrifas', // Nombre de la base de datos
    options: {
        encrypt: true, // Cambiar según el entorno (falso si es local)
        trustServerCertificate: true, // Útil para entornos locales
    },
};

// Endpoint para realizar la consulta
app.post('/consulta', async (req, res) => {
    const { parametro1, parametro2 } = req.body; // `parametro1` y `parametro2` vienen del frontend

    try {
        // Conexión a la base de datos
        const pool = await sql.connect(dbConfig);

        // Ejecutar consulta parametrizada
        const result = await pool.request()
            .input('parametro1', sql.VarChar, parametro1) // Asegúrate de usar el tipo de dato correcto
            .input('parametro2', sql.VarChar, parametro2)
            .query(`
                SELECT numero
                FROM NumerosRifa n
                INNER JOIN Cargos c ON n.id_transaction = c.id_transaction
                WHERE c.number = @parametro1 AND c.ClienteEmail = @parametro2
            `);

        // Enviar los resultados al cliente
        res.json(result.recordset);
    } catch (err) {
        console.error('Error en la consulta:', err);
        res.status(500).send('Error al realizar la consulta.');
    } finally {
        sql.close(); // Cierra la conexión después de usarla
    }
});

// Endpoint raíz para verificar que el servidor está funcionando
app.get('/', (req, res) => {
    res.send('La aplicación está funcionando correctamente en Heroku');
});

// Iniciar el servidor
app.listen(port, () => {
    console.log(`Servidor ejecutándose en el puerto ${port}`);
});
