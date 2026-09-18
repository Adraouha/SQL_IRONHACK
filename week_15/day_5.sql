-- =============================================================================
-- IRONHACK - DATA ANALYTICS / WEB DEV - BOOTCAMP
-- SEMANA 15 - DÍA 5: Clientes HTTP (Postman / Thunder Client) y su Mapeo con SQL
-- Documento de laboratorio completo: week_15/day_5_http_client.md
-- =============================================================================

-- =============================================================================
-- MAPEO FUNDAMENTAL: VERBOS HTTP (REST) <---> SENTENCIAS SQL (CRUD)
-- =============================================================================
-- Cuando usamos herramientas visuales como Postman, Thunder Client o Insomnia
-- para comunicarnos con una API REST conectada a una base de datos MySQL,
-- cada método HTTP se traduce en una operación SQL específica en el backend:
--
--  MÉTODO HTTP   OPERACIÓN CRUD       SENTENCIA SQL EQUIVALENTE
-- ------------- ---------------- ----------------------------------------------
--  GET           Read (Lectura)   SELECT * FROM tabla WHERE id = ?;
--  POST          Create (Crear)   INSERT INTO tabla (col1, col2) VALUES (?, ?);
--  PUT           Update (Total)   UPDATE tabla SET col1 = ?, col2 = ? WHERE id = ?;
--  PATCH         Update (Parcial) UPDATE tabla SET col1 = ? WHERE id = ?;
--  DELETE        Delete (Borrar)  DELETE FROM tabla WHERE id = ?;
-- =============================================================================

CREATE DATABASE IF NOT EXISTS api_rest_ejemplo
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE api_rest_ejemplo;

DROP TABLE IF EXISTS articulos;

CREATE TABLE articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    cuerpo TEXT NOT NULL,
    autor_id INT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserción inicial simulando llamadas POST:
INSERT INTO articulos (titulo, cuerpo, autor_id) VALUES
('Primer Post en el Blog', 'Contenido del primer artículo de prueba...', 1),
('Bases de Datos con MySQL', 'Aprender SQL y normalización relacional...', 1),
('APIs REST con Java y Spring', 'Cómo exponer servicios REST en el puerto 8080...', 2);

-- -----------------------------------------------------------------------------
-- SIMULACIÓN DE OPERACIONES RECIBIDAS DESDE POSTMAN / THUNDER CLIENT:
-- -----------------------------------------------------------------------------

-- 1. [GET /api/articulos] -> Consulta de todos los artículos
SELECT id, titulo, autor_id, creado_en FROM articulos;

-- 2. [GET /api/articulos/2] -> Consulta de un artículo por ID
SELECT * FROM articulos WHERE id = 2;

-- 3. [POST /api/articulos] -> Creación de un nuevo recurso
INSERT INTO articulos (titulo, cuerpo, autor_id) 
VALUES ('Novedades en HTTP/3', 'Explicación del protocolo QUIC...', 3);

-- 4. [PUT /api/articulos/1] -> Reemplazo completo del recurso
UPDATE articulos 
SET titulo = 'Primer Post (Edición Definitiva)', 
    cuerpo = 'Texto completamente reescrito', 
    autor_id = 1 
WHERE id = 1;

-- 5. [PATCH /api/articulos/1] -> Actualización parcial (solo el título)
UPDATE articulos 
SET titulo = 'Título actualizado por PATCH' 
WHERE id = 1;

-- 6. [DELETE /api/articulos/4] -> Eliminación del recurso
DELETE FROM articulos WHERE id = 4;

-- Para las respuestas a las preguntas teóricas del laboratorio y los endpoints de prueba,
-- consulta: week_15/day_5_http_client.md
