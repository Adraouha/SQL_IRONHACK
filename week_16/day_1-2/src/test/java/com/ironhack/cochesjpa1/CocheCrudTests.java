package com.ironhack.cochesjpa1;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Repository.CocheRepository;

/**
 * 5 Casos de prueba para validar las operaciones CRUD sobre la entidad Coche en Java con Spring Data JPA y JUnit 5.
 */
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CocheCrudTests {

    @Autowired
    private CocheRepository cocheRepository;

    private static Long cocheCreadoId;

    // =========================================================================
    // CASO 1: CREATE (Crear y guardar un nuevo coche)
    // =========================================================================
    @Test
    @Order(1)
    @DisplayName("1. CREATE - Guardar un nuevo coche y verificar que se genera ID autoincremental")
    void test1_crearCoche() {
        // Arrange: Creamos un nuevo objeto Coche sin ID (el ID lo genera la BD)
        Coche nuevoCoche = new Coche(null, "Saricol", "Col 30", "161-Sar", 9000.0);
        Coche nuevoCoche2 = new Coche(null, "Abo38", " Col 29", "262-Abo", 19000.0);
        Coche nuevoCoche3 = new Coche(null, "Adraou", " Col 28", "363-Adra", 29000.0);
        cocheRepository.saveAll(List.of(nuevoCoche, nuevoCoche2, nuevoCoche3));

        // Act: Persistimos en la base de datos MySQL con el repositorio
        Coche cocheGuardado = cocheRepository.save(nuevoCoche);
        Coche cocheGuardado2 = cocheRepository.save(nuevoCoche2);
        Coche cocheGuardado3 = cocheRepository.save(nuevoCoche3);
        

        // Guardamos el ID para pruebas posteriores
        cocheCreadoId = cocheGuardado.getId();

        // Assert: Comprobamos que el ID no es nulo y que los datos coinciden
        assertNotNull(cocheGuardado.getId(), "El ID generado no debe ser null");
        assertEquals("Saricol", cocheGuardado.getMarca());
        assertEquals("Col 30", cocheGuardado.getModelo());
        assertEquals("161-Sar", cocheGuardado.getMatricula());
        assertEquals(9000.0, cocheGuardado.getPrecio());

        assertNotNull(cocheGuardado2.getId(), "El ID generado no debe ser null");
        assertEquals("Abo38", cocheGuardado2.getMarca());
        assertEquals("Col 29", cocheGuardado2.getModelo());
        assertEquals("262-Abo", cocheGuardado2.getMatricula());
        assertEquals(19000.0, cocheGuardado2.getPrecio());

        assertNotNull(cocheGuardado3.getId(), "El ID generado no debe ser null");
        assertEquals("Adraou", cocheGuardado3.getMarca());
        assertEquals("Col 28", cocheGuardado3.getModelo());
        assertEquals("363-Adra", cocheGuardado3.getMatricula());
        assertEquals(29000.0, cocheGuardado3.getPrecio());
    }

    // =========================================================================
    // CASO 2: READ ALL (Listar todos los coches existentes)
    // =========================================================================
    @Test
    @Order(2)
    @DisplayName("2. READ (ALL) - Listar todos los coches de la base de datos")
    void test2_obtenerTodosLosCoches() {
        // Act: Obtenemos todos los registros
        List<Coche> listaCoches = cocheRepository.findAll();

        // Assert: La lista no debe ser nula ni estar vacía
        assertNotNull(listaCoches, "La lista de coches no debe ser null");
        assertFalse(listaCoches.isEmpty(), "La base de datos debe contener al menos un coche");
        assertTrue(listaCoches.size() >= 1, "Debe haber registros persistidos");
    }

    // =========================================================================
    // CASO 3: READ BY ID (Buscar un coche específico por su ID)
    // =========================================================================
    @Test
    @Order(3)
    @DisplayName("3. READ (BY ID) - Buscar un coche por su ID primario")
    void test3_obtenerCochePorId() {
        // Arrange: Usamos el ID del coche creado en el Caso 1
        assertNotNull(cocheCreadoId, "Debe existir un coche previo creado para esta prueba");

        // Act: Buscamos por ID mediante findById()
        Optional<Coche> cocheEncontrado = cocheRepository.findById(cocheCreadoId);

        // Assert: El coche debe estar presente y su matrícula debe coincidir
        assertTrue(cocheEncontrado.isPresent(), "El coche debería existir en la BD");
        assertEquals("4455-KLM", cocheEncontrado.get().getMatricula());
        assertEquals("Mercedes", cocheEncontrado.get().getMarca());
    }

    // =========================================================================
    // CASO 4: UPDATE (Modificar datos de un coche existente)
    // =========================================================================
    @Test
    @Order(4)
    @DisplayName("4. UPDATE - Modificar precio y modelo de un coche existente")
    void test4_actualizarCoche() {
        // Arrange: Buscamos el coche creado
        Coche coche = cocheRepository.findById(cocheCreadoId)
                .orElseThrow(() -> new AssertionError("Coche no encontrado"));

        // Act: Modificamos atributos y actualizamos con save()
        double nuevoPrecio = 36900.0;
        String nuevoModelo = "Clase A 200d AMG Line";
        coche.setPrecio(nuevoPrecio);
        coche.setModelo(nuevoModelo);

        Coche cocheActualizado = cocheRepository.save(coche);

        // Assert: Verificamos que los datos se han guardado actualizados
        assertEquals(nuevoPrecio, cocheActualizado.getPrecio());
        assertEquals(nuevoModelo, cocheActualizado.getModelo());

        // Comprobamos volviendo a consultar la base de datos
        Coche verificado = cocheRepository.findById(cocheCreadoId).get();
        assertEquals(nuevoPrecio, verificado.getPrecio());
        assertEquals(nuevoModelo, verificado.getModelo());
    }

    // =========================================================================
    // CASO 5: DELETE (Eliminar un coche por su ID)
    // =========================================================================
    @Test
    @Order(5)
    @DisplayName("5. DELETE - Eliminar un coche y verificar que ya no existe en la BD")
    void test5_eliminarCoche() {
        // Arrange: Creamos un coche exclusivo para eliminar
        Coche cocheAEliminar = cocheRepository.save(new Coche(null, "Renault", "Clio", "8899-DEL", 11000.0));
        Long idEliminar = cocheAEliminar.getId();
        assertTrue(cocheRepository.existsById(idEliminar), "El coche debe existir antes de ser borrado");

        // Act: Eliminamos el registro de la BD
        cocheRepository.deleteById(idEliminar);

        // Assert: Comprobamos que el coche ya no existe
        Optional<Coche> resultado = cocheRepository.findById(idEliminar);
        assertTrue(resultado.isEmpty(), "El coche eliminado ya no debe encontrarse en la base de datos");
        assertFalse(cocheRepository.existsById(idEliminar), "existsById debe devolver false");
    }
}
