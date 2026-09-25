package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Controller.CocheController;
import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Exception.GlobalExceptionHandler;
import com.ironhack.cochesjpa1.Exception.ResourceNotFoundException;
import com.ironhack.cochesjpa1.Service.CocheService;
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
public class CocheControllerTests {

    private MockMvc mockMvc;

    @Mock
    private CocheService cocheService;

    @InjectMocks
    private CocheController cocheController;

    private Coche cocheTest;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(cocheController)
                .setControllerAdvice(new GlobalExceptionHandler())
                .build();
        cocheTest = new Coche(1L, "Audi", "A4", "1122-AUD", 35000.0);
    }

    @Test
    @DisplayName("GET /api/coches -> 200 OK con lista de coches")
    void testGetAllCoches() throws Exception {
        when(cocheService.findAll()).thenReturn(List.of(cocheTest));

        mockMvc.perform(get("/api/coches")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].id").value(1))
                .andExpect(jsonPath("$[0].marca").value("Audi"))
                .andExpect(jsonPath("$[0].matricula").value("1122-AUD"));
    }

    @Test
    @DisplayName("GET /api/coches/{id} -> 200 OK cuando existe")
    void testGetCocheById_Existe() throws Exception {
        when(cocheService.findById(1L)).thenReturn(Optional.of(cocheTest));

        mockMvc.perform(get("/api/coches/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.marca").value("Audi"));
    }

    @Test
    @DisplayName("GET /api/coches/{id} -> 404 Not Found cuando no existe")
    void testGetCocheById_NoExiste() throws Exception {
        when(cocheService.findById(99L)).thenReturn(Optional.empty());

        mockMvc.perform(get("/api/coches/99")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404))
                .andExpect(jsonPath("$.error").value("Not Found"));
    }

    @Test
    @DisplayName("POST /api/coches -> 201 Created al crear nuevo coche")
    void testCreateCoche() throws Exception {
        String inputJson = """
                {
                    "marca": "Audi",
                    "modelo": "A4",
                    "matricula": "1122-AUD",
                    "precio": 35000.0
                }
                """;
        when(cocheService.create(any(Coche.class))).thenReturn(cocheTest);

        mockMvc.perform(post("/api/coches")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(inputJson))
                .andExpect(status().isCreated())
                .andExpect(header().string("Location", "/api/coches/1"))
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.matricula").value("1122-AUD"));
    }

    @Test
    @DisplayName("PUT /api/coches/{id} -> 200 OK al actualizar")
    void testUpdateCoche() throws Exception {
        String updateJson = """
                {
                    "marca": "Audi",
                    "modelo": "A4 Avant",
                    "matricula": "1122-AUD",
                    "precio": 38000.0
                }
                """;
        Coche actualizado = new Coche(1L, "Audi", "A4 Avant", "1122-AUD", 38000.0);
        when(cocheService.update(eq(1L), any(Coche.class))).thenReturn(actualizado);

        mockMvc.perform(put("/api/coches/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(updateJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.modelo").value("A4 Avant"))
                .andExpect(jsonPath("$.precio").value(38000.0));
    }

    @Test
    @DisplayName("DELETE /api/coches/{id} -> 204 No Content al eliminar")
    void testDeleteCoche_Existe() throws Exception {
        when(cocheService.deleteById(1L)).thenReturn(true);

        mockMvc.perform(delete("/api/coches/1"))
                .andExpect(status().isNoContent());

        verify(cocheService, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("DELETE /api/coches/{id} -> 404 Not Found cuando no existe")
    void testDeleteCoche_NoExiste() throws Exception {
        doThrow(new ResourceNotFoundException("Coche no encontrado con ID: 99"))
                .when(cocheService).deleteById(99L);

        mockMvc.perform(delete("/api/coches/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.status").value(404));
    }
}
