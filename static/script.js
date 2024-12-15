document.getElementById("rifaForm").addEventListener("submit", async function (e) {
    e.preventDefault();
  
    const identificacion = document.getElementById("identificacion").value;
    const email = document.getElementById("email").value;
  
    const resultDiv = document.getElementById("result");
    resultDiv.innerHTML = "Buscando...";
  
    try {
      const response = await fetch("/consulta-rifa", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          identificacion,
          email,
        }),
      });
  
      if (!response.ok) {
        throw new Error("Error en la consulta");
      }
  
      const data = await response.json();
  
      if (data.numeros && data.numeros.length > 0) {
        const numerosList = data.numeros.map((numero) => `<li>${numero}</li>`).join("");
        resultDiv.innerHTML = `<h3>Números de Rifa:</h3><ul>${numerosList}</ul>`;
      } else {
        resultDiv.innerHTML = "No se encontraron números de rifa para este cliente.";
      }
    } catch (error) {
      resultDiv.innerHTML = "Ocurrió un error: " + error.message;
    }
  });
  