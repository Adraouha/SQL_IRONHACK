package com.ironhack.cochesjpa1.Service;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Exception.DuplicateResourceException;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Repository.CocheRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class CocheServiceImpl implements CocheService {

    private final CocheRepository cocheRepository;

    public CocheServiceImpl(CocheRepository cocheRepository) {
        this.cocheRepository = cocheRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Coche> findAll() {
        return cocheRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Coche> findByMarca(String marca) {
        return cocheRepository.findByMarcaIgnoreCase(marca);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Coche> findById(Long id) {
        return cocheRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Coche> findByMatricula(String matricula) {
        return cocheRepository.findByMatriculaIgnoreCase(matricula);
    }

    @Override
    @Transactional
    public Coche create(Coche coche) {
        if (coche.getMatricula() == null || coche.getMatricula().trim().isEmpty()) {
            throw new IllegalArgumentException("La matrícula es obligatoria y no puede estar vacía.");
        }

        if (cocheRepository.existsByMatricula(coche.getMatricula())) {
            throw new DuplicateResourceException("Ya existe un coche registrado con la matrícula: " + coche.getMatricula());
        }

        // Aseguramos que el ID sea null para que la BD genere uno nuevo
        coche.setId(null);
        return cocheRepository.save(coche);
    }

    @Override
    @Transactional
    public Coche update(Long id, Coche cocheDetails) {
        Coche cocheExistente = cocheRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Coche no encontrado con ID: " + id));

        if (cocheDetails.getMatricula() != null && !cocheDetails.getMatricula().trim().isEmpty()) {
            cocheRepository.findByMatricula(cocheDetails.getMatricula()).ifPresent(otroCoche -> {
                if (!otroCoche.getId().equals(id)) {
                    throw new DuplicateResourceException("La matrícula " + cocheDetails.getMatricula() + " ya pertenece a otro coche.");
                }
            });
            cocheExistente.setMatricula(cocheDetails.getMatricula());
        }

        if (cocheDetails.getMarca() != null) {
            cocheExistente.setMarca(cocheDetails.getMarca());
        }
        if (cocheDetails.getModelo() != null) {
            cocheExistente.setModelo(cocheDetails.getModelo());
        }
        if (cocheDetails.getPrecio() > 0) {
            cocheExistente.setPrecio(cocheDetails.getPrecio());
        }

        return cocheRepository.save(cocheExistente);
    }

    @Override
    @Transactional
    public boolean deleteById(Long id) {
        if (!cocheRepository.existsById(id)) {
            throw new ResourceNotFoundException("Coche no encontrado con ID: " + id);
        }
        cocheRepository.deleteById(id);
        return true;
    }
}
