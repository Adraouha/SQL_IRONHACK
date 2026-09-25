package com.ironhack.cochesjpa1.Entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

/**
 * Entidad JPA: Coche
 * - Mapea esta clase a la tabla 'coche' en la base de datos (ORM: Object Relational Mapping).
 * - Utiliza Lombok para evitar escribir constructores, getters y setters manuales.
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
}
