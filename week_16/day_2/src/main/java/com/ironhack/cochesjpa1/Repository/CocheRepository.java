package com.ironhack.cochesjpa1.Repository;

import com.ironhack.cochesjpa1.Entity.Coche;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CocheRepository extends JpaRepository<Coche, Long> {
    Optional<Coche> findByMatricula(String matricula);
    Optional<Coche> findByMatriculaIgnoreCase(String matricula);
    boolean existsByMatricula(String matricula);
    List<Coche> findByMarcaIgnoreCase(String marca);
}
