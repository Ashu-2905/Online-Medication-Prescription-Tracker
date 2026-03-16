package com.medtracker.repository;

import com.medtracker.model.Reminder;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReminderRepository extends MongoRepository<Reminder, String> {
    List<Reminder> findByPatientId(String patientId);
    List<Reminder> findByPatientIdAndIsActive(String patientId, boolean isActive);
    List<Reminder> findByPatientIdAndReminderTimeBefore(String patientId, LocalDateTime time);
    void deleteById(String id);
}
