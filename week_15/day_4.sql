-- =============================================================================
-- IRONHACK - DATA ANALYTICS / WEB DEV - BOOTCAMP
-- SEMANA 15 - DÍA 4: PreparedStatement en JDBC (Seguridad y Rendimiento)
-- Base de Datos: tienda_discos
-- Código Java complementario: week_15/PreparedStatementDemo.java
-- =============================================================================

-- 1. Creación de la base de datos
CREATE DATABASE IF NOT EXISTS tienda_discos
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE tienda_discos;

-- 2. Eliminación y creación de la tabla 'discos'
DROP TABLE IF EXISTS discos;

CREATE TABLE discos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    artista VARCHAR(100) NOT NULL,
    anio INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL
);

-- 3. Inserción de registros iniciales de prueba
INSERT INTO discos (titulo, artista, anio, precio) VALUES
('The Dark Side of the Moon', 'Pink Floyd', 1973, 24.99),
('Abbey Road', 'The Beatles', 1969, 22.50),
('Thriller', 'Michael Jackson', 1982, 19.95),
('Back in Black', 'AC/DC', 1980, 21.00),
('Random Access Memories', 'Daft Punk', 2013, 25.00);

-- 4. Comprobación inicial de datos:
SELECT * FROM discos;

-- =============================================================================
-- COMPARATIVA TÉCNICA: STATEMENT VS PREPAREDSTATEMENT
-- =============================================================================
-- 1. Concatenación Insegura (Statement):
--    String sql = "SELECT * FROM usuarios WHERE user = '" + u + "' AND pass = '" + p + "'";
--    PELIGRO: Si el usuario introduce: ' OR '1'='1
--    La consulta se convierte en: SELECT * FROM usuarios WHERE user = '' OR '1'='1'
--    ¡Se salta la autenticación y permite Inyección SQL (SQL Injection)!
--
-- 2. Plantilla Parametrizada (PreparedStatement):
--    String sql = "UPDATE discos SET titulo = ? WHERE id = ?";
--    PreparedStatement prep = conexion.prepareStatement(sql);
--    prep.setString(1, "Nuevo Titulo");
--    prep.setInt(2, 3);
--    prep.executeUpdate();
--
--    VENTAJAS:
--    a) Máxima Seguridad: El motor de BD trata los '?' estrictamente como datos literales,
--       escapando caracteres especiales automáticamente y neutralizando cualquier SQL Injection.
--    b) Precompilación y Rendimiento: La BD compila y planifica la consulta una sola vez,
--       reutilizando el plan de ejecución para múltiples ejecuciones.
--    c) Código Limpio: Desaparece la maraña de comillas simples y dobles (\"'\" + var + \"'\").
--
-- Consulta el programa Java funcional en:
-- -> week_15/PreparedStatementDemo.java
-- =============================================================================
