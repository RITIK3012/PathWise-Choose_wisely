package com.VijayVeer.internal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.web.client.RestTemplate;

import javax.sql.DataSource;

@SpringBootApplication
public class InternalApplication{

	public static void main(String[] args) {
		SpringApplication.run(InternalApplication.class, args);
	}
	
	@Bean
	public RestTemplate restTemplate() {
		return new RestTemplate();
	}
	
	@Bean
	public Boolean executeUpdateScript(DataSource dataSource) {
		try {
			ResourceDatabasePopulator resourceDatabasePopulator = new ResourceDatabasePopulator();
			resourceDatabasePopulator.addScript(new ClassPathResource("db/update-polyline-column.sql"));
			resourceDatabasePopulator.execute(dataSource);
			System.out.println("Successfully executed database column update script");
			return true;
		} catch (Exception e) {
			System.err.println("Error executing database column update script: " + e.getMessage());
			// Don't fail application startup
			return false;
		}
	}
}
