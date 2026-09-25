package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Exception.DuplicateResourceException;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Repository.CocheRepository;
import com.ironhack.cochesjpa1.Service.CocheServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
public class CocheServiceTests {

    @Mock
    private CocheRepository cocheRepository;

    @Mock
    private com.ironhack.cochesjpa1.Repository.MarcaRepository marcaRepository;

    @InjectMocks
    private CocheServiceImpl cocheService;

    private Coche cocheEjemplo;

    @BeforeEach
    void setUp() {
        cocheEjemplo = new Coche(1L, "Toyota", "Corolla", "1234-TOY", 24000.0);
    }

    @Test
    @DisplayName("Debe listar todos los coches")
    void testFindAll() {
        when(cocheRepository.findAll()).thenReturn(List.of(cocheEjemplo));

        List<Coche> resultado = cocheService.findAll();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("Toyota", resultado.get(0).getMarca());
        verify(cocheRepository, times(1)).findAll();
    }

    @Test
    @DisplayName("Debe encontrar un coche por ID existente")
    void testFindById_Exitoso() {
        when(cocheRepository.findById(1L)).thenReturn(Optional.of(cocheEjemplo));

        Optional<Coche> resultado = cocheService.findById(1L);

        assertTrue(resultado.isPresent());
        assertEquals("1234-TOY", resultado.get().getMatricula());
        verify(cocheRepository, times(1)).findById(1L);
    }

    @Test
    @DisplayName("Debe crear un coche correctamente cuando la matricula no existe")
    void testCreate_Exitoso() {
        Coche nuevo = new Coche(null, "Ford", "Focus", "5678-FOR", 21000.0);
        when(cocheRepository.existsByMatricula("5678-FOR")).thenReturn(false);
        when(cocheRepository.save(any(Coche.class))).thenAnswer(inv -> {
            Coche c = inv.getArgument(0);
            c.setId(10L);
            return c;
        });

        Coche creado = cocheService.create(nuevo);

        assertNotNull(creado.getId());
        assertEquals("Ford", creado.getMarca());
        verify(cocheRepository, times(1)).save(nuevo);
    }

    @Test
    @DisplayName("Debe lanzar DuplicateResourceException si la matrícula ya está registrada")
    void testCreate_MatriculaDuplicada() {
        Coche nuevo = new Coche(null, "BMW", "Serie 1", "1234-TOY", 30000.0);
        when(cocheRepository.existsByMatricula("1234-TOY")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> cocheService.create(nuevo));
        verify(cocheRepository, never()).save(any(Coche.class));
    }

    @Test
    @DisplayName("Debe actualizar un coche existente")
    void testUpdate_Exitoso() {
        Coche modificaciones = new Coche(null, "Toyota", "Corolla GR", "1234-TOY", 32000.0);
        when(cocheRepository.findById(1L)).thenReturn(Optional.of(cocheEjemplo));
        when(cocheRepository.findByMatricula("1234-TOY")).thenReturn(Optional.of(cocheEjemplo));
        when(cocheRepository.save(any(Coche.class))).thenReturn(cocheEjemplo);

        Coche actualizado = cocheService.update(1L, modificaciones);

        assertNotNull(actualizado);
        assertEquals("Corolla GR", actualizado.getModelo());
        assertEquals(32000.0, actualizado.getPrecio());
        verify(cocheRepository, times(1)).save(cocheEjemplo);
    }

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al actualizar coche inexistente")
    void testUpdate_NoEncontrado() {
        when(cocheRepository.findById(999L)).thenReturn(Optional.empty());

        assertThrows(ResourceNotFoundException.class, () -> cocheService.update(999L, cocheEjemplo));
        verify(cocheRepository, never()).save(any(Coche.class));
    }

    @Test
    @DisplayName("Debe eliminar un coche existente por ID")
    void testDelete_Exitoso() {
        when(cocheRepository.existsById(1L)).thenReturn(true);
        doNothing().when(cocheRepository).deleteById(1L);

        boolean resultado = cocheService.deleteById(1L);

        assertTrue(resultado);
        verify(cocheRepository, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al eliminar coche inexistente")
    void testDelete_NoEncontrado() {
        when(cocheRepository.existsById(999L)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () -> cocheService.deleteById(999L));
        verify(cocheRepository, never()).deleteById(anyLong());
    }
}
