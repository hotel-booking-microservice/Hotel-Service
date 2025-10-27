package com.hbs.hotel.service;

import com.hbs.hotel.dto.HotelRequest;
import com.hbs.hotel.exception.NotFoundException;
import com.hbs.hotel.model.Hotel;
import com.hbs.hotel.repository.HotelRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class HotelService {

    private final HotelRepository hotelRepository;

    public HotelService(HotelRepository hotelRepository) {
        this.hotelRepository = hotelRepository;
    }

    public Hotel create(HotelRequest request) {
        Hotel hotel = Hotel.builder()
                .name(request.getName())
                .description(request.getDescription())
                .city(request.getCity())
                .country(request.getCountry())
                .build();
        return hotelRepository.save(hotel);
    }

    public List<Hotel> list() {
        return hotelRepository.findAll();
    }

    public Hotel getById(String id) {
        return hotelRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Hotel with id " + id + " not found"));
    }

    public Hotel update(String id, HotelRequest request) {
        Hotel existing = getById(id);
        existing.setName(request.getName());
        existing.setDescription(request.getDescription());
        existing.setCity(request.getCity());
        existing.setCountry(request.getCountry());
        return hotelRepository.save(existing);
    }

    public void delete(String id) {
        if (!hotelRepository.existsById(id)) {
            throw new NotFoundException("Hotel with id " + id + " not found");
        }
        hotelRepository.deleteById(id);
    }
}
