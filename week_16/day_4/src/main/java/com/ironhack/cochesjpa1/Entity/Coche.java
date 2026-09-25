package com.ironhack.cochesjpa1.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.JoinColumn;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Entidad JPA: Coche
 * - Mapea esta clase a la tabla 'coche' en la base de datos (ORM: Object Relational Mapping).
 * - Relación N:1 con Marca (Muchos coches pertenecen a una marca).
 */
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Table(name = "coche")
public class Coche {

    // Clave primaria autoincremental (se corresponde con BIGINT AUTO_INCREMENT en MySQL)
    @Id
    @Column(name = "idcoche")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Si no cambiamos el nombre de la columna con @Column, toma el nombre del atributo por defecto
    private String marca;
    private String modelo;

    // Matrícula única y no nula por seguridad
    @Column(unique = true, nullable = false)
    private String matricula;

    private double precio;

    // Relación Many-to-One con la entidad Marca
    @ManyToOne
    @JoinColumn(name = "marca_id")
    @JsonBackReference
    @ToString.Exclude
    private Marca marcaId;

    public Coche(Long id, String marca, String modelo, String matricula, double precio) {
        this.id = id;
        this.marca = marca;
        this.modelo = modelo;
        this.matricula = matricula;
        this.precio = precio;
    }
}
