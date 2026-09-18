-- IRONHACK - DATA ANALYTICS / WEB DEV - BOOTCAMP
-- SEMANA 14 - DÍA 3: Diagramas EER, Forward Engineering y Consultas Avanzadas
-- Base de Datos: libreria
-- Entidades: autor (1) <---> (N) libro (Relación 1 a Muchos, Non-identifying)
-- Herramientas: MySQL Workbench / DBeaver / MySQL 8
-- =============================================================================

-- =============================================================================
-- CONCEPTOS TEÓRICOS: DIAGRAMAS EER & FORWARD ENGINEERING
-- =============================================================================
-- 1. Modelo EER (Enhanced Entity-Relationship):
--    Permite modelar gráficamente las tablas, columnas, tipos de datos y relaciones.
-- 2. Tipo de Relación: 1:n Non-Identifying Relationship
--    - 'autor' es la tabla fuerte/padre (clave primaria: id).
--    - 'libro' es la tabla débil/hija que contiene la clave foránea (id_autor).
--    - Es 'non-identifying' (línea discontinua) porque un libro tiene su propia PK independiente (id).
-- 3. Forward Engineering (Database > Forward Engineer en Workbench):
--    Genera automáticamente el script DDL con las tablas, restricciones (constraints)
--    y claves foráneas, ahorrando la escritura manual de ALTER TABLEs.
-- =============================================================================


-- =============================================================================
-- PARTE 1: CREACIÓN DE LA BASE DE DATOS Y TABLAS (DDL)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS libreria
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE libreria;

-- Eliminar tablas si existen (respetando orden de dependencia: primero hija, luego madre)
DROP TABLE IF EXISTS libro;
DROP TABLE IF EXISTS autor;

-- 1.1 Tabla Madre: autor
-- Campos: id autoincremental, nombre, apellido, pais
CREATE TABLE autor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    pais VARCHAR(50) NOT NULL
);

-- 1.2 Tabla Hija: libro
-- Campos: id autoincremental, titulo, fecha (tipo YEAR: 1901-2155), genero, precio, id_autor
CREATE TABLE libro (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    fecha YEAR NOT NULL,               -- Tipo YEAR nativo de MySQL (soporta 1901 a 2155)
    genero VARCHAR(50) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    id_autor INT NOT NULL,
    CONSTRAINT fk_libro_autor
        FOREIGN KEY (id_autor)
        REFERENCES autor(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);


-- =============================================================================
-- PARTE 2: INSERCIÓN DE DATOS DE PRUEBA (DML)
-- Requisitos: Al menos 6 autores y al menos 10 libros
-- =============================================================================

-- 2.1 Inserción de 6 autores representativos
INSERT INTO autor (nombre, apellido, pais) VALUES
('George', 'Orwell', 'Reino Unido'),            -- id: 1
('J.K.', 'Rowling', 'Reino Unido'),              -- id: 2
('Gabriel', 'García Márquez', 'Colombia'),       -- id: 3
('Stephen', 'King', 'Estados Unidos'),           -- id: 4
('J.R.R.', 'Tolkien', 'Reino Unido'),            -- id: 5
('Isabel', 'Allende', 'Chile');                  -- id: 6

-- 2.2 Inserción de 14 libros que cubren todos los casos de prueba de las queries:
INSERT INTO libro (titulo, fecha, genero, precio, id_autor) VALUES
-- Libros de George Orwell (id_autor: 1)
('1984', 1949, 'Distopía', 15.50, 1),
('Rebelión en la granja', 1945, 'Sátira', 12.00, 1),
('Homenaje a Cataluña', 1938, 'Crónica', 18.00, 1),

-- Libros de J.K. Rowling (id_autor: 2) -> Fantasía, título contiene 'Harry', precios variados
('Harry Potter y la piedra filosofal', 1997, 'Fantasía', 22.50, 2),
('Harry Potter y el prisionero de Azkaban', 1999, 'Fantasía', 24.00, 2),
('Harry Potter y el misterio del príncipe', 2005, 'Fantasía', 26.50, 2),

-- Libros de Gabriel García Márquez (id_autor: 3)
('Cien años de soledad', 1967, 'Realismo Mágico', 19.90, 3),
('El amor en los tiempos del cólera', 1985, 'Romance', 21.00, 3),

-- Libros de Stephen King (id_autor: 4)
('El resplandor', 1977, 'Terror', 16.00, 4),
('It', 1986, 'Terror', 25.00, 4),

-- Libros de J.R.R. Tolkien (id_autor: 5)
('El Hobbit', 1937, 'Fantasía', 14.50, 5),
('El Señor de los Anillos: La Comunidad del Anillo', 1954, 'Fantasía', 28.00, 5),

-- Libros de Isabel Allende (id_autor: 6)
('La casa de los espíritus', 1982, 'Realismo Mágico', 17.50, 6),
('Violeta', 2022, 'Ficción Histórica', 23.00, 6);


-- =============================================================================
-- PARTE 3: RESOLUCIÓN DE QUERIES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- NIVEL: FÁCIL (Filtros, Ordenaciones, LIKE, Rango y JOIN Básico)
-- -----------------------------------------------------------------------------

-- 1. Mostrar todos los libros del género "Fantasía" ordenados por precio de menor a mayor:
SELECT 
    titulo AS 'Título',
    genero AS 'Género',
    precio AS 'Precio (€)'
FROM libro
WHERE genero = 'Fantasía'
ORDER BY precio ASC;

-- 2. Mostrar todos los libros escritos por George Orwell:
-- Opción estándar recomendada con INNER JOIN:
SELECT 
    l.titulo AS 'Título del Libro',
    l.fecha AS 'Año de Publicación',
    l.genero AS 'Género',
    l.precio AS 'Precio (€)',
    CONCAT(a.nombre, ' ', a.apellido) AS 'Autor'
FROM libro l
INNER JOIN autor a ON l.id_autor = a.id
WHERE a.nombre = 'George' AND a.apellido = 'Orwell';

-- 3. Mostrar todos los libros publicados después del año 2000:
SELECT 
    titulo AS 'Título',
    fecha AS 'Año de Publicación',
    precio AS 'Precio (€)'
FROM libro
WHERE fecha > 2000
ORDER BY fecha ASC;

-- 4. Mostrar los libros cuyo precio sea superior a 20 €:
SELECT 
    titulo AS 'Título',
    genero AS 'Género',
    precio AS 'Precio (€)'
FROM libro
WHERE precio > 20.00
ORDER BY precio DESC;

-- 5. Mostrar los libros cuyo título contenga la palabra "Harry":
SELECT 
    id AS 'ID',
    titulo AS 'Título',
    fecha AS 'Año',
    precio AS 'Precio (€)'
FROM libro
WHERE titulo LIKE '%Harry%';

-- 6. Mostrar los libros publicados entre 1980 y 2000:
SELECT 
    titulo AS 'Título',
    fecha AS 'Año de Publicación',
    genero AS 'Género',
    precio AS 'Precio (€)'
FROM libro
WHERE fecha BETWEEN 1980 AND 2000
ORDER BY fecha ASC;

-- 7. Mostrar el título del libro y el nombre completo de su autor (Consulta entre dos tablas):
SELECT 
    l.titulo AS 'Título del Libro',
    CONCAT(a.nombre, ' ', a.apellido) AS 'Autor Completo',
    a.pais AS 'País de Origen'
FROM libro l
INNER JOIN autor a ON l.id_autor = a.id
ORDER BY `Autor Completo` ASC, l.titulo ASC;


-- -----------------------------------------------------------------------------
-- NIVEL: MEDIO-FÁCIL (Funciones de Agregación)
-- -----------------------------------------------------------------------------

-- 8. Introducción a Funciones de Agregación:
-- AVG() calcula la media, COUNT() cuenta registros, MAX() y MIN() obtienen extremos, SUM() totaliza.

-- 9. Calcular el precio medio de todos los libros:
SELECT 
    ROUND(AVG(precio), 2) AS 'Precio Medio de los Libros (€)'
FROM libro;

-- 10. Contar cuántos libros hay en total:
SELECT 
    COUNT(*) AS 'Total de Libros Registrados'
FROM libro;

-- 11. Calcular el precio máximo y mínimo de los libros:
SELECT 
    MIN(precio) AS 'Precio Mínimo (€)',
    MAX(precio) AS 'Precio Máximo (€)'
FROM libro;

-- 12. Calcular la suma de los precios de todos los libros:
SELECT 
    SUM(precio) AS 'Suma Total de Precios (€)'
FROM libro;


-- -----------------------------------------------------------------------------
-- NIVEL: MEDIO-DIFÍCIL (GROUP BY y Agrupaciones Avanzadas)
-- -----------------------------------------------------------------------------

-- 13. Contar cuántos libros ha escrito cada autor:
SELECT 
    CONCAT(a.nombre, ' ', a.apellido) AS 'Autor',
    a.pais AS 'País',
    COUNT(l.id) AS 'Número de Libros'
FROM autor a
INNER JOIN libro l ON a.id = l.id_autor
GROUP BY a.id, a.nombre, a.apellido, a.pais
ORDER BY `Número de Libros` DESC;

-- 14. Mostrar el número de libros de cada género:
SELECT 
    genero AS 'Género',
    COUNT(*) AS 'Total de Libros'
FROM libro
GROUP BY genero
ORDER BY `Total de Libros` DESC;

-- 15. Mostrar el precio medio de los libros de cada género:
SELECT 
    genero AS 'Género',
    ROUND(AVG(precio), 2) AS 'Precio Medio (€)',
    COUNT(*) AS 'Total de Libros'
FROM libro
GROUP BY genero
ORDER BY `Precio Medio (€)` DESC;

-- 16. Mostrar cada autor junto con el precio medio de sus libros:
SELECT 
    CONCAT(a.nombre, ' ', a.apellido) AS 'Autor',
    ROUND(AVG(l.precio), 2) AS 'Precio Medio de sus Libros (€)',
    COUNT(l.id) AS 'Total Libros'
FROM autor a
INNER JOIN libro l ON a.id = l.id_autor
GROUP BY a.id, a.nombre, a.apellido
ORDER BY `Precio Medio de sus Libros (€)` DESC;
