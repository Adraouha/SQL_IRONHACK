-- =============================================================================
-- SEMANA 15 - DÍA 3: Conexión JDBC (Java Database Connectivity) con MySQL
-- Base de Datos: libreria_jdbc
-- =============================================================================

-- 1. Creación de la base de datos para el proyecto Java JDBC
CREATE DATABASE IF NOT EXISTS libreria_jdbc
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE libreria_jdbc;

-- 2. Eliminación y creación de la tabla 'libros'
DROP TABLE IF EXISTS libros;

CREATE TABLE libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    autor VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- 3. Inserción de registros iniciales para verificar la conexión
INSERT INTO libros (titulo, autor, precio) VALUES
('Don Quijote de la Mancha', 'Miguel de Cervantes', 18.50),
('Cien años de soledad', 'Gabriel García Márquez', 21.00),
('El principito', 'Antoine de Saint-Exupéry', 12.00);

-- 4. Consulta de comprobación:
SELECT * FROM libros;

-- =============================================================================
-- GUÍA DE INTEGRACIÓN CON JAVA (JDBC):
-- =============================================================================
-- 1. ¿Qué es JDBC?
--    Es la API estándar de Java (paquete java.sql.*) que permite enviar sentencias
--    SQL a cualquier base de datos relacional.
--
-- 2. Driver necesario:
--    MySQL Connector/J (com.mysql.cj.jdbc.Driver)
--    - En Maven (pom.xml):
--      <dependency>
--          <groupId>com.mysql</groupId>
--          <artifactId>mysql-connector-j</artifactId>
--          <version>8.3.0</version>
--      </dependency>
--
-- 3. URL de conexión habitual:
--    jdbc:mysql://localhost:3306/libreria_jdbc?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
--
-- Consulta el archivo Java completo con el menú interactivo en:
-- -> week_15/LibreriaJDBC.java
-- =============================================================================
