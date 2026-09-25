package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Entity.Marca;
import com.ironhack.cochesjpa1.Exception.DuplicateResourceException;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Repository.MarcaRepository;
import com.ironhack.cochesjpa1.Service.MarcaServiceImpl;
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
public class MarcaServiceTests {

    @Mock
    private MarcaRepository marcaRepository;

    @InjectMocks
    private MarcaServiceImpl marcaService;

    private Marca marcaEjemplo;

    @BeforeEach
    void setUp() {
        marcaEjemplo = new Marca(1L, "Toyota", "Japón");
    }

    @Test
    @DisplayName("Debe listar todas las marcas")
    void testFindAll() {
        when(marcaRepository.findAll()).thenReturn(List.of(marcaEjemplo));

        List<Marca> resultado = marcaService.findAll();

        assertNotNull(resultado);
        assertEquals(1, resultado.size());
        assertEquals("Toyota", resultado.get(0).getNombre());
        verify(marcaRepository, times(1)).findAll();
    }

    @Test
    @DisplayName("Debe buscar marca por ID existente")
    void testFindById_Existe() {
        when(marcaRepository.findById(1L)).thenReturn(Optional.of(marcaEjemplo));

        Optional<Marca> resultado = marcaService.findById(1L);

        assertTrue(resultado.isPresent());
        assertEquals("Toyota", resultado.get().getNombre());
    }

    @Test
    @DisplayName("Debe crear una marca cuando el nombre no está duplicado")
    void testCreate_Exitoso() {
        Marca nueva = new Marca(null, "Cupra", "España");
        when(marcaRepository.existsByNombre("Cupra")).thenReturn(false);
        when(marcaRepository.save(any(Marca.class))).thenAnswer(inv -> {
            Marca m = inv.getArgument(0);
            m.setId(2L);
            return m;
        });

        Marca creada = marcaService.create(nueva);

        assertNotNull(creada.getId());
        assertEquals("Cupra", creada.getNombre());
        verify(marcaRepository, times(1)).save(nueva);
    }

    @Test
    @DisplayName("Debe lanzar DuplicateResourceException si el nombre de marca ya existe")
    void testCreate_Duplicada() {
        Marca nueva = new Marca(null, "Toyota", "Japón");
        when(marcaRepository.existsByNombre("Toyota")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> marcaService.create(nueva));
        verify(marcaRepository, never()).save(any(Marca.class));
    }

    @Test
    @DisplayName("Debe actualizar una marca existente")
    void testUpdate_Exitoso() {
        Marca modificaciones = new Marca(null, "Toyota Motor Corp", "Japón");
        when(marcaRepository.findById(1L)).thenReturn(Optional.of(marcaEjemplo));
        when(marcaRepository.findByNombreIgnoreCase("Toyota Motor Corp")).thenReturn(Optional.empty());
        when(marcaRepository.save(any(Marca.class))).thenReturn(marcaEjemplo);

        Marca actualizada = marcaService.update(1L, modificaciones);

        assertNotNull(actualizada);
        assertEquals("Toyota Motor Corp", actualizada.getNombre());
        verify(marcaRepository, times(1)).save(marcaEjemplo);
    }

    @Test
    @DisplayName("Debe eliminar una marca existente por ID")
    void testDelete_Exitoso() {
        when(marcaRepository.existsById(1L)).thenReturn(true);
        doNothing().when(marcaRepository).deleteById(1L);

        boolean resultado = marcaService.deleteById(1L);

        assertTrue(resultado);
        verify(marcaRepository, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException si la marca a eliminar no existe")
    void testDelete_NoExiste() {
        when(marcaRepository.existsById(999L)).thenReturn(false);

        assertThrows(ResourceNotFoundException.class, () -> marcaService.deleteById(999L));
        verify(marcaRepository, never()).deleteById(anyLong());
    }
}
