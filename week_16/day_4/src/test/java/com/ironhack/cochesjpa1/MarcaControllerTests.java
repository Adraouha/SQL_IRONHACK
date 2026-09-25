package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Controller.MarcaController;
import com.ironhack.cochesjpa1.Entity.Marca;
import com.ironhack.cochesjpa1.Exception.GlobalExceptionHandler;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Service.MarcaService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
public class MarcaControllerTests {

    private MockMvc mockMvc;

    @Mock
    private MarcaService marcaService;

    @InjectMocks
    private MarcaController marcaController;

    private Marca marcaTest;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(marcaController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        marcaTest = new Marca(1L, "Toyota", "Japón");
    }

    @Test
    @DisplayName("GET /api/marcas -> 200 OK con lista de marcas")
    void testGetAllMarcas() throws Exception {
        when(marcaService.findAll()).thenReturn(List.of(marcaTest));

        mockMvc.perform(get("/api/marcas")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].nombre").value("Toyota"));
    }

    @Test
    @DisplayName("GET /api/marcas/{id} -> 200 OK cuando existe")
    void testGetMarcaById_Existe() throws Exception {
        when(marcaService.findById(1L)).thenReturn(Optional.of(marcaTest));

        mockMvc.perform(get("/api/marcas/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.nombre").value("Toyota"));
    }

    @Test
    @DisplayName("GET /api/marcas/{id} -> 404 Not Found cuando no existe")
    void testGetMarcaById_NoExiste() throws Exception {
        when(marcaService.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/marcas/99")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404));
    }

    @Test
    @DisplayName("POST /api/marcas -> 201 Created al crear nueva marca")
    void testCreateMarca() throws Exception {
        String inputJson = """
                {
                    "nombre": "Toyota",
                    "pais": "Japón"
                }
                """;
        when(marcaService.create(any(Marca.class))).thenReturn(marcaTest);

        mockMvc.perform(post("/api/marcas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(inputJson))
                .andExpect(status().isCreated())
                .andExpect(header().string("Location", "/api/marcas/1"))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.nombre").value("Toyota"));
    }

    @Test
    @DisplayName("PUT /api/marcas/{id} -> 200 OK al actualizar")
    void testUpdateMarca() throws Exception {
        String updateJson = """
                {
                    "nombre": "Toyota Motors",
                    "pais": "Japón"
                }
                """;
        Marca actualizada = new Marca(1L, "Toyota Motors", "Japón");
        when(marcaService.update(eq(1L), any(Marca.class))).thenReturn(actualizada);

        mockMvc.perform(put("/api/marcas/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(updateJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.nombre").value("Toyota Motors"));
    }

    @Test
    @DisplayName("DELETE /api/marcas/{id} -> 204 No Content al eliminar")
    void testDeleteMarca_Existe() throws Exception {
        when(marcaService.deleteById(1L)).thenReturn(true);

        mockMvc.perform(delete("/api/marcas/1"))
                .andExpect(status().isNoContent());

        verify(marcaService, times(1)).deleteById(1L);
    }
}
