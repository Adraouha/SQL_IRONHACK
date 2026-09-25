-- =======================================================================
-- PRUEBA DE EVALUACIÓN - UNIDAD 2 (MySQL)
-- Base de Datos: bicicletas_hassan (o bicicletas_tunombre)
-- Alumno: Hassan Adraou
-- 
-- ORDEN DEL SCRIPT SEGÚN ESPECIFICACIÓN:
-- 1. CREATE DATABASE / USE DATABASE
-- 2. CREATE TABLE (en el orden adecuado: clientes, bicicletas, pedidos)
-- 3. INSERT INTO (valores de prueba con datos reales de clase y FKs enlazadas)
-- 4. QUERIES (consultas 4.1 a 4.8)
-- =======================================================================

-- =======================================================================
-- 1. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
-- =======================================================================
DROP DATABASE IF EXISTS `bicicletas_hassan`;
CREATE DATABASE IF NOT EXISTS `bicicletas_hassan` 
    DEFAULT CHARACTER SET utf8mb4 
    COLLATE utf8mb4_unicode_ci;

USE `bicicletas_hassan`;

-- Limpieza preventiva de tablas en orden inverso a sus dependencias
DROP TABLE IF EXISTS `pedidos`;
DROP TABLE IF EXISTS `bicicletas`;
DROP TABLE IF EXISTS `clientes`;


-- =======================================================================
-- 2. CREACIÓN DE TABLAS Y RELACIONES (DDL)
-- =======================================================================

-- -----------------------------------------------------------------------
-- Ejercicio 1 (2,5 pts): Tabla 'clientes'
-- Columnas: id_cliente, nombre, apellido, email, telefono
-- -----------------------------------------------------------------------
CREATE TABLE `clientes` (
    `id_cliente` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `apellido` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `telefono` VARCHAR(20),
    PRIMARY KEY (`id_cliente`)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------
-- Ejercicio 1 (2,5 pts): Tabla 'bicicletas'
-- Columnas: id_bicicleta, marca, modelo, material, anio, precio
-- -----------------------------------------------------------------------
CREATE TABLE `bicicletas` (
    `id_bicicleta` INT NOT NULL AUTO_INCREMENT,
    `marca` VARCHAR(50) NOT NULL,
    `modelo` VARCHAR(50) NOT NULL,
    `material` VARCHAR(50) NOT NULL,
    `anio` INT NOT NULL,
    `precio` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`id_bicicleta`)
) ENGINE = InnoDB;

-- -----------------------------------------------------------------------
-- Ejercicio 1 y 2 (2,5 pts): Tabla 'pedidos'
-- Enlaza las tablas 'bicicletas' y 'clientes' mediante Claves Foráneas (FK)
-- Columnas: id_pedido, fecha, id_cliente, id_bicicleta
-- -----------------------------------------------------------------------
CREATE TABLE `pedidos` (
    `id_pedido` INT NOT NULL AUTO_INCREMENT,
    `fecha` DATE NOT NULL,
    `id_cliente` INT NOT NULL,
    `id_bicicleta` INT NOT NULL,
    PRIMARY KEY (`id_pedido`),
    CONSTRAINT `fk_pedidos_clientes`
        FOREIGN KEY (`id_cliente`)
        REFERENCES `clientes` (`id_cliente`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_pedidos_bicicletas`
        FOREIGN KEY (`id_bicicleta`)
        REFERENCES `bicicletas` (`id_bicicleta`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB;


-- =======================================================================
-- 3. INSERCIÓN DE DATOS (DML - 1 punto)
-- Mínimo tres filas por tabla. En 'pedidos' se enlazan los IDs existentes.
-- Clientes adaptados con los nombres del grupo/clase.
-- =======================================================================

-- Inserción de clientes
INSERT INTO `clientes` (`nombre`, `apellido`, `email`, `telefono`) VALUES
('Hassan', 'Adraou', 'hassan.adraou@email.com', '600111222'),
('Albert', 'Vandellos', 'albert.vandellos@email.com', '600333444'),
('Alba', 'Reche', 'alba.reche@email.com', '600555666'),
('Eduardo', 'Vazquez', 'eduardo.vazquez@email.com', '600777888'),
('Ingrid', 'Diaz Risso', 'ingrid.diaz@email.com', '600999000'),
('Jose', 'García', 'jose.garcia@email.com', '600123456'),
('Luiggi', 'Alvarado', 'luiggi.alvarado@email.com', '600234567'),
('Mohammed', 'Alisawi', 'mohammed.alisawi@email.com', '600345678'),
('Xavier', 'Puentestar', 'xavier.puentestar@email.com', '600456789'),
('Ying', 'Zhang', 'ying.zhang@email.com', '600567890');

-- Inserción de bicicletas (distintos rangos de precio: <500, 500-1500, >1000)
INSERT INTO `bicicletas` (`marca`, `modelo`, `material`, `anio`, `precio`) VALUES
('Trek', 'Marlin 7', 'Aluminio', 2023, 850.00),
('Specialized', 'Epic EVO', 'Carbono', 2024, 3200.00),
('Orbea', 'MX 50', 'Aluminio', 2022, 450.00),
('Cannondale', 'Trail 5', 'Aluminio', 2023, 750.00),
('Scott', 'Spark RC', 'Carbono', 2024, 2800.00);

-- Inserción de pedidos (relacionando id_cliente con id_bicicleta)
INSERT INTO `pedidos` (`fecha`, `id_cliente`, `id_bicicleta`) VALUES
('2024-03-15', 1, 2), -- Hassan Adraou compra Specialized Epic EVO (3200.00 €)
('2024-04-10', 2, 1), -- Albert Vandellos compra Trek Marlin 7 (850.00 €)
('2024-04-25', 3, 5), -- Alba Reche compra Scott Spark RC (2800.00 €)
('2024-05-02', 4, 4), -- Eduardo Vazquez compra Cannondale Trail 5 (750.00 €)
('2024-05-18', 5, 3), -- Ingrid Diaz Risso compra Orbea MX 50 (450.00 €)
('2024-06-01', 2, 3), -- Albert Vandellos compra Orbea MX 50 (450.00 €)
('2024-06-20', 7, 1), -- Luiggi Alvarado compra Trek Marlin 7 (850.00 €)
('2024-07-15', 9, 2); -- Xavier Puentestar compra Specialized Epic EVO (3200.00 €)


-- =======================================================================
-- 4. CONSULTAS (QUERIES - 4 puntos)
-- =======================================================================

-- 4.1- Muestra las bicicletas cuyo precio sea mayor de 1000 €.
SELECT 
    `id_bicicleta`,
    `marca`,
    `modelo`,
    `material`,
    `anio`,
    `precio`
FROM `bicicletas`
WHERE `precio` > 1000;

-- 4.2- Muestra las bicicletas ordenadas de mayor a menor precio.
SELECT 
    `id_bicicleta`,
    `marca`,
    `modelo`,
    `material`,
    `anio`,
    `precio`
FROM `bicicletas`
ORDER BY `precio` DESC;

-- 4.3- Busca los clientes cuyo nombre empiece por "A".
SELECT 
    `id_cliente`,
    `nombre`,
    `apellido`,
    `email`,
    `telefono`
FROM `clientes`
WHERE `nombre` LIKE 'A%';

-- 4.4- Muestra las bicicletas con precio entre 500 € y 1500 €.
SELECT 
    `id_bicicleta`,
    `marca`,
    `modelo`,
    `material`,
    `anio`,
    `precio`
FROM `bicicletas`
WHERE `precio` BETWEEN 500 AND 1500;

-- 4.5- ¿Cuántos clientes hay?
SELECT 
    COUNT(*) AS `total_clientes`
FROM `clientes`;

-- 4.6- Muestra el nombre del cliente y la fecha de su pedido.
SELECT 
    c.`nombre`,
    c.`apellido`,
    p.`fecha` AS `fecha_pedido`
FROM `clientes` c
INNER JOIN `pedidos` p ON c.`id_cliente` = p.`id_cliente`;

-- 4.7- Muestra cliente, bicicleta comprada y fecha del pedido.
SELECT 
    CONCAT(c.`nombre`, ' ', c.`apellido`) AS `cliente`,
    CONCAT(b.`marca`, ' ', b.`modelo`) AS `bicicleta_comprada`,
    p.`fecha` AS `fecha_pedido`
FROM `pedidos` p
INNER JOIN `clientes` c ON p.`id_cliente` = c.`id_cliente`
INNER JOIN `bicicletas` b ON p.`id_bicicleta` = b.`id_bicicleta`;

-- 4.8- Muestra nombre del cliente, bicicleta y precio de las bicicletas compradas por clientes cuyo nombre empiece por "A".
SELECT 
    c.`nombre` AS `nombre_cliente`,
    CONCAT(b.`marca`, ' ', b.`modelo`) AS `bicicleta`,
    b.`precio`
FROM `pedidos` p
INNER JOIN `clientes` c ON p.`id_cliente` = c.`id_cliente`
INNER JOIN `bicicletas` b ON p.`id_bicicleta` = b.`id_bicicleta`
WHERE c.`nombre` LIKE 'A%';
