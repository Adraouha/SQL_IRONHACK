package com.ironhack.cochesjpa1;

import com.ironhack.cochesjpa1.Entity.Coche;
import com.ironhack.cochesjpa1.Repository.CocheRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class Cochesjpa1Application {

	public static void main(String[] args) {
		SpringApplication.run(Cochesjpa1Application.class, args);
	}

	@Bean
	public CommandLineRunner initData(CocheRepository cocheRepository) {
		return args -> {
			if (cocheRepository.count() == 0) {
				cocheRepository.save(new Coche(null, "Seat", "Ibiza", "1234-ABC", 15000.0));
				cocheRepository.save(new Coche(null, "Toyota", "Corolla", "5678-DEF", 22000.0));
				System.out.println(">>> Datos de prueba iniciales insertados en la base de datos MySQL con éxito <<<");
			}
		};
	}

}
