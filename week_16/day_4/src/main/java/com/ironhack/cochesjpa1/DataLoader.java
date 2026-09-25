package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Entity.Marca;
import com.ironhack.cochesjpa1.Repository.CocheRepository;
import com.ironhack.cochesjpa1.Repository.MarcaRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * Carga datos iniciales automáticamente en la base de datos si la tabla marca está vacía.
 */
@Component
public class DataLoader implements CommandLineRunner {

    private final MarcaRepository marcaRepository;
    private final CocheRepository cocheRepository;

    public DataLoader(MarcaRepository marcaRepository, CocheRepository cocheRepository) {
        this.marcaRepository = marcaRepository;
        this.cocheRepository = cocheRepository;
    }

    @Override
    public void run(String... args) throws Exception {
        if (marcaRepository.count() == 0) {
            Marca toyota = marcaRepository.save(new Marca(null, "Toyota", "Japón"));
            Marca cupra = marcaRepository.save(new Marca(null, "Cupra", "España"));
            Marca audi = marcaRepository.save(new Marca(null, "Audi", "Alemania"));
            Marca mercedes = marcaRepository.save(new Marca(null, "Mercedes", "Alemania"));
            Marca seat = marcaRepository.save(new Marca(null, "Seat", "España"));

            // Asociar coches existentes que no tengan marca asignada
            List<Coche> coches = cocheRepository.findAll();
            for (Coche c : coches) {
                if (c.getMarcaId() == null && c.getMarca() != null) {
                    String m = c.getMarca().toLowerCase().trim();
                    if (m.contains("toyota")) c.setMarcaId(toyota);
                    else if (m.contains("cupra")) c.setMarcaId(cupra);
                    else if (m.contains("audi")) c.setMarcaId(audi);
                    else if (m.contains("mercedes")) c.setMarcaId(mercedes);
                    else c.setMarcaId(seat);
                    cocheRepository.save(c);
                }
            }
        }
    }
}
