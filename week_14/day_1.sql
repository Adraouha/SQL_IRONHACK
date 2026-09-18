-- =============================================================================
-- IRONHACK - DATA ANALYTICS / WEB DEV - BOOTCAMP
-- SEMANA 14 - DÍA 1: Fundamentos de SQL (DDL, DML, DQL)
-- Herramientas recomendadas: MySQL, DBeaver / phpMyAdmin / Paiza.io
-- =============================================================================

-- =============================================================================
-- PARTE 1: CREAR BD Y TABLA LIBRE + CONSULTAS BÁSICAS
-- Tema elegido: Tienda de Tecnología y Gadgets (productos)
-- Requisitos:
--   - Al menos 1 id autoincrementable
--   - Un dato VARCHAR
--   - Un dato numérico (DECIMAL / INT)
--   - Una fecha (DATE)
--   - Al menos 5 registros
--   - Consultas: SELECT, WHERE, ORDER BY, DESC, >, <, =, LIKE con % y _
-- =============================================================================

-- 1.1 Creación de la base de datos
CREATE DATABASE IF NOT EXISTS tienda_tecnologia
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE tienda_tecnologia;

-- 1.2 Creación de la tabla de productos
DROP TABLE IF EXISTS productos;

CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    fecha_lanzamiento DATE NOT NULL
);

-- 1.3 Inserción de al menos 5 registros (insertamos 7 para mayor variedad)
INSERT INTO productos (nombre, precio, stock, fecha_lanzamiento) VALUES
('Smartphone Galaxy Pro', 899.99, 25, '2023-03-15'),
('Monitor UltraWide 34', 450.50, 12, '2022-11-20'),
('Teclado Mecánico RGB', 89.90, 50, '2021-06-10'),
('Mouse Gamer Óptico', 45.00, 70, '2021-08-05'),
('Smartwatch Fit Active', 199.95, 30, '2024-01-18'),
('Memoria RAM 32GB DDR5', 120.00, 40, '2023-09-01'),
('Cámara Web 4K Stream', 115.00, 18, '2022-04-12');

-- -----------------------------------------------------------------------------
-- CONSULTAS DE LA PARTE 1:
-- -----------------------------------------------------------------------------

-- 1. Ver todos los registros y todas las columnas
SELECT * FROM productos;

-- 2. ¿Cómo muestras una columna específica? (o varias)
SELECT nombre, precio FROM productos;

-- 3. ¿Cómo seleccionas los datos de un id dado? (Operador =)
SELECT * FROM productos 
WHERE id = 3;

-- 4. Filtrar por condición numérica con > (productos con precio mayor a 100)
SELECT nombre, precio, stock 
FROM productos 
WHERE precio > 100.00;

-- 5. Filtrar por condición numérica con < (productos con precio menor a 100)
SELECT nombre, precio, stock 
FROM productos 
WHERE precio < 100.00;

-- 6. Filtrar por fecha (productos lanzados a partir del año 2023)
SELECT nombre, fecha_lanzamiento 
FROM productos 
WHERE fecha_lanzamiento >= '2023-01-01';

-- 7. ¿Cómo ordenas el resultado según su valor numérico? (ORDER BY y DESC / ASC)
-- Orden ascendente (menor a mayor precio):
SELECT nombre, precio 
FROM productos 
ORDER BY precio ASC;

-- Orden descendente (mayor a menor precio):
SELECT nombre, precio 
FROM productos 
ORDER BY precio DESC;

-- 8. ¿Cómo usas LIKE con % y _ para encontrar un elemento determinado?
-- Explicación:
-- '%' representa CERO, UNO o MUCHOS caracteres.
-- '_' representa EXACTAMENTE UN carácter.

-- 8.a. ¿Cómo encuentras algún elemento que contenga la letra 'm' (o 'M')?
-- Nota: En MySQL por defecto LIKE es insensible a mayúsculas/minúsculas (case-insensitive) con collations utf8mb4_unicode_ci.
SELECT * FROM productos 
WHERE nombre LIKE '%m%';

-- 8.b. Elementos que EMPIEZAN por 'Smart':
SELECT * FROM productos 
WHERE nombre LIKE 'Smart%';

-- 8.c. Elementos que TERMINAN en 'RGB':
SELECT * FROM productos 
WHERE nombre LIKE '%RGB';

-- 8.d. Uso del comodín '_' (guión bajo):
-- Busca nombres donde la segunda letra sea 'e' (ej: Teclado, Memoria...)
SELECT * FROM productos 
WHERE nombre LIKE '_e%';


-- =============================================================================
-- PARTE 2: PELÍCULAS: CREATE + READ
-- Requisitos:
--   - Tabla con al menos 10 películas
--   - Campos: id autoincrementable, titulo, protagonista, anio, genero, recaudacion
--   - Consultas especificadas con renombrado de columnas (AS)
-- =============================================================================

-- 2.1 Creación de la base de datos para cine (o usando la actual)
CREATE DATABASE IF NOT EXISTS cine_club
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE cine_club;

DROP TABLE IF EXISTS peliculas;

-- 2.2 Creación de la tabla peliculas
CREATE TABLE peliculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    protagonista VARCHAR(100) NOT NULL,
    anio INT NOT NULL,
    genero VARCHAR(50) NOT NULL,
    recaudacion DECIMAL(15, 2) NOT NULL -- Valores en dólares / euros
);

-- 2.3 Inserción de al menos 10 películas
INSERT INTO peliculas (titulo, protagonista, anio, genero, recaudacion) VALUES
('Titanic', 'Leonardo DiCaprio', 1997, 'Drama', 2264743305.00),
('Avatar', 'Sam Worthington', 2009, 'Ciencia Ficción', 2923706026.00),
('El Padrino', 'Marlon Brando', 1972, 'Crimen', 250341816.00),
('Pulp Fiction', 'John Travolta', 1994, 'Crimen', 213928762.00),
('Interstellar', 'Matthew McConaughey', 2014, 'Ciencia Ficción', 773867216.00),
('Inception', 'Leonardo DiCaprio', 2010, 'Ciencia Ficción', 839030630.00),
('Gladiator', 'Russell Crowe', 2000, 'Acción', 465380802.00),
('The Dark Knight', 'Christian Bale', 2008, 'Acción', 1006234167.00),
('Forrest Gump', 'Tom Hanks', 1994, 'Drama', 678226133.00),
('Oppenheimer', 'Cillian Murphy', 2023, 'Biografía', 957000000.00),
('Barbie', 'Margot Robbie', 2023, 'Comedia', 1445638421.00),
('El Rey León', 'Matthew Broderick (voz)', 1994, 'Animación', 968511805.00);

-- -----------------------------------------------------------------------------
-- CONSULTAS DE LA PARTE 2:
-- -----------------------------------------------------------------------------

-- 1. Ver solo titulo y año:
SELECT 
    titulo AS 'Título de la Película',
    anio AS 'Año de Estreno'
FROM peliculas;

-- 2.a. Todas las películas producidas a partir de cierto año (ej: a partir del 2000), en orden ASCENDENTE:
SELECT 
    titulo AS 'Título',
    anio AS 'Año de Estreno',
    protagonista AS 'Protagonista'
FROM peliculas
WHERE anio >= 2000
ORDER BY anio ASC;

-- 2.b. Todas las películas producidas a partir de cierto año, en orden DESCENDENTE:
SELECT 
    titulo AS 'Título',
    anio AS 'Año de Estreno',
    protagonista AS 'Protagonista'
FROM peliculas
WHERE anio >= 2000
ORDER BY anio DESC;

-- 3. Ordenar por título alfabéticamente (A-Z):
SELECT 
    id AS 'ID',
    titulo AS 'Título',
    genero AS 'Género',
    anio AS 'Año'
FROM peliculas
ORDER BY titulo ASC;

-- 4. Agrupar por género con métricas (cantidad y recaudación promedio):
SELECT 
    genero AS 'Género',
    COUNT(*) AS 'Número de Películas',
    ROUND(AVG(recaudacion), 2) AS 'Recaudación Media ($)'
FROM peliculas
GROUP BY genero
ORDER BY COUNT(*) DESC;

-- 5. Ver solo las pelis con recaudación menor que X (ejemplo: menor a 800 millones):
SELECT 
    titulo AS 'Título',
    recaudacion AS 'Recaudación Total ($)',
    genero AS 'Género'
FROM peliculas
WHERE recaudacion < 800000000.00
ORDER BY recaudacion ASC;

-- 6. Ver películas entre un año y otro de producción (ejemplo: entre 1990 y 2005):
SELECT 
    titulo AS 'Título',
    anio AS 'Año de Producción',
    protagonista AS 'Protagonista'
FROM peliculas
WHERE anio BETWEEN 1990 AND 2005
ORDER BY anio ASC;

-- 7. Ver cuántas pelis hay en la lista:
SELECT 
    COUNT(*) AS 'Total de Películas Registradas'
FROM peliculas;

-- 8. Ver la suma de todas las recaudaciones:
SELECT 
    SUM(recaudacion) AS 'Recaudación Total Global ($)'
FROM peliculas;

-- 9. Ver la media de las recaudaciones:
SELECT 
    ROUND(AVG(recaudacion), 2) AS 'Recaudación Promedio ($)'
FROM peliculas;

-- 10. Resumen estadístico completo de la cartelera:
SELECT 
    COUNT(*) AS 'Total Pelis',
    MIN(anio) AS 'Película más Antigua',
    MAX(anio) AS 'Película más Reciente',
    MIN(recaudacion) AS 'Recaudación Mínima',
    MAX(recaudacion) AS 'Recaudación Máxima',
    ROUND(AVG(recaudacion), 2) AS 'Media Recaudación',
    SUM(recaudacion) AS 'Suma Total Recaudación'
FROM peliculas;
