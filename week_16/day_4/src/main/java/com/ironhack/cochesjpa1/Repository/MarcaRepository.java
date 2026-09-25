package com.ironhack.cochesjpa1.Repository;

import com.ironhack.cochesjpa1.Entity.Marca;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface MarcaRepository extends JpaRepository<Marca, Long> {
    Optional<Marca> findByNombre(String nombre);
    Optional<Marca> findByNombreIgnoreCase(String nombre);
    boolean existsByNombre(String nombre);
}
