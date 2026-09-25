package com.ironhack.cochesjpa1.Controller;

import com.ironhack.cochesjpa1.Entity.Marca;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Service.MarcaService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

/**
 * Controlador REST para la gestión de Marcas.
 * Expone las rutas HTTP bajo el path base /api/marcas.
 */
@RestController
@RequestMapping("/api/marcas")
public class MarcaController {

    private final MarcaService marcaService;

    public MarcaController(MarcaService marcaService) {
        this.marcaService = marcaService;
    }

    /**
     * 1. Obtener todas las marcas (incluye la lista de sus coches asociados gracias a @JsonManagedReference).
     * GET http://localhost:8080/api/marcas
     */
    @GetMapping
    public ResponseEntity<List<Marca>> getAllMarcas() {
        return ResponseEntity.ok(marcaService.findAll());
    }

    /**
     * 2. Obtener una marca por su ID.
     * GET http://localhost:8080/api/marcas/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Marca> getMarcaById(@PathVariable Long id) {
        return marcaService.findById(id)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResourceNotFoundException("Marca no encontrada con ID: " + id));
    }

    /**
     * 3. Crear una nueva marca.
     * POST http://localhost:8080/api/marcas
     */
    @PostMapping
    public ResponseEntity<Marca> createMarca(@RequestBody Marca marca) {
        Marca nuevaMarca = marcaService.create(marca);
        URI location = URI.create("/api/marcas/" + nuevaMarca.getId());
        return ResponseEntity.created(location).body(nuevaMarca);
    }

    /**
     * 4. Actualizar una marca existente por su ID.
     * PUT http://localhost:8080/api/marcas/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<Marca> updateMarca(@PathVariable Long id, @RequestBody Marca marcaDetails) {
        Marca actualizada = marcaService.update(id, marcaDetails);
        return ResponseEntity.ok(actualizada);
    }

    /**
     * 5. Eliminar una marca por su ID.
     * DELETE http://localhost:8080/api/marcas/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMarca(@PathVariable Long id) {
        marcaService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
