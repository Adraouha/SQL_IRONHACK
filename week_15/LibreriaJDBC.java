package week_15;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/**
 * =============================================================================
 * IRONHACK - BOOTCAMP DATA & WEB
 * SEMANA 15 - DÍA 3: Conexión JDBC (Java Data Base Connectivity) con MySQL
 * 
 * LAB 1: Conexión básica, creación de tabla y operaciones CRUD estándar.
 * LAB 2: Inserción de datos dinámicos solicitados al usuario mediante Scanner.
 * =============================================================================
 */
public class LibreriaJDBC {

    // Configuración de la conexión a MySQL
    private static final String URL = "jdbc:mysql://localhost:3306/libreria_jdbc?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USUARIO = "root";
    private static final String PASSWORD = ""; // Ajusta tu contraseña de MySQL aquí (ej: "root" o vacío en XAMPP)

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("   PROYECTO LIBRERIA JDBC - IRONHACK (DAY 3)     ");
        System.out.println("=================================================");

        try (Connection conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
             Scanner scanner = new Scanner(System.in)) {

            System.out.println(" [OK] Conexión establecida con éxito con MySQL.");

            // 1. Asegurar que la tabla existe
            crearTablaSiNoExiste(conexion);

            // 2. Insertar registros de prueba iniciales (CRUD - Create)
            insertarRegistroInicial(conexion, "El Hobbit", "J.R.R. Tolkien", 19.99);

            // 3. Consultar los registros existentes (CRUD - Read)
            listarLibros(conexion);

            // 4. LAB 2: Solicitar datos al usuario por consola e insertarlos
            System.out.println("\n-------------------------------------------------");
            System.out.println(" LAB 2: Inserción dinámica con datos del usuario ");
            System.out.println("-------------------------------------------------");

            System.out.print("Introduce el título del libro: ");
            String titulo = scanner.nextLine();

            System.out.print("Introduce el autor del libro: ");
            String autor = scanner.nextLine();

            System.out.print("Introduce el precio del libro (ej: 15.50): ");
            double precio = Double.parseDouble(scanner.nextLine().replace(',', '.'));

            insertarLibroDinamico(conexion, titulo, autor, precio);

            // 5. Mostrar la lista actualizada
            System.out.println("\n--- Lista de libros tras la inserción interactiva ---");
            listarLibros(conexion);

        } catch (SQLException e) {
            System.err.println("❌ Error de SQL / Conexión: " + e.getMessage());
            System.err.println("Verifica que MySQL esté iniciado y que la base de datos 'libreria_jdbc' exista.");
        } catch (Exception e) {
            System.err.println("❌ Error inesperado: " + e.getMessage());
        }
    }

    /**
     * Crea la tabla 'libros' si no existe previamente en la base de datos.
     */
    private static void crearTablaSiNoExiste(Connection conexion) throws SQLException {
        String sql = "CREATE TABLE IF NOT EXISTS libros (" +
                     "id INT AUTO_INCREMENT PRIMARY KEY, " +
                     "titulo VARCHAR(100) NOT NULL, " +
                     "autor VARCHAR(100) NOT NULL, " +
                     "precio DECIMAL(10, 2) NOT NULL)";

        try (Statement stmt = conexion.createStatement()) {
            stmt.executeUpdate(sql);
            System.out.println(" [OK] Tabla 'libros' verificada.");
        }
    }

    /**
     * Inserta un libro mediante concatenación de cadenas clásica (Statement).
     */
    private static void insertarRegistroInicial(Connection conexion, String titulo, String autor, double precio) throws SQLException {
        String sql = "INSERT INTO libros (titulo, autor, precio) VALUES ('" + titulo + "', '" + autor + "', " + precio + ")";
        try (Statement stmt = conexion.createStatement()) {
            stmt.executeUpdate(sql);
            System.out.println(" [OK] Libro inicial insertado: " + titulo);
        }
    }

    /**
     * LAB 2: Inserta un libro usando las variables introducidas por el usuario.
     * NOTA: Este método utiliza concatenación tradicional con comillas.
     * En el Día 4 aprenderemos a usar PreparedStatement, que es la forma segura contra SQL Injection.
     */
    private static void insertarLibroDinamico(Connection conexion, String titulo, String autor, double precio) throws SQLException {
        // Cuidado con comillas dentro de comillas en SQL clásico:
        String sql = "INSERT INTO libros (titulo, autor, precio) VALUES ('" + 
                     titulo.replace("'", "''") + "', '" + 
                     autor.replace("'", "''") + "', " + 
                     precio + ")";

        try (Statement stmt = conexion.createStatement()) {
            int filasAfectadas = stmt.executeUpdate(sql);
            if (filasAfectadas > 0) {
                System.out.println(" [ÉXITO] ¡Libro añadido al registro correctamente!");
            }
        }
    }

    /**
     * Consulta y muestra todos los libros en consola (CRUD - Read).
     */
    private static void listarLibros(Connection conexion) throws SQLException {
        String sql = "SELECT id, titulo, autor, precio FROM libros ORDER BY id ASC";

        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            System.out.println("\n--- LISTADO DE LIBROS EN BASE DE DATOS ---");
            System.out.printf("%-5s | %-35s | %-25s | %-10s%n", "ID", "TÍTULO", "AUTOR", "PRECIO (€)");
            System.out.println("----------------------------------------------------------------------------------");

            boolean hayDatos = false;
            while (rs.next()) {
                hayDatos = true;
                int id = rs.getInt("id");
                String titulo = rs.getString("titulo");
                String autor = rs.getString("autor");
                double precio = rs.getDouble("precio");

                System.out.printf("%-5d | %-35s | %-25s | %-10.2f%n", id, titulo, autor, precio);
            }

            if (!hayDatos) {
                System.out.println("No se encontraron registros en la tabla.");
            }
        }
    }
}
