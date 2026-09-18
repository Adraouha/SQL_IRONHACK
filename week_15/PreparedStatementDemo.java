package week_15;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/**
 * =============================================================================
 * IRONHACK - BOOTCAMP DATA & WEB
 * SEMANA 15 - DÍA 4: PreparedStatement en JDBC (Seguridad y Eficiencia)
 * 
 * LAB 1: Reemplazar consultas con comillas por PreparedStatement parametrizado (?)
 * LAB 2: Menú interactivo para insertar, consultar y actualizar datos en BD
 * =============================================================================
 */
public class PreparedStatementDemo {

    private static final String URL = "jdbc:mysql://localhost:3306/tienda_discos?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USUARIO = "root";
    private static final String PASSWORD = ""; // Ajusta según tu entorno local

    public static void main(String[] args) {
        System.out.println("==========================================================");
        System.out.println("  GESTIÓN DE DISCOS CON PREPAREDSTATEMENT - IRONHACK DAY 4");
        System.out.println("==========================================================");

        try (Connection conexion = DriverManager.getConnection(URL, USUARIO, PASSWORD);
             Scanner scanner = new Scanner(System.in)) {

            System.out.println(" [OK] Conectado a 'tienda_discos' con éxito.\n");

            boolean salir = false;
            while (!salir) {
                System.out.println("\n--- MENÚ DE OPERACIONES ---");
                System.out.println("1. Ver todos los discos");
                System.out.println("2. Insertar nuevo disco (con PreparedStatement)");
                System.out.println("3. Actualizar título de un disco existente");
                System.out.println("4. Buscar discos por artista");
                System.out.println("5. Eliminar un disco por ID");
                System.out.println("0. Salir");
                System.out.print("Elige una opción: ");

                String opcion = scanner.nextLine().trim();

                switch (opcion) {
                    case "1":
                        listarDiscos(conexion);
                        break;
                    case "2":
                        insertarDiscoInteractivo(conexion, scanner);
                        break;
                    case "3":
                        actualizarTituloInteractivo(conexion, scanner);
                        break;
                    case "4":
                        buscarPorArtistaInteractivo(conexion, scanner);
                        break;
                    case "5":
                        eliminarDiscoInteractivo(conexion, scanner);
                        break;
                    case "0":
                        salir = true;
                        System.out.println("¡Hasta pronto!");
                        break;
                    default:
                        System.out.println("Opción no válida. Inténtalo de nuevo.");
                }
            }

        } catch (SQLException e) {
            System.err.println("❌ Error en la base de datos: " + e.getMessage());
        }
    }

    /**
     * Consulta y muestra todos los discos.
     */
    private static void listarDiscos(Connection conexion) throws SQLException {
        String sql = "SELECT id, titulo, artista, anio, precio FROM discos ORDER BY id ASC";
        try (PreparedStatement prep = conexion.prepareStatement(sql);
             ResultSet rs = prep.executeQuery()) {

            System.out.println("\n-------------------------------------------------------------------------------");
            System.out.printf("%-5s | %-30s | %-20s | %-6s | %-10s%n", "ID", "TÍTULO", "ARTISTA", "AÑO", "PRECIO (€)");
            System.out.println("-------------------------------------------------------------------------------");

            while (rs.next()) {
                System.out.printf("%-5d | %-30s | %-20s | %-6d | %-10.2f%n",
                        rs.getInt("id"),
                        rs.getString("titulo"),
                        rs.getString("artista"),
                        rs.getInt("anio"),
                        rs.getDouble("precio"));
            }
        }
    }

    /**
     * Inserta un nuevo disco usando PreparedStatement y parámetros posicionales (?).
     */
    private static void insertarDiscoInteractivo(Connection conexion, Scanner scanner) throws SQLException {
        System.out.println("\n--- Insertar Nuevo Disco ---");
        System.out.print("Título: ");
        String titulo = scanner.nextLine();

        System.out.print("Artista: ");
        String artista = scanner.nextLine();

        System.out.print("Año de lanzamiento (ej: 1995): ");
        int anio = Integer.parseInt(scanner.nextLine().trim());

        System.out.print("Precio (ej: 21.50): ");
        double precio = Double.parseDouble(scanner.nextLine().replace(',', '.').trim());

        String sql = "INSERT INTO discos (titulo, artista, anio, precio) VALUES (?, ?, ?, ?)";

        try (PreparedStatement prep = conexion.prepareStatement(sql)) {
            prep.setString(1, titulo);
            prep.setString(2, artista);
            prep.setInt(3, anio);
            prep.setDouble(4, precio);

            int filas = prep.executeUpdate();
            if (filas > 0) {
                System.out.println(" [OK] ¡Disco '" + titulo + "' insertado correctamente mediante PreparedStatement!");
            }
        }
    }

    /**
     * Actualiza el título de un disco dado su ID.
     * Ejemplo exacto del enunciado:
     *   String actualizar = "UPDATE discos SET titulo = ? WHERE id = ?";
     */
    private static void actualizarTituloInteractivo(Connection conexion, Scanner scanner) throws SQLException {
        System.out.println("\n--- Actualizar Título de Disco ---");
        System.out.print("Introduce el ID del disco a modificar: ");
        int id = Integer.parseInt(scanner.nextLine().trim());

        System.out.print("Introduce el nuevo título: ");
        String nuevoTitulo = scanner.nextLine();

        String actualizar = "UPDATE discos SET titulo = ? WHERE id = ?";

        try (PreparedStatement prep = conexion.prepareStatement(actualizar)) {
            prep.setString(1, nuevoTitulo); // 1er interrogante (?) -> nuevo título
            prep.setInt(2, id);             // 2do interrogante (?) -> id del disco

            int filasModificadas = prep.executeUpdate();
            if (filasModificadas > 0) {
                System.out.println(" [OK] Título actualizado con éxito para el disco con ID " + id);
            } else {
                System.out.println("⚠️ No se encontró ningún disco con el ID especificado.");
            }
        }
    }

    /**
     * Busca discos por artista usando LIKE parametrizado de forma segura.
     */
    private static void buscarPorArtistaInteractivo(Connection conexion, Scanner scanner) throws SQLException {
        System.out.print("\nIntroduce el nombre o fragmento del artista a buscar: ");
        String busqueda = scanner.nextLine();

        String sql = "SELECT id, titulo, artista, anio, precio FROM discos WHERE artista LIKE ? ORDER BY anio ASC";

        try (PreparedStatement prep = conexion.prepareStatement(sql)) {
            prep.setString(1, "%" + busqueda + "%");

            try (ResultSet rs = prep.executeQuery()) {
                System.out.println("\nResultados encontrados:");
                boolean encontrado = false;
                while (rs.next()) {
                    encontrado = true;
                    System.out.printf("• [%d] '%s' - %s (%d) - %.2f €%n",
                            rs.getInt("id"),
                            rs.getString("titulo"),
                            rs.getString("artista"),
                            rs.getInt("anio"),
                            rs.getDouble("precio"));
                }
                if (!encontrado) {
                    System.out.println("No se encontraron discos para el criterio indicado.");
                }
            }
        }
    }

    /**
     * Elimina un disco por su ID con PreparedStatement.
     */
    private static void eliminarDiscoInteractivo(Connection conexion, Scanner scanner) throws SQLException {
        System.out.print("\nIntroduce el ID del disco a eliminar: ");
        int id = Integer.parseInt(scanner.nextLine().trim());

        String sql = "DELETE FROM discos WHERE id = ?";

        try (PreparedStatement prep = conexion.prepareStatement(sql)) {
            prep.setInt(1, id);

            int filas = prep.executeUpdate();
            if (filas > 0) {
                System.out.println(" [OK] Disco eliminado correctamente.");
            } else {
                System.out.println("⚠️ No existía ningún registro con el ID " + id);
            }
        }
    }
}
