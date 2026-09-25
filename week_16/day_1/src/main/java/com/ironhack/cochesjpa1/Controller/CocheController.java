package com.ironhack.cochesjpa1.Controller;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Repository.CocheRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/coches")
public class CocheController {

    private final CocheRepository cocheRepository;

    public CocheController(CocheRepository cocheRepository) {
        this.cocheRepository = cocheRepository;
    }

    // 1. Obtener todos los coches (GET http://localhost:8080/api/coches)
    @GetMapping
    public List<Coche> getAllCoches() {
        return cocheRepository.findAll();
    }

    // 2. Obtener un coche por ID (GET http://localhost:8080/api/coches/{id})
    @GetMapping("/{id}")
    public ResponseEntity<Coche> getCocheById(@PathVariable Long id) {
        return cocheRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // 3. Crear un nuevo coche (POST http://localhost:8080/api/coches)
    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Coche createCoche(@RequestBody Coche coche) {
        return cocheRepository.save(coche);
    }

    // 4. Actualizar un coche existente (PUT http://localhost:8080/api/coches/{id})
    @PutMapping("/{id}")
    public ResponseEntity<Coche> updateCoche(@PathVariable Long id, @RequestBody Coche cocheDetails) {
        return cocheRepository.findById(id).map(coche -> {
            coche.setMarca(cocheDetails.getMarca());
            coche.setModelo(cocheDetails.getModelo());
            coche.setMatricula(cocheDetails.getMatricula());
            coche.setPrecio(cocheDetails.getPrecio());
            return ResponseEntity.ok(cocheRepository.save(coche));
        }).orElse(ResponseEntity.notFound().build());
    }

    // 5. Eliminar un coche (DELETE http://localhost:8080/api/coches/{id})
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCoche(@PathVariable Long id) {
        if (cocheRepository.existsById(id)) {
            cocheRepository.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }
}
