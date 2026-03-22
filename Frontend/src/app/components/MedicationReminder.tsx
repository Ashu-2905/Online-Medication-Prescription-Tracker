import React, { useState, useEffect } from 'react';
import { Bell, Plus, Clock, X, Check, Calendar } from 'lucide-react';

interface Reminder {
  id: string;
  patientId: string;
  medicineName: string;
  reminderTime: string;
  note: string;
  isActive: boolean;
  createdAt: string;
  updatedAt: string;
}

const MedicationReminder: React.FC = () => {
  const [reminders, setReminders] = useState<Reminder[]>([]);
  const [showAddForm, setShowAddForm] = useState(false);
  const [editingReminder, setEditingReminder] = useState<Reminder | null>(null);
  const [currentTime, setCurrentTime] = useState(new Date().toLocaleTimeString());
  const [formData, setFormData] = useState({
    medicineName: '',
    reminderDate: '',
    reminderTime: '',
    reminderPeriod: 'AM',
    note: ''
  });

  useEffect(() => {
    fetchReminders();
    checkReminders();
    
    // Make functions globally available for alert buttons
    (window as any).markReminderAsTaken = markAsTaken;
    (window as any).snoozeReminder = snooze;
    (window as any).editReminder = editReminder;
    (window as any).deleteReminderFunc = deleteReminderFunc;
    
    // Update current time every second
    const timeInterval = setInterval(() => {
      setCurrentTime(new Date().toLocaleTimeString());
    }, 1000);
    
    return () => {
      clearInterval(timeInterval);
    };
  }, []);

  const fetchReminders = async () => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch('http://localhost:8080/api/reminders', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        setReminders(data.data || []);
      } else {
        // Use local storage fallback when backend is not available
        const storedReminders = localStorage.getItem('medicationReminders');
        if (storedReminders) {
          setReminders(JSON.parse(storedReminders));
        }
      }
    } catch (error) {
      console.error('Failed to fetch reminders, using local storage:', error);
      // Use local storage fallback
      const storedReminders = localStorage.getItem('medicationReminders');
      if (storedReminders) {
        setReminders(JSON.parse(storedReminders));
      }
    }
  };

  const checkReminders = () => {
    const checkInterval = setInterval(() => {
      const now = new Date();
      const currentTime = now.getHours() * 60 + now.getMinutes(); // Current time in minutes
      const currentDate = now.toDateString();
      
      reminders.forEach(reminder => {
        if (reminder.isActive) {
          const reminderDateTime = new Date(reminder.reminderTime);
          const reminderTime = reminderDateTime.getHours() * 60 + reminderDateTime.getMinutes(); // Reminder time in minutes
          
          // Check if reminder time is current time (within 1 minute window)
          const timeDiff = Math.abs(currentTime - reminderTime);
          
          // Also check if we're on the same date
          const sameDate = currentDate === reminderDateTime.toDateString();
          
          if (sameDate && timeDiff <= 1) {
            console.log(`Triggering reminder for ${reminder.medicineName} at ${now.toLocaleTimeString()}`);
            showReminderAlert(reminder);
            // Mark as shown to prevent duplicate notifications
            reminder.isActive = false;
            // Update local storage
            const updatedReminders = reminders.map(r => 
              r.id === reminder.id ? { ...r, isActive: false } : r
            );
            setReminders(updatedReminders);
            localStorage.setItem('medicationReminders', JSON.stringify(updatedReminders));
          }
        }
      });
    }, 5000); // Check every 5 seconds for better accuracy

    return () => clearInterval(checkInterval);
  };

  const showReminderAlert = (reminder: Reminder) => {
    // Create alert container if it doesn't exist
    let alertContainer = document.getElementById('reminder-alert-container');
    if (!alertContainer) {
      alertContainer = document.createElement('div');
      alertContainer.id = 'reminder-alert-container';
      document.body.appendChild(alertContainer);
    }

    const alertId = `alert-${reminder.id}`;
    const alertDiv = document.createElement('div');
    alertDiv.id = alertId;
    alertDiv.className = 'fixed top-4 right-4 bg-blue-600 text-white p-4 rounded-lg shadow-xl z-50 max-w-sm';
    alertDiv.innerHTML = `
      <div class="flex items-center justify-between mb-2">
        <h3 class="text-lg font-semibold">Medication Reminder</h3>
        <button onclick="document.getElementById('${alertId}').remove()" class="text-white hover:text-gray-200">
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
          </svg>
        </button>
      </div>
      <div class="flex items-center gap-2 mb-3">
        <svg class="w-6 h-6 text-yellow-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-5 5v-5z"></path>
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <div>
          <p class="font-medium">Time to take your medicine</p>
          <p class="text-xl font-bold">${reminder.medicineName}</p>
        </div>
      </div>
      <p class="text-sm mb-4">${reminder.note || 'Take your medication as scheduled'}</p>
      <div class="flex gap-2 flex-wrap">
        <button onclick="window.markReminderAsTaken('${reminder.id}')" class="bg-green-500 hover:bg-green-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm">
          <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
          </svg>
          Mark as Taken
        </button>
        <button onclick="window.snoozeReminder('${reminder.id}', 10)" class="bg-gray-500 hover:bg-gray-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm">
          <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
          </svg>
          Snooze 10 min
        </button>
        <button onclick="window.editReminder('${reminder.id}')" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm">
          <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-11a2 2 0 00-2-2z"></path>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l4-4m0 0l-4 4"></path>
          </svg>
          Edit
        </button>
        <button onclick="window.deleteReminderFunc('${reminder.id}')" class="bg-red-500 hover:bg-red-600 text-white px-3 py-2 rounded-lg font-medium transition-colors text-sm">
          <svg class="w-4 h-4 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m0 0v6m5-4v6"></path>
          </svg>
          Delete
        </button>
      </div>
    `;
    
    alertContainer.appendChild(alertDiv);
    
    // Auto-remove after 30 seconds
    setTimeout(() => {
      const alert = document.getElementById(alertId);
      if (alert) {
        alert.remove();
      }
    }, 30000);
  };

  const markAsTaken = async (reminderId: string) => {
    try {
      // First try backend, then fallback to local storage
      const token = localStorage.getItem('token');
      let success = false;
      
      if (token) {
        try {
          const response = await fetch(`http://localhost:8080/api/reminders/${reminderId}/mark-taken`, {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${token}`,
              'Content-Type': 'application/json',
            },
          });

          if (response.ok) {
            success = true;
          }
        } catch (backendError) {
          console.log('Backend not available, using local storage');
        }
      }

      if (success || !token) {
        // Update local storage directly
        const updatedReminders = reminders.map(r => 
          r.id === reminderId ? { ...r, isActive: false, updatedAt: new Date().toISOString() } : r
        );
        setReminders(updatedReminders);
        localStorage.setItem('medicationReminders', JSON.stringify(updatedReminders));
      }

      // Remove alert if exists
      const alertElement = document.getElementById(`alert-${reminderId}`);
      if (alertElement) {
        alertElement.remove();
      }

      // Show success message
      window.alert('Medication marked as taken successfully!');
    } catch (error) {
      console.error('Failed to mark reminder as taken:', error);
      window.alert('Failed to mark medication as taken. Please try again.');
    }
  };

  const snooze = async (reminderId: string, minutes: number) => {
    const reminder = reminders.find(r => r.id === reminderId);
    if (reminder) {
      const newTime = new Date(new Date(reminder.reminderTime).getTime() + minutes * 60000);
      
      // Remove the current alert
      const alertElement = document.getElementById(`alert-${reminderId}`);
      if (alertElement) {
        alertElement.remove();
      }
      
      // Update reminder with new time
      const updatedReminder = {
        ...reminder,
        reminderTime: newTime.toISOString(),
        updatedAt: new Date().toISOString()
      };
      
      const updatedReminders = reminders.map(r => r.id === reminderId ? updatedReminder : r);
      setReminders(updatedReminders);
      localStorage.setItem('medicationReminders', JSON.stringify(updatedReminders));
      
      // Show snooze confirmation
      window.alert(`Reminder snoozed for ${minutes} minutes`);
    }
  };

  const deleteReminderFunc = async (reminderId: string) => {
    if (window.confirm('Are you sure you want to delete this reminder?')) {
      // Remove the current alert
      const alertElement = document.getElementById(`alert-${reminderId}`);
      if (alertElement) {
        alertElement.remove();
      }
      
      // Update local storage
      const updatedReminders = reminders.filter(r => r.id !== reminderId);
      setReminders(updatedReminders);
      localStorage.setItem('medicationReminders', JSON.stringify(updatedReminders));
      
      // Show success message
      window.alert('Reminder deleted successfully!');
    }
  };

  const editReminder = async (reminderId: string) => {
    const reminder = reminders.find(r => r.id === reminderId);
    if (reminder) {
      // Remove the current alert
      const alertElement = document.getElementById(`alert-${reminderId}`);
      if (alertElement) {
        alertElement.remove();
      }
      
      // Convert reminder time for form
      const reminderDateTime = new Date(reminder.reminderTime);
      const time = reminderDateTime.toTimeString().slice(0, 5); // HH:MM format
      const period = reminderDateTime.getHours() >= 12 ? 'PM' : 'AM';
      
      // Set form data for editing
      setFormData({
        medicineName: reminder.medicineName,
        reminderDate: reminderDateTime.toISOString().split('T')[0],
        reminderTime: time,
        reminderPeriod: period,
        note: reminder.note
      });
      setEditingReminder(reminder);
      setShowAddForm(true);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    try {
      const token = localStorage.getItem('token');
      
      // Combine date and time to create datetime
      let reminderDateTime = `${formData.reminderDate}T${formData.reminderTime}:00`;
      
      // Handle AM/PM conversion
      if (formData.reminderPeriod === 'PM' && formData.reminderTime) {
        const [hours, minutes] = formData.reminderTime.split(':');
        let hour24 = parseInt(hours);
        if (hour24 !== 12) { // Convert 1-11 PM to 13-23
          hour24 += 12;
        }
        reminderDateTime = `${formData.reminderDate}T${hour24.toString().padStart(2, '0')}:${minutes}:00`;
      } else if (formData.reminderPeriod === 'AM' && formData.reminderTime) {
        const [hours, minutes] = formData.reminderTime.split(':');
        let hour24 = parseInt(hours);
        if (hour24 === 12) { // Convert 12 AM to 0
          hour24 = 0;
        }
        reminderDateTime = `${formData.reminderDate}T${hour24.toString().padStart(2, '0')}:${minutes}:00`;
      }
      
      const reminderData = {
        medicineName: formData.medicineName,
        reminderTime: reminderDateTime,
        note: formData.note,
        patientId: 'current-patient', // This should come from auth context
      };

      const url = editingReminder 
        ? `http://localhost:8080/api/reminders/${editingReminder.id}`
        : 'http://localhost:8080/api/reminders';
      
      const method = editingReminder ? 'PUT' : 'POST';
      
      const response = await fetch(url, {
        method,
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(reminderData),
      });

      if (response.ok) {
        const savedReminder = await response.json();
        
        if (editingReminder) {
          setReminders(prev => prev.map(r => 
            r.id === editingReminder.id ? savedReminder.data : r
          ));
        } else {
          setReminders(prev => [...prev, savedReminder.data]);
        }

        // Update local storage
        localStorage.setItem('medicationReminders', JSON.stringify(reminders));

        // Reset form
        setFormData({ medicineName: '', reminderDate: '', reminderTime: '', reminderPeriod: 'AM', note: '' });
        setEditingReminder(null);
        setShowAddForm(false);
        
        // Show success message
        window.alert(editingReminder ? 'Reminder updated successfully!' : 'Reminder added successfully!');
      } else {
        throw new Error('Backend not available');
      }
    } catch (error) {
      console.error('Failed to save reminder to backend, using local storage:', error);
      
      // Fallback to local storage
      const newReminder = {
        id: editingReminder ? editingReminder.id : Date.now().toString(),
        medicineName: formData.medicineName,
        reminderTime: `${formData.reminderDate}T${formData.reminderTime}:00`,
        note: formData.note,
        patientId: 'current-patient',
        isActive: true,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };

      let updatedReminders;
      if (editingReminder) {
        updatedReminders = reminders.map(r => r.id === editingReminder.id ? newReminder : r);
      } else {
        updatedReminders = [...reminders, newReminder];
      }

      setReminders(updatedReminders);
      localStorage.setItem('medicationReminders', JSON.stringify(updatedReminders));

      // Reset form
      setFormData({ medicineName: '', reminderDate: '', reminderTime: '', reminderPeriod: 'AM', note: '' });
      setEditingReminder(null);
      setShowAddForm(false);
      
      // Show success message
      window.alert(editingReminder ? 'Reminder updated successfully (saved locally)!' : 'Reminder added successfully (saved locally)!');
    }
  };

  const updateReminder = async (id: string, updates: Partial<Reminder>) => {
    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`http://localhost:8080/api/reminders/${id}`, {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updates),
      });

      if (response.ok) {
        const updatedReminder = await response.json();
        setReminders(prev => prev.map(r => 
          r.id === id ? updatedReminder.data : r
        ));
      }
    } catch (error) {
      console.error('Failed to update reminder:', error);
    }
  };

  const deleteReminder = async (id: string) => {
    try {
      const token = localStorage.getItem('token');
      await fetch(`http://localhost:8080/api/reminders/${id}`, {
        method: 'DELETE',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      setReminders(prev => prev.filter(r => r.id !== id));
    } catch (error) {
      console.error('Failed to delete reminder:', error);
    }
  };

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-2">
            <Bell className="w-6 h-6 text-blue-600" />
            <h2 className="text-lg font-semibold text-gray-900">Medication Reminders</h2>
            <span className="text-sm text-gray-500">Current Time: {currentTime}</span>
          </div>
          <div className="flex gap-2">
            <button
              onClick={() => {
                const testReminder = {
                  id: 'test-' + Date.now(),
                  patientId: 'test',
                  medicineName: 'Test Medicine',
                  reminderTime: new Date().toISOString(),
                  note: 'Test notification',
                  isActive: true,
                  createdAt: new Date().toISOString(),
                  updatedAt: new Date().toISOString()
                };
                // Add test reminder to the array so markAsTaken can find it
                setReminders(prev => [...prev, testReminder]);
                showReminderAlert(testReminder);
              }}
              className="bg-yellow-600 hover:bg-yellow-700 text-white px-4 py-2 rounded-lg font-medium transition-colors text-sm"
            >
              Test Notification
            </button>
            <button
              onClick={() => setShowAddForm(true)}
              className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors"
            >
              <Plus className="w-4 h-4 inline mr-2" />
              Add Reminder
            </button>
          </div>
        </div>

        {/* Add/Edit Form */}
        {showAddForm && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
            <div className="bg-white rounded-xl p-6 w-full max-w-md">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-semibold">
                  {editingReminder ? 'Edit Reminder' : 'Add Reminder'}
                </h3>
                <button
                  onClick={() => {
                    setShowAddForm(false);
                    setEditingReminder(null);
                    setFormData({ medicineName: '', reminderDate: '', reminderTime: '', reminderPeriod: 'AM', note: '' });
                  }}
                  className="text-gray-400 hover:text-gray-600"
                >
                  <X className="w-5 h-5" />
                </button>
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Medicine Name
                  </label>
                  <input
                    type="text"
                    required
                    value={formData.medicineName}
                    onChange={(e) => setFormData(prev => ({ ...prev, medicineName: e.target.value }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="e.g., Paracetamol"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Reminder Date
                  </label>
                  <input
                    type="date"
                    required
                    value={formData.reminderDate}
                    onChange={(e) => setFormData(prev => ({ ...prev, reminderDate: e.target.value }))}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    min={new Date().toISOString().split('T')[0]}
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Reminder Time
                  </label>
                  <div className="flex gap-2">
                    <input
                      type="time"
                      required
                      value={formData.reminderTime}
                      onChange={(e) => setFormData(prev => ({ ...prev, reminderTime: e.target.value }))}
                      className="flex-1 px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    />
                    <select
                      value={formData.reminderPeriod}
                      onChange={(e) => setFormData(prev => ({ ...prev, reminderPeriod: e.target.value }))}
                      className="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    >
                      <option value="AM">AM</option>
                      <option value="PM">PM</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Note (optional)
                  </label>
                  <textarea
                    value={formData.note}
                    onChange={(e) => setFormData(prev => ({ ...prev, note: e.target.value }))}
                    rows={3}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="e.g., Take with food"
                  />
                </div>

                <div className="flex gap-2">
                  <button
                    type="submit"
                    className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors"
                  >
                    {editingReminder ? 'Update Reminder' : 'Add Reminder'}
                  </button>
                  <button
                    type="button"
                    onClick={() => {
                      setShowAddForm(false);
                      setEditingReminder(null);
                      setFormData({ medicineName: '', reminderDate: '', reminderTime: '', reminderPeriod: 'AM', note: '' });
                    }}
                    className="bg-gray-300 hover:bg-gray-400 text-gray-800 px-4 py-2 rounded-lg font-medium transition-colors"
                  >
                    Cancel
                  </button>
                </div>
              </form>
            </div>
          </div>
        )}

        {/* Reminders List */}
        <div className="space-y-3">
          {reminders.length === 0 ? (
            <div className="text-center py-8">
              <Calendar className="w-12 h-12 text-gray-400 mx-auto" />
              <p className="text-gray-600 mt-2">No reminders set</p>
              <p className="text-sm text-gray-500">Add your first medication reminder to get started</p>
            </div>
          ) : (
            reminders.map((reminder) => (
              <div
                key={reminder.id}
                className={`flex items-center justify-between p-4 rounded-lg border-2 ${
                  reminder.isActive
                    ? 'bg-green-50 border-green-200'
                    : 'bg-gray-50 border-gray-200'
                }`}
              >
                <div className="flex items-center gap-3">
                  <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                    reminder.isActive ? 'bg-blue-600' : 'bg-gray-400'
                  }`}>
                    <Clock className="w-5 h-5 text-white" />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">{reminder.medicineName}</p>
                    <p className="text-sm text-gray-600">{new Date(reminder.reminderTime).toLocaleString()}</p>
                    {reminder.note && (
                      <p className="text-sm text-gray-500 mt-1">{reminder.note}</p>
                    )}
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <button
                    onClick={() => setEditingReminder(reminder)}
                    className="text-blue-600 hover:text-blue-800 font-medium text-sm"
                  >
                    Edit
                  </button>
                  <button
                    onClick={() => deleteReminder(reminder.id)}
                    className="text-red-600 hover:text-red-800 font-medium text-sm"
                  >
                    Delete
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

export default MedicationReminder;
