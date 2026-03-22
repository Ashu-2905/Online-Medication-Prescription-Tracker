# 📁 Complete Project Structure Documentation

## 🏗️ **Project Overview**
This is a full-stack Medication and Prescription Tracker web application with React frontend and Java Spring Boot backend.

---

## 📂 **Root Directory Structure**

```
Medication and Prescription Tracker (3) (1)/
├── .vscode/                              # VS Code configuration
├── backend/                               # Java Spring Boot backend
├── Medication and Prescription Tracker (1)/   # React TypeScript frontend
└── (various documentation files)
```

---

## 🚀 **Backend Structure** (`backend/`)

### **Root Files**
- `pom.xml` - Maven configuration and dependencies
- `README.md` - Backend documentation
- `API_DOCUMENTATION.md` - Complete API endpoints documentation
- `FINAL_SOLUTION.md` - Implementation summary
- `PRODUCTION_DEPLOYMENT_GUIDE.md` - Deployment instructions
- `Postman_Collection.json` - API testing collection
- `run-backend.bat` - Backend startup script
- `start-backend-final.bat` - Production startup script
- `test-all-apis.ps1` - API testing PowerShell script
- `test-groq.ps1` - Groq API testing script

### **Source Code** (`src/main/java/com/medtracker/`)

#### **🎯 Main Application**
- `MedicationTrackerApplication.java` - Spring Boot main class

#### **⚙️ Configuration** (`config/`)
- `SecurityConfig.java` - Spring Security configuration
- `CORSConfig.java` - Cross-origin resource sharing

#### **🎮 Controllers** (`controller/`)
- `AdminController.java` - Admin management endpoints
- `AuthController.java` - Authentication & authorization
- `ChatController.java` - AI chatbot endpoints
- `DoctorController.java` - Doctor management
- `PatientController.java` - Patient management
- `PrescriptionController.java` - Prescription CRUD
- `ReminderController.java` - Medication reminders

#### **📦 Data Transfer Objects** (`dto/`)
- `ApiResponse.java` - Standard API response wrapper
- `AppointmentRequest.java` - Appointment booking request
- `LoginRequest.java` - Login credentials
- `RegisterRequest.java` - User registration
- `PrescriptionRequest.java` - Prescription creation

#### **🗃️ Models** (`model/`)
- `User.java` - User entity (Patient/Doctor/Admin)
- `Prescription.java` - Prescription entity
- `Appointment.java` - Appointment booking
- `Reminder.java` - Medication reminder
- `RefillRequest.java` - Prescription refill request

#### **📚 Repositories** (`repository/`)
- `UserRepository.java` - MongoDB user repository
- `PrescriptionRepository.java` - Prescription data access
- `AppointmentRepository.java` - Appointment data access
- `ReminderRepository.java` - Reminder data access
- `RefillRequestRepository.java` - Refill request data access

#### **🔧 Services** (`service/`)
- `UserService.java` - User business logic
- `PrescriptionService.java` - Prescription management
- `AppointmentService.java` - Appointment scheduling
- `ReminderService.java` - Reminder management
- `AiChatService.java` - Groq AI chatbot integration
- `AdminService.java` - Admin operations

#### **🔐 Security** (`security/`)
- `JwtUtil.java` - JWT token utilities
- `JwtAuthenticationFilter.java` - JWT authentication filter

### **Configuration** (`src/main/resources/`)
- `application.properties` - Database, JWT, and Groq API configuration

---

## ⚛️ **Frontend Structure** (`Medication and Prescription Tracker (1)/src/`)

### **🎯 Main Files**
- `main.tsx` - React application entry point
- `App.tsx` - Main app component with routing

#### **🎨 Styles** (`styles/`)
- `index.css` - Global CSS styles
- `App.css` - App-specific styles
- `globals.css` - Tailwind CSS global styles

#### **🎭 Components** (`components/`)
- `MedicationReminder.tsx` - Medication reminder management
- `ChatBot.jsx` - AI chatbot interface
- `ChatBot.css` - Chatbot styling
- `AdminLayout.tsx` - Admin dashboard layout
- `PatientLayout.tsx` - Patient dashboard layout
- `DoctorLayout.tsx` - Doctor dashboard layout

#### **📄 Pages** (`pages/`)

**Patient Pages** (`pages/patient/`)
- `PatientDashboard.tsx` - Main patient dashboard
- `PatientProfile.tsx` - Patient profile management
- `PatientPrescriptions.tsx` - View prescriptions
- `PatientAppointments.tsx` - Book/manage appointments

**Doctor Pages** (`pages/doctor/`)
- `DoctorDashboard.tsx` - Doctor main dashboard
- `DoctorProfile.tsx` - Doctor profile
- `DoctorPrescriptions.tsx` - Manage prescriptions
- `DoctorAppointments.tsx` - View appointments

**Admin Pages** (`pages/admin/`)
- `AdminDashboard.tsx` - Admin main dashboard
- `AdminUsers.tsx` - User management
- `AdminReports.tsx` - System reports
- `AdminSettings.tsx` - System configuration

**Auth Pages** (`pages/auth/`)
- `Login.tsx` - User login
- `Register.tsx` - User registration
- `ForgotPassword.tsx` - Password recovery

#### **🔧 Context** (`context/`)
- `AuthContext.tsx` - Authentication state management
- `ThemeContext.tsx` - Theme management

#### **🛣️ Routing** (`routes.tsx`)
- Route definitions for all pages
- Protected route implementation

---

## 🔌 **Key Features by File**

### **🏥 Patient Features**
- **MedicationReminder.tsx**: Set reminders, get notifications, mark as taken
- **PatientDashboard.tsx**: Overview with charts and quick actions
- **PatientPrescriptions.tsx**: View active and past prescriptions

### **👨‍⚕️ Doctor Features**
- **DoctorPrescriptions.tsx**: Create and manage prescriptions
- **DoctorAppointments.tsx**: View and manage patient appointments

### **⚙️ Admin Features**
- **AdminDashboard.tsx**: System overview, user management, reports
- **AdminSettings.tsx**: Configure system, backup, email settings
- **AdminUsers.tsx**: Add/edit users, manage permissions

### **🤖 AI Features**
- **ChatBot.jsx**: AI-powered medication assistance
- **AiChatService.java**: Groq API integration for intelligent responses

### **🔐 Security Features**
- **AuthController.java**: JWT-based authentication
- **SecurityConfig.java**: Role-based access control
- **JwtUtil.java**: Token generation and validation

---

## 🗄️ **Database Integration**

### **MongoDB Atlas**
- Connection configured in `application.properties`
- Collections: users, prescriptions, appointments, reminders
- Automatic indexing for performance

### **Data Models**
- **User**: id, name, email, password, role, profile info
- **Prescription**: id, patientId, doctorId, medication, dosage, instructions
- **Reminder**: id, patientId, medicineName, reminderTime, note, isActive

---

## 🔧 **Technology Stack**

### **Backend**
- **Java 17+** with Spring Boot 3.x
- **MongoDB Atlas** for data storage
- **Spring Security** for authentication
- **JWT** for token-based auth
- **Groq API** for AI chatbot
- **Maven** for dependency management

### **Frontend**
- **React 18** with TypeScript
- **Vite** for build tooling
- **Tailwind CSS** for styling
- **Lucide React** for icons
- **Recharts** for data visualization
- **React Router** for navigation

---

## 🚀 **Deployment**

### **Development**
- Frontend: `npm run dev` (port 5173)
- Backend: `mvn spring-boot:run` (port 8080)

### **Production Scripts**
- `start-backend-final.bat` - Production backend startup
- `PRODUCTION_DEPLOYMENT_GUIDE.md` - Complete deployment guide

---

## 📊 **API Endpoints Summary**

### **Authentication**
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `POST /api/auth/refresh` - Token refresh

### **Reminders**
- `GET /api/reminders` - Get user reminders
- `POST /api/reminders` - Create reminder
- `PUT /api/reminders/{id}` - Update reminder
- `POST /api/reminders/{id}/mark-taken` - Mark as taken

### **Admin**
- `GET /api/admin/users` - Get all users
- `POST /api/admin/backup` - Create backup
- `PUT /api/admin/settings` - Update settings
- `POST /api/admin/test-email` - Test email config

### **Chatbot**
- `POST /api/chat` - Send message to AI
- `GET /api/chat/health` - Check chat service

---

## 🎯 **Key Business Logic**

### **Reminder System**
- Real-time checking every 10 seconds
- AM/PM time conversion for 24-hour format
- Local storage fallback when backend unavailable
- Popup notifications with "Mark as Taken" and "Snooze" options

### **AI Chatbot**
- Fallback responses when Groq API unavailable
- Medication-specific knowledge base
- Professional medical disclaimers
- Context-aware responses

### **Admin Dashboard**
- Real-time statistics and charts
- User management with role-based access
- System backup and configuration
- Export functionality for reports

---

## 📝 **Recent Improvements**

1. **✅ Fixed duplicate reminder sections**
2. **✅ Added AM/PM time selection**
3. **✅ Fixed "Mark as Taken" button in test notifications**
4. **✅ Improved notification timing accuracy**
5. **✅ Enhanced chatbot with Groq API integration**
6. **✅ Added local storage fallbacks for offline functionality**
7. **✅ Improved error handling and user feedback**

---

## 🔧 **Development Commands**

```bash
# Frontend Development
cd "Medication and Prescription Tracker (1)"
npm install
npm run dev

# Backend Development
cd backend
mvn clean install
mvn spring-boot:run

# Production Deployment
./start-backend-final.bat
```

---

This documentation provides a complete overview of the entire project structure, making it easy to understand the architecture and locate specific functionality.
