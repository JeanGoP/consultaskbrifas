document.getElementById('consultaForm').addEventListener('submit', async (event) => {
    event.preventDefault(); // Evitar que el formulario recargue la página

    const parametro1 = document.getElementById('parametro1').value;
    const parametro2 = document.getElementById('parametro2').value;

    try {
        const response = await fetch('/consulta', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ parametro1, parametro2 }),
        });

        if (response.ok) {
            const data = await response.json();
            mostrarResultados(data);
        } else {
            alert('Error en la consulta.');
        }
    } catch (error) {
        console.error('Error:', error);
    }
});

function mostrarResultados(data) {
    const resultadosDiv = document.getElementById('resultados');
    resultadosDiv.innerHTML = '';

    if (data.length === 0) {
        resultadosDiv.textContent = 'No se encontraron resultados.';
        return;
    }

    // Mostrar resultados separados por comas
    const numeros = data.map((row) => row.numero).join(', ');
    resultadosDiv.textContent = `Números para el sorteo: ${numeros}`;
}
