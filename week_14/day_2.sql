-- =============================================================================
-- BASE DE DATOS: CONCESIONARIO DE COCHES
-- Concepto clave:
--   - Tabla Madre (Padre): `marca` (contiene la PRIMARY KEY idmarca)
--   - Tabla Hija: `coche` (contiene la FOREIGN KEY marca_id que referencia a idmarca)
--   - Relación: 1 a N (Una marca puede tener muchos coches, cada coche pertenece a una marca)
-- =============================================================================

-- 1. Creación de la base de datos
CREATE DATABASE IF NOT EXISTS concesionario_coches
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE concesionario_coches;

-- 2. Eliminación de tablas en orden correcto (primero la hija, luego la madre)
DROP TABLE IF EXISTS coche;
DROP TABLE IF EXISTS marca;

-- 3. Creación de la Tabla Madre: marca
CREATE TABLE marca (
    idmarca INT AUTO_INCREMENT PRIMARY KEY,
    nombreMarca VARCHAR(50) NOT NULL UNIQUE,
    paisOrigen VARCHAR(50) NOT NULL
);

-- 4. Creación de la Tabla Hija: coche
-- Observa la definición de la FOREIGN KEY al final de la tabla:
CREATE TABLE coche (
    idcoche INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    marca_id INT NOT NULL,
    CONSTRAINT fk_coche_marca 
        FOREIGN KEY (marca_id) 
        REFERENCES marca(idmarca) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- 5. Inserción de datos en la Tabla Madre (marca)
-- idmarca 1: Audi, 2: BMW, 3: Toyota, 4: Ford, 5: Seat, 6: Porsche (sin coches para pruebas de LEFT JOIN)
INSERT INTO marca (nombreMarca, paisOrigen) VALUES
('Audi', 'Alemania'),
('BMW', 'Alemania'),
('Toyota', 'Japón'),
('Ford', 'Estados Unidos'),
('Seat', 'España'),
('Porsche', 'Alemania');

-- 6. Inserción de datos en la Tabla Hija (coche)
-- Cada coche se asocia mediante 'marca_id' al 'idmarca' correspondiente
INSERT INTO coche (modelo, anio, precio, marca_id) VALUES
('A3 Sportback', 2021, 32500.00, 1),      -- Audi (idmarca = 1)
('A4 Avant', 2023, 46800.00, 1),          -- Audi (idmarca = 1)
('Q5 Quattro', 2022, 54200.00, 1),        -- Audi (idmarca = 1)
('Serie 3 Touring', 2022, 45000.00, 2),   -- BMW  (idmarca = 2)
('X1 sDrive', 2020, 34000.00, 2),         -- BMW  (idmarca = 2)
('Corolla Hybrid', 2023, 27500.00, 3),    -- Toyota (idmarca = 3)
('Yaris Cross', 2022, 24900.00, 3),       -- Toyota (idmarca = 3)
('RAV4 Plug-in', 2024, 48000.00, 3),      -- Toyota (idmarca = 3)
('Mustang GT', 2021, 58000.00, 4),        -- Ford (idmarca = 4)
('Focus EcoBoost', 2019, 18500.00, 4),    -- Ford (idmarca = 4)
('Ibiza TSI', 2020, 16800.00, 5),         -- Seat (idmarca = 5)
('León FR', 2023, 28900.00, 5);           -- Seat (idmarca = 5)


-- =============================================================================
-- CONSULTAS Y PRUEBAS CON AMBAS TABLAS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- CONSULTA 1: Ejemplo solicitado usando sintaxis tradicional de WHERE
-- "Muéstrame los coches con marca Audi (idmarca = 1)"
-- -----------------------------------------------------------------------------
SELECT 
    m.nombreMarca AS 'marca coche', 
    c.modelo 
FROM coche c, marca m 
WHERE c.marca_id = m.idmarca 
  AND m.idmarca = 1;

-- -----------------------------------------------------------------------------
-- CONSULTA 2: Misma consulta usando la sintaxis estándar ANSI SQL (INNER JOIN)
-- Nota: En proyectos reales y buenas prácticas se prefiere INNER JOIN porque:
--   1. Separa la lógica de unión (ON) de los filtros de datos (WHERE).
--   2. Evita olvidos accidentales que puedan generar productos cartesianos pesados.
-- -----------------------------------------------------------------------------
SELECT 
    m.nombreMarca AS 'Marca', 
    c.modelo AS 'Modelo',
    c.anio AS 'Año',
    c.precio AS 'Precio (€)'
FROM coche c
INNER JOIN marca m ON c.marca_id = m.idmarca
WHERE m.nombreMarca = 'Audi';

-- -----------------------------------------------------------------------------
-- CONSULTA 3: Ver todos los coches con los datos completos de su marca
-- -----------------------------------------------------------------------------
SELECT 
    c.idcoche AS 'ID',
    m.nombreMarca AS 'Marca',
    m.paisOrigen AS 'País de Fabricación',
    c.modelo AS 'Modelo',
    c.anio AS 'Año',
    c.precio AS 'Precio (€)'
FROM coche c
INNER JOIN marca m ON c.marca_id = m.idmarca
ORDER BY m.nombreMarca ASC, c.precio DESC;

-- -----------------------------------------------------------------------------
-- CONSULTA 4: Coches alemanes con precio superior a 40.000 €
-- -----------------------------------------------------------------------------
SELECT 
    m.nombreMarca AS 'Marca',
    c.modelo AS 'Modelo',
    m.paisOrigen AS 'País',
    c.precio AS 'Precio (€)'
FROM coche c
INNER JOIN marca m ON c.marca_id = m.idmarca
WHERE m.paisOrigen = 'Alemania' 
  AND c.precio > 40000.00
ORDER BY c.precio DESC;

-- -----------------------------------------------------------------------------
-- CONSULTA 5: Agregación - Cuántos coches y precio medio por marca
-- -----------------------------------------------------------------------------
SELECT 
    m.nombreMarca AS 'Marca',
    COUNT(c.idcoche) AS 'Total Coches Disponibles',
    ROUND(AVG(c.precio), 2) AS 'Precio Medio (€)',
    MIN(c.precio) AS 'Precio Mínimo (€)',
    MAX(c.precio) AS 'Precio Máximo (€)'
FROM coche c
INNER JOIN marca m ON c.marca_id = m.idmarca
GROUP BY m.nombreMarca
ORDER BY `Total Coches Disponibles` DESC;

-- -----------------------------------------------------------------------------
-- CONSULTA 6: LEFT JOIN - Marcas con o sin coches en stock
-- Nota: Mostrará 'Porsche' con valores NULL en el coche, ya que no tiene modelos registrados.
-- -----------------------------------------------------------------------------
SELECT 
    m.nombreMarca AS 'Marca',
    m.paisOrigen AS 'País',
    c.modelo AS 'Modelo',
    IFNULL(c.precio, 'Sin stock') AS 'Precio'
FROM marca m
LEFT JOIN coche c ON m.idmarca = c.marca_id
ORDER BY m.nombreMarca;

-- -----------------------------------------------------------------------------
-- DEMOSTRACIÓN DE INTEGRIDAD REFERENCIAL (CLAVE FORÁNEA):
-- Si intentas insertar un coche con una marca inexistente (por ejemplo, marca_id = 999):
-- MySQL lanzará un error: Cannot add or update a child row: a foreign key constraint fails
-- -----------------------------------------------------------------------------
-- INSERT INTO coche (modelo, anio, precio, marca_id) VALUES ('Invalido', 2024, 20000, 999); -- Descomentar para ver el error
