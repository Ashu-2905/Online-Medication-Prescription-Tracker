package com.medtracker.controller;

import com.medtracker.dto.ApiResponse;
import com.medtracker.model.Reminder;
import com.medtracker.service.ReminderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/reminders")
@CrossOrigin(origins = {"http://localhost:5173", "http://localhost:3000", "http://localhost:5174"})
public class ReminderController {
    
    @Autowired
    private ReminderService reminderService;
    
    @GetMapping
    public ResponseEntity<ApiResponse<List<Reminder>>> getAllReminders() {
        List<Reminder> reminders = reminderService.getAllReminders();
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }
    
    @GetMapping("/patient/{patientId}")
    public ResponseEntity<ApiResponse<List<Reminder>>> getRemindersByPatientId(@PathVariable String patientId) {
        List<Reminder> reminders = reminderService.getRemindersByPatientId(patientId);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }
    
    @GetMapping("/patient/{patientId}/upcoming")
    public ResponseEntity<ApiResponse<List<Reminder>>> getUpcomingReminders(@PathVariable String patientId) {
        List<Reminder> reminders = reminderService.getUpcomingReminders(patientId);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }
    
    @GetMapping("/patient/{patientId}/today")
    public ResponseEntity<ApiResponse<List<Reminder>>> getTodaysReminders(@PathVariable String patientId) {
        List<Reminder> reminders = reminderService.getTodaysReminders(patientId);
        return ResponseEntity.ok(ApiResponse.success(reminders));
    }
    
    @PostMapping
    public ResponseEntity<ApiResponse<Reminder>> createReminder(@RequestBody Reminder reminder) {
        try {
            Reminder savedReminder = reminderService.createReminder(reminder);
            return ResponseEntity.ok(ApiResponse.success(savedReminder));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Failed to create reminder: " + e.getMessage()));
        }
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Reminder>> updateReminder(@PathVariable String id, @RequestBody Reminder reminder) {
        try {
            Reminder updatedReminder = reminderService.updateReminder(id, reminder);
            return ResponseEntity.ok(ApiResponse.success(updatedReminder));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Failed to update reminder: " + e.getMessage()));
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<String>> deleteReminder(@PathVariable String id) {
        try {
            reminderService.deleteReminder(id);
            return ResponseEntity.ok(ApiResponse.success("Reminder deleted successfully"));
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Failed to delete reminder: " + e.getMessage()));
        }
    }
    
    @PostMapping("/{id}/mark-taken")
    public ResponseEntity<ApiResponse<Reminder>> markAsTaken(@PathVariable String id) {
        try {
            Reminder reminder = reminderService.getReminderById(id).orElse(null);
            if (reminder != null) {
                reminder.setActive(false);
                reminder.setUpdatedAt(LocalDateTime.now());
                Reminder updatedReminder = reminderService.updateReminder(id, reminder);
                return ResponseEntity.ok(ApiResponse.success(updatedReminder));
            } else {
                return ResponseEntity.status(404)
                        .body(ApiResponse.error("Reminder not found"));
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error("Failed to mark reminder as taken: " + e.getMessage()));
        }
    }
}
