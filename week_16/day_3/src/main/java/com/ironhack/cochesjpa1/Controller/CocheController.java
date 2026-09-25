package com.ironhack.cochesjpa1.Controller;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Service.CocheService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

/**
 * Controlador REST para la gestión de Coches.
 * Expone las rutas HTTP bajo el path base /api/coches.
 */
@RestController
@RequestMapping("/api/coches")
public class CocheController {

    private final CocheService cocheService;

    public CocheController(CocheService cocheService) {
        this.cocheService = cocheService;
    }

    /**
     * 1. Obtener todos los coches o filtrar por marca opcional.
     * GET http://localhost:8080/api/coches
     * GET http://localhost:8080/api/coches?marca=Cupra
     */
    @GetMapping
    public ResponseEntity<List<Coche>> getAllCoches(@RequestParam(required = false) String marca) {
        List<Coche> coches = (marca != null && !marca.trim().isEmpty())
                ? cocheService.findByMarca(marca)
                : cocheService.findAll();
        return ResponseEntity.ok(coches);
    }

    /**
     * 2. Obtener un coche por su ID primario.
     * GET http://localhost:8080/api/coches/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<Coche> getCocheById(@PathVariable Long id) {
        return cocheService.findById(id)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResourceNotFoundException("Coche no encontrado con ID: " + id));
    }

    /**
     * 3. Obtener un coche por su matrícula.
     * GET http://localhost:8080/api/coches/matricula/{matricula}
     */
    @GetMapping("/matricula/{matricula}")
    public ResponseEntity<Coche> getCocheByMatricula(@PathVariable String matricula) {
        return cocheService.findByMatricula(matricula)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResourceNotFoundException("Coche no encontrado con matrícula: " + matricula));
    }

    /**
     * 4. Crear un nuevo coche.
     * POST http://localhost:8080/api/coches
     */
    @PostMapping
    public ResponseEntity<Coche> createCoche(@RequestBody Coche coche) {
        Coche nuevoCoche = cocheService.create(coche);
        URI location = URI.create("/api/coches/" + nuevoCoche.getId());
        return ResponseEntity.created(location).body(nuevoCoche);
    }

    /**
     * 5. Actualizar un coche existente por su ID.
     * PUT http://localhost:8080/api/coches/{id}
     */
    @PutMapping("/{id}")
    public ResponseEntity<Coche> updateCoche(@PathVariable Long id, @RequestBody Coche cocheDetails) {
        Coche actualizado = cocheService.update(id, cocheDetails);
        return ResponseEntity.ok(actualizado);
    }

    /**
     * 6. Eliminar un coche por su ID.
     * DELETE http://localhost:8080/api/coches/{id}
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCoche(@PathVariable Long id) {
        cocheService.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
