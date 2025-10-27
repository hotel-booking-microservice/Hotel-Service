package com.hbs.hotel.controller;

import com.hbs.hotel.dto.HotelRequest;
import com.hbs.hotel.dto.HotelResponse;
import com.hbs.hotel.model.Hotel;
import com.hbs.hotel.service.HotelService;
import jakarta.validation.Valid;
import java.net.URI;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/hotels")
@Validated
public class HotelController {

    private final HotelService hotelService;

    public HotelController(HotelService hotelService) {
        this.hotelService = hotelService;
    }

    @PostMapping
    public ResponseEntity<HotelResponse> createHotel(@Valid @RequestBody HotelRequest request) {
        Hotel created = hotelService.create(request);
        HotelResponse response = HotelResponse.fromEntity(created);
        return ResponseEntity.created(URI.create("/api/hotels/" + created.getId())).body(response);
    }

    @GetMapping
    public ResponseEntity<List<HotelResponse>> getHotels() {
        List<HotelResponse> responses = hotelService.list().stream()
                .map(HotelResponse::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(responses);
    }

    @GetMapping("/{id}")
    public ResponseEntity<HotelResponse> getHotelById(@PathVariable String id) {
        Hotel hotel = hotelService.getById(id);
        return ResponseEntity.ok(HotelResponse.fromEntity(hotel));
    }

    @PutMapping("/{id}")
    public ResponseEntity<HotelResponse> updateHotel(@PathVariable String id,
                                                     @Valid @RequestBody HotelRequest request) {
        Hotel updated = hotelService.update(id, request);
        return ResponseEntity.ok(HotelResponse.fromEntity(updated));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteHotel(@PathVariable String id) {
        hotelService.delete(id);
        return ResponseEntity.noContent().build();
    }
}
