package com.hbs.hotel.config;

import com.hbs.hotel.model.Hotel;
import com.hbs.hotel.repository.HotelRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

@Component
@Profile("dev")
public class DevDataLoader implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DevDataLoader.class);

    private final HotelRepository hotelRepository;

    public DevDataLoader(HotelRepository hotelRepository) {
        this.hotelRepository = hotelRepository;
    }

    @Override
    public void run(String... args) {
        if (hotelRepository.count() == 0) {
            Hotel sample = Hotel.builder()
                    .name("Sample Hotel")
                    .description("Auto-seeded sample hotel for local development")
                    .city("Sample City")
                    .country("Sample Country")
                    .build();
            hotelRepository.save(sample);
            log.info("Inserted sample hotel: {}", sample.getName());
        }
    }
}
