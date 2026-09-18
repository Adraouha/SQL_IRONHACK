-- =============================================================================
-- SEMANA 15 - DÍA 2: Dominio de JOINs (INNER, LEFT, RIGHT, FULL OUTER) y Gestión de NULLs
-- =============================================================================

-- =============================================================================
-- BASE DE DATOS - CLÍNICA VETERINARIA (DUEÑOS Y MASCOTAS)
-- Concepto clave:
--   - Tabla Madre: `duenio`
--   - Tabla Hija: `mascota` (con clave foránea 'duenio_id' que PERMITE NULLs)
-- Casos para poner a prueba los JOINs:
--   1. Dueños con mascotas asociadas.
--   2. Dueños sin mascotas registradas (clave primaria sin correspondencia en la hija).
--   3. Mascotas con dueño asignado.
--   4. Mascotas sin dueño (mascotas rescatadas / en adopción con 'duenio_id IS NULL').
-- =============================================================================

CREATE DATABASE IF NOT EXISTS clinica_veterinaria
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE clinica_veterinaria;

DROP TABLE IF EXISTS mascota;
DROP TABLE IF EXISTS duenio;

-- 1.1 Tabla Madre: duenio
CREATE TABLE duenio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    ciudad VARCHAR(50) NOT NULL
);

-- 1.2 Tabla Hija: mascota
-- NOTA: 'duenio_id' es NULLABLE (no tiene NOT NULL) para admitir animales sin dueño
CREATE TABLE mascota (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    edad INT NOT NULL,
    duenio_id INT NULL,
    CONSTRAINT fk_mascota_duenio 
        FOREIGN KEY (duenio_id) 
        REFERENCES duenio(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE
);

-- =============================================================================
-- INSERCIÓN DE DATOS DE PRUEBA (10 registros en cada tabla)
-- =============================================================================

-- Inserción de 10 Dueños:
INSERT INTO duenio (nombre, telefono, ciudad) VALUES
('Juan Pérez', '600111222', 'Madrid'),       -- id: 1 (tiene mascotas)
('María García', '611222333', 'Barcelona'),   -- id: 2 (tiene mascotas)
('Lucas Fernández', '622333444', 'Sevilla'),  -- id: 3 (tiene mascotas)
('Elena Romero', '633444555', 'Valencia'),    -- id: 4 (tiene mascotas)
('Pablo Morales', '644555666', 'Bilbao'),     -- id: 5 (tiene mascotas)
('Carmen Navarro', '655666777', 'Málaga'),    -- id: 6 (SIN MASCOTA)
('Alberto Torres', '666777888', 'Madrid'),    -- id: 7 (SIN MASCOTA)
('Sofía Ramos', '677888999', 'Zaragoza'),     -- id: 8 (SIN MASCOTA)
('Javier Ortiz', '688999000', 'Alicante'),    -- id: 9 (SIN MASCOTA)
('Beatriz Vega', '699000111', 'Toledo');      -- id: 10 (SIN MASCOTA)

-- Inserción de 10 Mascotas:
INSERT INTO mascota (nombre, especie, edad, duenio_id) VALUES
('Toby', 'Perro', 4, 1),                      -- Dueño: Juan Pérez
('Luna', 'Gato', 2, 1),                       -- Dueño: Juan Pérez (un dueño con 2 mascotas)
('Thor', 'Perro', 6, 2),                      -- Dueño: María García
('Misi', 'Gato', 1, 3),                       -- Dueño: Lucas Fernández
('Rocky', 'Perro', 5, 4),                     -- Dueño: Elena Romero
('Nemo', 'Pez', 1, 5),                        -- Dueño: Pablo Morales
('Simba', 'Gato', 3, NULL),                   -- SIN DUEÑO (En adopción)
('Kira', 'Perro', 2, NULL),                   -- SIN DUEÑO (En adopción)
('Copito', 'Conejo', 1, NULL),                -- SIN DUEÑO (En adopción)
('Pancho', 'Loro', 7, NULL);                  -- SIN DUEÑO (En adopción)


-- =============================================================================
-- CONSULTAS CON JOINS: COMPARACIÓN DIRECTA Y EXPLICACIÓN VISUAL
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. INNER JOIN (La Intersección Exacta)
-- Devuelve ÚNICAMENTE los registros que tienen coincidencia en AMBAS tablas.
-- Excluye mascotas sin dueño y dueños sin mascotas.
-- Resultado: 6 filas (solo las mascotas 1 a 6 con sus respectivos dueños).
-- -----------------------------------------------------------------------------
SELECT 
    m.id AS 'ID Mascota',
    m.nombre AS 'Mascota',
    m.especie AS 'Especie',
    d.nombre AS 'Nombre del Dueño',
    d.ciudad AS 'Ciudad',
    d.telefono AS 'Teléfono'
FROM mascota m
INNER JOIN duenio d ON m.duenio_id = d.id;

-- -----------------------------------------------------------------------------
-- 2. LEFT JOIN (Tabla Izquierda Completa)
-- Devuelve TODAS las filas de la tabla izquierda ('mascota'), tengan o no dueño.
-- Si la mascota no tiene dueño (duenio_id IS NULL), las columnas del dueño salen NULL.
-- Resultado: 10 filas (todas las mascotas).
-- -----------------------------------------------------------------------------
SELECT 
    m.id AS 'ID Mascota',
    m.nombre AS 'Mascota',
    m.especie AS 'Especie',
    IFNULL(d.nombre, '--- EN ADOPCIÓN (Sin dueño) ---') AS 'Dueño',
    IFNULL(d.telefono, 'N/A') AS 'Teléfono de Contacto'
FROM mascota m
LEFT JOIN duenio d ON m.duenio_id = d.id;

-- -----------------------------------------------------------------------------
-- 3. RIGHT JOIN (Tabla Derecha Completa)
-- Devuelve TODAS las filas de la tabla derecha ('duenio'), tengan o no mascota.
-- Si el dueño no tiene ninguna mascota asociada, las columnas de mascota salen NULL.
-- Resultado: 11 filas (Carmen, Alberto, Sofía, Javier, Beatriz salen con mascota NULL).
-- -----------------------------------------------------------------------------
SELECT 
    d.id AS 'ID Dueño',
    d.nombre AS 'Nombre Dueño',
    d.ciudad AS 'Ciudad',
    IFNULL(m.nombre, '--- SIN MASCOTA ASIGNADA ---') AS 'Mascota',
    IFNULL(m.especie, '---') AS 'Especie'
FROM mascota m
RIGHT JOIN duenio d ON m.duenio_id = d.id;

-- -----------------------------------------------------------------------------
-- 4. ANTI-JOIN 1: Mascotas huérfanas (sin dueño)
-- Útil para saber qué animales están esperando adopción.
-- -----------------------------------------------------------------------------
SELECT 
    m.id AS 'ID',
    m.nombre AS 'Mascota sin dueño',
    m.especie AS 'Especie',
    m.edad AS 'Edad (años)'
FROM mascota m
LEFT JOIN duenio d ON m.duenio_id = d.id
WHERE d.id IS NULL;

-- -----------------------------------------------------------------------------
-- 5. ANTI-JOIN 2: Dueños registrados que aún no tienen ninguna mascota
-- Útil para campañas de adopción o fidelización.
-- -----------------------------------------------------------------------------
SELECT 
    d.id AS 'ID Dueño',
    d.nombre AS 'Dueño sin mascota',
    d.telefono AS 'Teléfono',
    d.ciudad AS 'Ciudad'
FROM duenio d
LEFT JOIN mascota m ON d.id = m.duenio_id
WHERE m.id IS NULL;

-- -----------------------------------------------------------------------------
-- 6. FULL OUTER JOIN (Emulación en MySQL)
-- MySQL no tiene la instrucción nativa 'FULL OUTER JOIN', pero se emula
-- uniendo un LEFT JOIN con un RIGHT JOIN mediante 'UNION':
-- Muestra absolutamente TODO: mascotas con dueño, mascotas sin dueño y dueños sin mascota.
-- -----------------------------------------------------------------------------
SELECT 
    m.nombre AS 'Mascota',
    m.especie AS 'Especie',
    d.nombre AS 'Dueño',
    d.ciudad AS 'Ciudad'
FROM mascota m
LEFT JOIN duenio d ON m.duenio_id = d.id

UNION

SELECT 
    m.nombre AS 'Mascota',
    m.especie AS 'Especie',
    d.nombre AS 'Dueño',
    d.ciudad AS 'Ciudad'
FROM mascota m
RIGHT JOIN duenio d ON m.duenio_id = d.id;


-- =============================================================================
-- PARTE 2 (EXTRA): EJERCICIOS TIPO W3RESOURCE DE JOINS Y AGREGACIONES
-- =============================================================================

-- Ejercicio W3-1: Contar cuántas mascotas tiene cada dueño (incluyendo a los que tienen 0)
SELECT 
    d.nombre AS 'Dueño',
    d.ciudad AS 'Ciudad',
    COUNT(m.id) AS 'Total Mascotas'
FROM duenio d
LEFT JOIN mascota m ON d.id = m.duenio_id
GROUP BY d.id, d.nombre, d.ciudad
ORDER BY `Total Mascotas` DESC;

-- Ejercicio W3-2: Filtrar combinando JOIN y WHERE con múltiples condiciones
-- Mostrar mascotas de Madrid de más de 3 años con el nombre de su dueño:
SELECT 
    m.nombre AS 'Mascota',
    m.especie AS 'Especie',
    m.edad AS 'Edad',
    d.nombre AS 'Dueño',
    d.ciudad AS 'Ciudad'
FROM mascota m
INNER JOIN duenio d ON m.duenio_id = d.id
WHERE d.ciudad = 'Madrid' AND m.edad > 3;

-- Ejercicio W3-3: Promedio de edad de las mascotas que sí tienen dueño frente a las que no:
SELECT 
    CASE 
        WHEN m.duenio_id IS NOT NULL THEN 'Con Dueño'
        ELSE 'En Adopción / Sin Dueño'
    END AS 'Estado de la Mascota',
    COUNT(*) AS 'Cantidad',
    ROUND(AVG(m.edad), 1) AS 'Edad Media'
FROM mascota m
GROUP BY (m.duenio_id IS NOT NULL);
