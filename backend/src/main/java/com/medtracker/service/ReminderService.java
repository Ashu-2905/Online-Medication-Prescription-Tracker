package com.medtracker.service;

import com.medtracker.model.Reminder;
import com.medtracker.repository.ReminderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ReminderService {
    
    @Autowired
    private ReminderRepository reminderRepository;
    
    public List<Reminder> getAllReminders() {
        return reminderRepository.findAll();
    }
    
    public List<Reminder> getRemindersByPatientId(String patientId) {
        return reminderRepository.findByPatientIdAndIsActive(patientId, true);
    }
    
    public Optional<Reminder> getReminderById(String id) {
        return reminderRepository.findById(id);
    }
    
    public Reminder createReminder(Reminder reminder) {
        reminder.setUpdatedAt(LocalDateTime.now());
        return reminderRepository.save(reminder);
    }
    
    public Reminder updateReminder(String id, Reminder reminder) {
        reminder.setId(id);
        reminder.setUpdatedAt(LocalDateTime.now());
        return reminderRepository.save(reminder);
    }
    
    public void deleteReminder(String id) {
        reminderRepository.deleteById(id);
    }
    
    public List<Reminder> getUpcomingReminders(String patientId) {
        return reminderRepository.findByPatientIdAndReminderTimeBefore(patientId, LocalDateTime.now());
    }
    
    public List<Reminder> getTodaysReminders(String patientId) {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startOfDay = now.toLocalDate().atStartOfDay();
        LocalDateTime endOfDay = now.toLocalDate().atTime(23, 59, 59);
        
        return reminderRepository.findByPatientIdAndReminderTimeBefore(patientId, endOfDay)
                .stream()
                .filter(reminder -> reminder.getReminderTime().isAfter(startOfDay) && 
                               reminder.getReminderTime().isBefore(endOfDay))
                .toList();
    }
}
