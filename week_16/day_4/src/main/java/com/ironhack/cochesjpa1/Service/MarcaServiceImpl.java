package com.ironhack.cochesjpa1.Service;

import com.ironhack.cochesjpa1.Entity.Marca;
import com.ironhack.cochesjpa1.Exception.DuplicateResourceException;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Repository.MarcaRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class MarcaServiceImpl implements MarcaService {

    private final MarcaRepository marcaRepository;

    public MarcaServiceImpl(MarcaRepository marcaRepository) {
        this.marcaRepository = marcaRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Marca> findAll() {
        return marcaRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Marca> findById(Long id) {
        return marcaRepository.findById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Marca> findByNombre(String nombre) {
        return marcaRepository.findByNombreIgnoreCase(nombre);
    }

    @Override
    @Transactional
    public Marca create(Marca marca) {
        if (marca.getNombre() == null || marca.getNombre().trim().isEmpty()) {
            throw new IllegalArgumentException("El nombre de la marca es obligatorio y no puede estar vacío.");
        }

        if (marcaRepository.existsByNombre(marca.getNombre())) {
            throw new DuplicateResourceException("Ya existe una marca registrada con el nombre: " + marca.getNombre());
        }

        marca.setId(null);
        return marcaRepository.save(marca);
    }

    @Override
    @Transactional
    public Marca update(Long id, Marca marcaDetails) {
        Marca marcaExistente = marcaRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Marca no encontrada con ID: " + id));

        if (marcaDetails.getNombre() != null && !marcaDetails.getNombre().trim().isEmpty()) {
            marcaRepository.findByNombreIgnoreCase(marcaDetails.getNombre()).ifPresent(otra -> {
                if (!otra.getId().equals(id)) {
                    throw new DuplicateResourceException("El nombre " + marcaDetails.getNombre() + " ya está en uso por otra marca.");
                }
            });
            marcaExistente.setNombre(marcaDetails.getNombre());
        }

        if (marcaDetails.getPais() != null) {
            marcaExistente.setPais(marcaDetails.getPais());
        }

        return marcaRepository.save(marcaExistente);
    }

    @Override
    @Transactional
    public boolean deleteById(Long id) {
        if (!marcaRepository.existsById(id)) {
            throw new ResourceNotFoundException("Marca no encontrada con ID: " + id);
        }
        marcaRepository.deleteById(id);
        return true;
    }
}
