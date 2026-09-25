package com.ironhack.cochesjpa1.Entity;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

/**
 * Entidad JPA: Marca
 * - Representa la tabla 'marca' en MySQL.
 * - Relación 1:N con Coche (Una marca tiene muchos coches).
 */
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Table(name = "marca")
public class Marca {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String nombre;

    private String pais;

    @OneToMany(mappedBy = "marcaId", cascade = CascadeType.ALL)
    @JsonManagedReference
    @ToString.Exclude
    private List<Coche> coches = new ArrayList<>();

    public Marca(Long id, String nombre, String pais) {
        this.id = id;
        this.nombre = nombre;
        this.pais = pais;
    }
}
