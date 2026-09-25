package com.ironhack.cochesjpa1.Service;

import com.ironhack.cochesjpa1.Entity.Marca;

import java.util.List;
import java.util.Optional;

public interface MarcaService {
    List<Marca> findAll();
    Optional<Marca> findById(Long id);
    Optional<Marca> findByNombre(String nombre);
    Marca create(Marca marca);
    Marca update(Long id, Marca marca);
    boolean deleteById(Long id);
}
