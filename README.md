# SQL_IRONHACK - Prácticas de Bases de Datos

Repositorio de ejercicios y actividades de bases de datos relacionales (MySQL) organizados por semanas y días lectivos para el bootcamp de Ironhack.

---

## 📁 Estructura del Proyecto

```text
SQL_IRONHACK/
├── week_14/
│   ├── day_1.sql   # Fundamentos SQL: Creación BD, DDL, DML, DQL y Consultas Películas
│   ├── day_2.sql   # Relaciones 1:N y Claves Foráneas (FOREIGN KEY) - BD Coches
│   ├── day_3.sql   # Plantilla para Actividad Día 3
│   ├── day_4.sql   # Plantilla para Actividad Día 4
│   └── day_5.sql   # Plantilla para Actividad Día 5
├── week_15/
│   ├── day_1.sql   # Plantilla para Actividad Día 1
│   ├── day_2.sql   # Plantilla para Actividad Día 2
│   ├── day_3.sql   # Plantilla para Actividad Día 3
│   ├── day_4.sql   # Plantilla para Actividad Día 4
│   └── day_5.sql   # Plantilla para Actividad Día 5
└── README.md
```

---

## 🚀 Contenido Detallado

### Semana 14 (`week_14`)
- **[day_1.sql](week_14/day_1.sql)**:
  - **Parte 1 (BD libre - `tienda_tecnologia`)**: Creación de tabla `productos` con `id` autoincrementable, `nombre` (VARCHAR), `precio` (numérico) y `fecha_lanzamiento` (DATE). Consultas con `SELECT`, `WHERE`, `ORDER BY`, `DESC`, `>`, `<`, `=`, y búsqueda de patrones con `LIKE` (`%` y `_`), búsqueda de la letra `'m'`, filtrado por ID y ordenación numérica.
  - **Parte 2 (Películas - `cine_club`)**: Tabla `peliculas` con más de 10 registros. Consultas de títulos y años, ordenación alfabética y por año (ASC/DESC), agrupaciones por género (`GROUP BY`), filtros por recaudación y rango de años (`BETWEEN`), conteo (`COUNT`), suma (`SUM`) y promedio (`AVG`), utilizando alias descriptivos (`AS`).
- **[day_2.sql](week_14/day_2.sql)**:
  - **Relaciones entre tablas (1:N)**: Base de datos `concesionario_coches`.
  - Tabla madre: `marca` (`idmarca`, `nombreMarca`, `paisOrigen`).
  - Tabla hija: `coche` (`idcoche`, `modelo`, `anio`, `precio`, `marca_id` con `FOREIGN KEY` que referencia a `marca(idmarca)`).
  - Consultas usando la sintaxis del enunciado (`WHERE c.marca_id = m.idmarca`), equivalentes en `INNER JOIN` ANSI SQL estándar, filtros por país/precio, agregaciones (`COUNT`, `AVG`) y `LEFT JOIN` para identificar marcas sin stock.
- **[day_3.sql](week_14/day_3.sql)**:
  - **Modelos EER y Forward Engineering**: Base de datos `libreria` (relación 1:N no identificativa).
  - Tabla madre: `autor` (`id`, `nombre`, `apellido`, `pais`).
  - Tabla hija: `libro` (`id`, `titulo`, `fecha` [tipo `YEAR`], `genero`, `precio`, `id_autor` con `FOREIGN KEY`).
  - Inserciones de 6 autores (George Orwell, J.K. Rowling, Stephen King...) y 14 libros.
  - Resolución de 16 consultas clasificadas en:
    - *Fácil*: filtros por género, autor ("George Orwell"), fecha post-2000, precio > 20 €, `LIKE '%Harry%'`, rango con `BETWEEN` y `JOIN` con nombre completo de autor (`CONCAT`).
    - *Medio-Fácil (Agregación)*: `AVG()`, `COUNT(*)`, `MIN()`, `MAX()`, `SUM()`.
    - *Medio-Difícil (GROUP BY)*: libros por autor, libros por género, precio medio por género y precio medio de libros por autor.
- **[day_4.sql](week_14/day_4.sql)** y **[day_5.sql](week_14/day_5.sql)**: Archivos plantilla listos para incorporar las actividades correspondientes.

### Semana 15 (`week_15`)
- **[day_1.sql](week_15/day_1.sql)**:
  - **Tabla-Puente y Relaciones N:M**: Base de datos `plataforma_podcasts`. Conexión entre `usuario` y `podcast` mediante la tabla-puente `descargas` con `CURRENT_TIMESTAMP`. Consultas multi-tabla (historial de descargas por usuario, ranking de podcasts, podcasts nunca descargados y usuarios sin descargas con `LEFT JOIN`).
  - **Exportar/Importar**: Base de datos `empresa_discoduroderoer` (tablas `empleados` y `departamentos`) con guía paso a paso para DBeaver, Workbench y `mysqldump`.
- **[day_2.sql](week_15/day_2.sql)**:
  - **Dominio de JOINs y Gestión de NULLs**: Base de datos `clinica_veterinaria` con `duenio` (madre) y `mascota` (hija con FK `duenio_id` que admite NULLs).
  - Comparativa directa entre `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, emulación de `FULL OUTER JOIN` mediante `UNION`, y anti-joins para detectar animales en adopción y dueños sin mascotas.
  - Ejercicios adicionales de agregación estilo w3resource.
- **[day_3.sql](week_15/day_3.sql)** & **[LibreriaJDBC.java](week_15/LibreriaJDBC.java)**:
  - **Conexión JDBC (MySQL)**: Base de datos `libreria_jdbc` y aplicación Java completa con `main`.
  - Operaciones CRUD completas y menú interactivo con `Scanner` para que el usuario inserte registros dinámicamente.
- **[day_4.sql](week_15/day_4.sql)** & **[PreparedStatementDemo.java](week_15/PreparedStatementDemo.java)**:
  - **PreparedStatement y Seguridad**: Base de datos `tienda_discos` y programa Java con menú por consola.
  - Uso de plantillas SQL con interrogantes (`?`), `setString()`, `setInt()`, `setDouble()`, prevención de Inyección SQL y actualización de títulos (`UPDATE discos SET titulo = ? WHERE id = ?`).
- **[day_5.sql](week_15/day_5.sql)** & **[day_5_http_client.md](week_15/day_5_http_client.md)**:
  - **Clientes HTTP, APIs REST, Postman & Thunder Client**:
    - Respuestas exhaustivas a las preguntas del LAB: diferencias entre `PUT` y `PATCH`, borrado de registros (`DELETE`), función de las cabeceras (`Headers`), y seguridad/mecanismo de envío en `GET` vs `POST`.
    - Guía práctica de pruebas con APIs públicas (JSONPlaceholder, Rick & Morty, PokeAPI, ReqRes, Coinbase) con endpoints listos para Thunder Client/Postman.
    - Script SQL de mapeo entre Verbos HTTP y sentencias CRUD en base de datos.

---

## 🛠️ Cómo ejecutar en DBeaver

1. Abre **DBeaver** y conecta tu servidor local MySQL (o phpMyAdmin/XAMPP/Docker).
2. Abre el script correspondiente (por ejemplo `week_14/day_1.sql`).
3. Para ejecutar el script completo:
   - Presiona `Alt + X` (Ejecutar script SQL completo).
4. Para ejecutar consulta a consulta:
   - Sitúa el cursor sobre la consulta que quieras probar y presiona `Ctrl + Enter`.
