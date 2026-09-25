package com.ironhack.cochesjpa1.Service;

import com.ironhack.cochesjpa1.Entity.Coche;

import java.util.List;
import java.util.Optional;

public interface CocheService {
    List<Coche> findAll();
    List<Coche> findByMarca(String marca);
    Optional<Coche> findById(Long id);
    Optional<Coche> findByMatricula(String matricula);
    Coche create(Coche coche);
    Coche update(Long id, Coche coche);
    boolean deleteById(Long id);
}
