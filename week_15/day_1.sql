-- =============================================================================
-- SEMANA 15 - DÍA 1: Tablas Puente (Relaciones N:M), Timestamps y Export/Import
-- =============================================================================
-- =============================================================================
-- TABLA-PUENTE - PLATAFORMA DE PODCASTS
-- Concepto:
--   ¿Cómo relacionar Usuarios y Podcasts de forma que un usuario pueda descargarse
--   muchos podcasts y un podcast pueda ser descargado por muchos usuarios,
--   sin mezclar descargas antiguas con las nuevas?
--
-- Solución:
--   Crear una TABLA-PUENTE ('descargas') que conecta la tabla 'usuario' con 'podcast'.
--   La tabla puente almacena las claves foráneas de ambas tablas y los metadatos
--   específicos de la interacción (por ejemplo, el momento exacto: CURRENT_TIMESTAMP).
--
-- Esquema relacional:
--   usuario (1) <----- (N) descargas (N) -----> (1) podcast
-- =============================================================================

-- 1.1 Creación de la base de datos
CREATE DATABASE IF NOT EXISTS plataforma_podcasts
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE plataforma_podcasts;

-- 1.2 Eliminación controlada de tablas (primero la puente/hija, luego las entidades fuertes)
DROP TABLE IF EXISTS descargas;
DROP TABLE IF EXISTS podcast;
DROP TABLE IF EXISTS usuario;

-- 1.3 Tabla Fuerte 1: usuario
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    pais VARCHAR(50) NOT NULL
);

-- 1.4 Tabla Fuerte 2: podcast
CREATE TABLE podcast (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    tematica VARCHAR(50) NOT NULL,
    duracion_min INT NOT NULL,
    locutor VARCHAR(100) NOT NULL
);

-- 1.5 Tabla Puente: descargas
-- Guarda el momento exacto de la descarga con CURRENT_TIMESTAMP por defecto
CREATE TABLE descargas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    podcast_id INT NOT NULL,
    momento_descarga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    calidad_audio VARCHAR(20) DEFAULT '128kbps',
    CONSTRAINT fk_descargas_usuario 
        FOREIGN KEY (usuario_id) 
        REFERENCES usuario(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_descargas_podcast 
        FOREIGN KEY (podcast_id) 
        REFERENCES podcast(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);

-- -----------------------------------------------------------------------------
-- ANÁLISIS TEÓRICO: ¿QUÉ PROBLEMAS ENCONTRAMOS AL MODELAR TABLAS PUENTE?
-- -----------------------------------------------------------------------------
-- 1. Clave Primaria: ¿Usar un id autoincrementable o una clave compuesta (usuario_id, podcast_id)?
--    - Si usamos clave compuesta PRIMARY KEY (usuario_id, podcast_id), un usuario
--      SOLO podría descargarse un podcast una única vez en toda su vida.
--    - Como un usuario puede descargarse el mismo podcast en diferentes fechas
--      (ej: volver a escuchar un episodio favorito), es mejor usar un ID autoincremental
--      propio o incluir 'momento_descarga' en la clave compuesta.
-- 2. Integridad Referencial:
--    - Si un usuario o un podcast se elimina, ¿qué ocurre con sus descargas registradas?
--      Con 'ON DELETE CASCADE', las descargas históricas se borran automáticamente.
--      En sistemas financieros/auditorías suele preferirse 'ON DELETE RESTRICT' o borrado lógico.


-- =============================================================================
-- INSERCIÓN DE REGISTROS DE PRUEBA (DML)
-- =============================================================================

-- Usuarios (5 usuarios)
INSERT INTO usuario (nombre, email, pais) VALUES
('Carlos Gómez', 'carlos@mail.com', 'España'),
('Laura Martínez', 'laura@mail.com', 'México'),
('Alejandro Silva', 'alejandro@mail.com', 'Argentina'),
('Marta Ruiz', 'marta@mail.com', 'España'),
('David López', 'david@mail.com', 'Colombia');

-- Podcasts (6 podcasts)
INSERT INTO podcast (titulo, tematica, duracion_min, locutor) VALUES
('The Wild Project', 'Entrevistas / Actualidad', 180, 'Jordi Wild'),
('Entiende Tu Mente', 'Psicología', 25, 'Molo Cebrián'),
('Nadie Sabe Nada', 'Comedia', 50, 'Buenafuente y Berto'),
('Geopolítica Global', 'Noticias / Política', 45, 'Fernando Díaz'),
('Aprende SQL en 10 Minutos', 'Tecnología', 15, 'Hassan Data'),
('Meditación Diaria', 'Salud / Bienestar', 12, 'Paz Gómez');

-- Descargas (Registros en la tabla puente)
-- Nótese que dejamos fechas personalizadas y otras con el timestamp por defecto
INSERT INTO descargas (usuario_id, podcast_id, calidad_audio, momento_descarga) VALUES
(1, 1, '320kbps', '2024-03-01 10:15:00'),
(1, 2, '128kbps', '2024-03-02 11:30:00'),
(1, 5, '320kbps', '2024-03-05 09:00:00'),
(2, 1, '128kbps', '2024-03-03 14:20:00'),
(2, 3, '128kbps', '2024-03-04 18:45:00'),
(3, 3, '320kbps', '2024-03-02 21:10:00'),
(3, 4, '128kbps', '2024-03-06 16:00:00'),
(3, 5, '320kbps', '2024-03-07 19:30:00'),
(4, 2, '128kbps', '2024-03-08 08:15:00'),
(4, 5, '320kbps', '2024-03-09 12:00:00'),
(4, 1, '320kbps', '2024-03-10 17:50:00'),
(1, 1, '320kbps', '2024-03-11 20:00:00'); -- Carlos vuelve a descargar el podcast 1


-- =============================================================================
-- CONSULTAS MULTI-TABLA (DQL)
-- =============================================================================

-- 1. ¿Qué podcasts se ha descargado un cliente determinado? (ejemplo: Carlos Gómez)
SELECT 
    u.nombre AS 'Usuario',
    u.email AS 'Email',
    p.titulo AS 'Podcast Descargado',
    p.tematica AS 'Temática',
    p.locutor AS 'Locutor',
    d.momento_descarga AS 'Fecha y Hora'
FROM descargas d
INNER JOIN usuario u ON d.usuario_id = u.id
INNER JOIN podcast p ON d.podcast_id = p.id
WHERE u.nombre = 'Carlos Gómez'
ORDER BY d.momento_descarga DESC;

-- 2. Historial completo de descargas con detalles de todas las tablas:
SELECT 
    d.id AS 'ID Descarga',
    u.nombre AS 'Usuario',
    u.pais AS 'País',
    p.titulo AS 'Podcast',
    p.duracion_min AS 'Duración (min)',
    d.calidad_audio AS 'Calidad',
    d.momento_descarga AS 'Momento de Descarga'
FROM descargas d
INNER JOIN usuario u ON d.usuario_id = u.id
INNER JOIN podcast p ON d.podcast_id = p.id
ORDER BY d.momento_descarga DESC;

-- 3. Ranking de los podcasts más descargados:
SELECT 
    p.titulo AS 'Podcast',
    p.locutor AS 'Locutor',
    COUNT(d.id) AS 'Total Descargas'
FROM podcast p
LEFT JOIN descargas d ON p.id = d.podcast_id
GROUP BY p.id, p.titulo, p.locutor
ORDER BY `Total Descargas` DESC;

-- 4. Podcasts que NUNCA han sido descargados (identificados mediante LEFT JOIN):
SELECT 
    p.id AS 'ID',
    p.titulo AS 'Podcast sin Descargas',
    p.locutor AS 'Locutor'
FROM podcast p
LEFT JOIN descargas d ON p.id = d.podcast_id
WHERE d.id IS NULL;

-- 5. Número de descargas por usuario (incluyendo usuarios sin descargas, ej: David López):
SELECT 
    u.nombre AS 'Usuario',
    u.pais AS 'País',
    COUNT(d.id) AS 'Cantidad de Descargas Realizadas'
FROM usuario u
LEFT JOIN descargas d ON u.id = d.usuario_id
GROUP BY u.id, u.nombre, u.pais
ORDER BY `Cantidad de Descargas Realizadas` DESC;


-- =============================================================================
-- PARTE 2 (EXTRA): EXPORTAR / IMPORTAR BD & TABLA EMPLEADOS (discoduroderoer)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS empresa_discoduroderoer
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE empresa_discoduroderoer;

DROP TABLE IF EXISTS empleados;
DROP TABLE IF EXISTS departamentos;

-- Tabla Departamentos
CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL
);

-- Tabla Empleados con Clave Foránea
CREATE TABLE empleados (
    dni VARCHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    fecha_alta DATE NOT NULL,
    id_departamento INT,
    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY (id_departamento) 
        REFERENCES departamentos(id_departamento)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Inserción de departamentos
INSERT INTO departamentos (nombre, ubicacion) VALUES
('Desarrollo', 'Madrid'),
('Ventas', 'Barcelona'),
('Recursos Humanos', 'Valencia'),
('Marketing', 'Sevilla');

-- Inserción de empleados
INSERT INTO empleados (dni, nombre, apellidos, salario, fecha_alta, id_departamento) VALUES
('11111111A', 'Antonio', 'Pérez Gómez', 24000.00, '2020-01-15', 1),
('22222222B', 'Beatriz', 'López Castro', 28500.00, '2019-06-01', 1),
('33333333C', 'Carlos', 'Martín Gil', 21000.00, '2021-03-10', 2),
('44444444D', 'Diana', 'Sánchez Mora', 32000.00, '2018-11-20', 3),
('55555555E', 'Eduardo', 'Romero Ruiz', 19500.00, '2022-09-01', NULL); -- Sin departamento

-- -----------------------------------------------------------------------------
-- GUÍA PASO A PASO: CÓMO EXPORTAR E IMPORTAR UNA BASE DE DATOS
-- -----------------------------------------------------------------------------
-- OPCIÓN A: En DBeaver
--   1. Exportar:
--      - Clic derecho en la BD (ej: plataforma_podcasts) -> Herramientas (Tools) -> Backup / Exportar Base de Datos.
--      - Selecciona las tablas, la ruta de destino (archivo .sql) y pulsa Iniciar.
--   2. Importar:
--      - Crea la BD vacía: CREATE DATABASE mi_bd;
--      - Clic derecho en la conexión o BD -> Herramientas (Tools) -> Restore / Ejecutar Script SQL.
--      - Selecciona el archivo .sql exportado y ejecuta.
--
-- OPCIÓN B: En MySQL Workbench
--   1. Exportar: Pestaña 'Server' -> 'Data Export' -> Escoge BD -> 'Export to Self-Contained File' -> 'Start Export'.
--   2. Importar: Pestaña 'Server' -> 'Data Import' -> 'Import from Self-Contained File' -> 'Start Import'.
--
-- OPCIÓN C: Vía Terminal (Línea de Comandos con mysqldump)
--   - Exportar:
--     mysqldump -u root -p plataforma_podcasts > backup_podcasts.sql
--   - Importar:
--     mysql -u root -p plataforma_podcasts < backup_podcasts.sql
-- -----------------------------------------------------------------------------
