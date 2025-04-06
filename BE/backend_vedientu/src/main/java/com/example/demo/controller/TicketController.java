package com.example.demo.controller;

import com.example.demo.entity.Ticket;
import com.example.demo.entity.User;
import com.example.demo.service.TicketService;
import com.example.demo.service.UserService;
import com.example.demo.config.JwtUtil;
import com.example.demo.dto.TicketRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/user")
public class TicketController {

    @Autowired
    private TicketService ticketService;

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    // ✅ API mua vé
    @PostMapping("/buy-ticket")
public ResponseEntity<?> buyTicket(@RequestHeader("Authorization") String token,
                                   @RequestBody TicketRequest request) {
    String jwt = token.replace("Bearer ", "");
    String email = jwtUtil.extractEmail(jwt);
    User user = userService.findByEmail(email);

    if (user == null) {
        return ResponseEntity.status(404).body("User not found");
    }

    // ✅ Kiểm tra null trước khi gọi toUpperCase()
    if (request.getTicketType() == null || request.getTicketType().isBlank()) {
        return ResponseEntity.status(400).body("Loại vé không được để trống!");
    }

    Ticket.TicketType ticketType;
    try {
        ticketType = Ticket.TicketType.valueOf(request.getTicketType().toUpperCase().trim());
    } catch (IllegalArgumentException e) {
        return ResponseEntity.status(400).body("Loại vé không hợp lệ!");
    }

    Ticket ticket = ticketService.buyTicket(user, ticketType);
    String qrBase64 = ticketService.getTicketQRCode(ticket);

    return ResponseEntity.ok(Map.of(
        "message", "Mua vé thành công!",
        "ticketId", ticket.getId(),
        "qrCode", qrBase64
    ));
}

    
    // ✅ API lấy chi tiết vé + mã QR
    @GetMapping("/tickets/{ticketId}")
    public ResponseEntity<?> getTicketDetails(@RequestHeader("Authorization") String token,
                                              @PathVariable Long ticketId) {
        String jwt = token.replace("Bearer ", "");
        String email = jwtUtil.extractEmail(jwt);
        User user = userService.findByEmail(email);

        if (user == null) {
            return ResponseEntity.status(404).body("User not found");
        }

        Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
        if (ticketOpt.isEmpty()) {
            return ResponseEntity.status(404).body("Vé không tồn tại!");
        }

        Ticket ticket = ticketOpt.get();
        if (!ticket.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(403).body("Bạn không có quyền xem vé này!");
        }

        String qrBase64 = ticketService.getTicketQRCode(ticket);

        return ResponseEntity.ok(Map.of(
            "ticketId", ticket.getId(),
            "ticketType", ticket.getTicketType(),
            "price", ticket.getPrice(),
            "remainingRides", ticket.getRemainingRides(),
            "purchaseDate", ticket.getPurchaseDate(),
            "expiryDate", ticket.getExpiryDate(),
            "qrCode", qrBase64
        ));
    }
    @DeleteMapping("/tickets/{ticketId}")
public ResponseEntity<?> cancelTicket(@RequestHeader("Authorization") String token,
                                      @PathVariable Long ticketId) {
    String jwt = token.replace("Bearer ", "");
    String email = jwtUtil.extractEmail(jwt);
    User user = userService.findByEmail(email);

    if (user == null) {
        return ResponseEntity.status(404).body("Người dùng không tồn tại!");
    }

    Optional<Ticket> ticketOpt = ticketService.getTicketById(ticketId);
    if (ticketOpt.isEmpty()) {
        return ResponseEntity.status(404).body("Vé không tồn tại!");
    }

    Ticket ticket = ticketOpt.get();
    if (!ticket.getUser().getId().equals(user.getId())) {
        return ResponseEntity.status(403).body("Bạn không có quyền hủy vé này!");
    }

    ticketService.deleteTicket(ticketId);
    return ResponseEntity.ok("Vé đã được hủy thành công!");
}

}
