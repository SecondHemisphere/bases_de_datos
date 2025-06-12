// ====================================================
// ==== Ejercicio 1: Variables y tipos de datos =======
// ====================================================

// Se declaran las variables para mi nombre, edad y si estoy inscrito
const nombre = "Derek"; // Mi nombre
const edad = 20; // Mi edad
const estaInscrito = true; // ¿Estoy inscrito?

// Se muestran los valores en la consola
console.log(nombre); // Mi nombre
console.log(edad); // Mi edad
console.log(estaInscrito); // ¿Estoy inscrito?

// ================================================
// ==== Ejercicio 2: Operadores matemáticos =======
// ================================================

// Se declaran dos variables numéricas
let numero1 = 15; // Primer número
let numero2 = 3; // Segundo número

// Se declaran cinco variables para almacenar los resultados de las distintas operaciones matemáticas
let suma = numero1 + numero2; // Suma
let resta = numero1 - numero2; // Resta
let multiplicacion = numero1 * numero2; // Multiplicación
let division = numero1 / numero2; // División
let residuo = numero1 % numero2; // Residuo

// Se muestran los resultados en la consola
console.log(`${numero1} + ${numero2} = ${suma}`); // Suma
console.log(`${numero1} - ${numero2} = ${resta}`); // Resta
console.log(`${numero1} * ${numero2} = ${multiplicacion}`); // Multiplicación
console.log(`${numero1} / ${numero2} = ${division}`); // División
console.log(`${numero1} % ${numero2} = ${residuo}`); // Residuo

// ===================================================
// ==== Ejercicio 3: Operadores de comparación =======
// ===================================================

// Se declaran dos variables numéricas
const numero3 = 10; // Primer número
const numero4 = 5; // Segundo número

// Se compara si los números son iguales en valor y tipo
const sonIguales = numero3 === numero4;

// Se compara si el primer número es mayor
const primeroMayor = numero3 > numero4;

// Se compara si el segundo número es mayor
const segundoMayor = numero4 > numero3;

// Se compara si los números son distintos
const sonDistintos = numero3 !== numero4;

// Se muestra si los números son iguales en valor y tipo en la consola
console.log(`¿Son iguales? = ${sonIguales}`);

// Se muestra si el primer número es mayor en la consola
console.log(
  `¿El primer número (${numero3}) es mayor que el segundo (${numero4})? = ${primeroMayor}`
);

// Se muestra si el segundo número es mayor en la consola
console.log(
  `¿El segundo número (${numero4}) es mayor que el primero (${numero3})? = ${segundoMayor}`
);

// Se muestra si los números son distintos en la consola
console.log(`¿Son distintos? = ${sonDistintos}`);

// =======================================
// ==== Ejercicio 4: Condicionales =======
// =======================================

// Se declara una función para determinar si un número es positivo, negativo o cero
function evaluarNumero(numero) {
  if (numero > 0) {
    // Si el número es mayor que cero, se retorna un mensaje indicando que es positivo
    return "El número es positivo.";
  } else if (numero < 0) {
    // Si el número es menor que cero, se retorna un mensaje indicando que es negativo
    return "El número es negativo.";
  } else {
    // Si el número es igual a cero, se retorna un mensaje indicando que es cero
    return "El número es cero.";
  }
}

// Se muestra que el número es positivo en la consola
console.log(evaluarNumero(34));

// Se muestra que el número es negativo en la consola
console.log(evaluarNumero(-23));

// Se muestra que el número es cero en la consola
console.log(evaluarNumero(0));

// ================================
// ==== Ejercicio 5: Funciones ====
// ================================

// Se declara una función para calcular el promedio de dos números
function promediar(numero1, numero2) {
  return (numero1 + numero2) / 2;
}

// Se almacena el promedio entre 20 y 23 en una variable
let promedio = promediar(20, 23);

// Se muestra que el promedio de los dos números por consola
console.log(promedio);

// ================================
// ==== Ejercicio 6: Arrays =======
// ================================

// Se crea un arreglo con 5 nombres de frutas
const frutas = ["Pera", "Manzana", "Toronja", "Coco", "Cereza"];

// Se muestra el arrreglo completo por consola
console.log(frutas);

// Se muestra solo el primer elemento del arreglo por consola
console.log(`El primer elemento del arreglo de frutas es: ${frutas[0]}`);

// Se muestra el último elemento del arreglo por consola
console.log(
  `El último elemento del arreglo de frutas es: ${frutas[frutas.length - 1]}`
);

// ==========================================
// ==== Ejercicio 7: Métodos de array =======
// ==========================================

// Uso del método "push", este método agrega un elemento al final del arreglo
frutas.push("Papaya");

// Impresión del arreglo completo
console.log(frutas);

// Uso del método "pop", este método elimina el último elemento del arreglo
frutas.pop();

// Impresión del arreglo completo
console.log(frutas);

// Uso del método "map", este método recorre un arreglo y crea uno nuevo donde cada elemento es el resultado de aplicar una transformación a los elementos originales.
const frutasMayus = frutas.map(function (fruta) {
  return fruta.toUpperCase();
});

// Impresión del arreglo completo que contiene los nombres
console.log(frutasMayus);

// Uso del método "filter", este método filtra un arreglo y crea uno nuevo donde los elementos cumplen la condición que se indique
const frutasLargas = frutas.filter(function (fruta) {
  return fruta.length > 5;
});
console.log(resultado);

// Impresión del arreglo de frutas que contienen un nombre que supera las 5 letras
console.log(frutasLargas);

// =================================
// ==== Ejercicio 8: Objetos =======
// =================================

// Se crea un objeto llamado "estudiante"
const estudiante = {
  nombreEstudiante: "Florencia", // Nombre del estudiante
  edadEstudiante: 21, // Edad del estudiante
  carreraEstudiante: "Psicología", // Carrera que cursa
  semestreEstudiante: "Quinto", // Semestre actual
};

// Se muestra el objeto completo en la consola
console.log(estudiante);

// Se accede y muestra cada propiedad individual del objeto
console.log(estudiante.nombreEstudiante); // Nombre del estudiante
console.log(estudiante.edadEstudiante); // Edad del estudiante
console.log(estudiante.carreraEstudiante); // Carrera que cursa
console.log(estudiante.semestreEstudiante); // Semestre actual

// ============================================
// ==== Ejercicio 9: Métodos de objetos =======
// ============================================

// Agrega una función dentro del objeto estudiante que imprima un saludo con su nombre y carrera.

// ========================================
// ==== Ejercicio 10: Destructuring =======
// ========================================

// Se usa destructuring para extraer nombre y carrera del objeto "estudiante"
const { nombreEstudiante, carreraEstudiante } = estudiante;

// Se muestran los valores en la consola
console.log(nombreEstudiante); // Nombre del estudiante
console.log(carreraEstudiante); // Carrera que cursa

// ==========================================
// ==== Ejercicio 11: Spread Operator =======
// ==========================================

// Se definen dos arreglos con números
const numerosImpares = [1, 3, 5, 7, 9];
const numerosPares = [2, 4, 6, 8];

// Se combinan ambos arreglos usando el spread operator
const numeros = [...numerosImpares, ...numerosPares];

// Se muestra el arreglo resultante en la consola
console.log(numeros);

// ================================================
// ==== Ejercicio 12: Métodos Math y String =======
// ================================================

// Se genera un número entero aleatorio entre 1 y 100:
// - Math.random() genera un decimal entre 0 y 1 (no incluye el 1)
// - Se multiplica por 100 para llevarlo al rango 0–99.999...
// - Math.floor() redondea hacia abajo al entero más cercano (0–99)
// - Se suma 1 para obtener un valor entre 1 y 100
const numeroAleatorio = Math.floor(Math.random() * 100) + 1;

// Se muestra el número aleatorio generado en la consola
console.log(numeroAleatorio);

// Se crea una cadena de texto
const texto = "software";

// Se convierte toda la cadena a mayúsculas
const textoMayusculas = texto.toUpperCase(); // "SOFTWARE"

// Se extrae una porción de la cadena (desde el índice 0 hasta el 4, sin incluir el 4)
const textoCortado = textoMayusculas.slice(0, 4); // "SOFT"

// Se muestran los resultados
console.log(textoMayusculas); // SOFTWARE
console.log(textoCortado); // SOFT
