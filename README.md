📄 Online Medication & Prescription Tracker
Project Documentation
1. Project Overview

The Online Medication & Prescription Tracker is a full-stack healthcare management system designed to help patients, doctors, and administrators manage medications and prescriptions efficiently.

The platform enables:

Doctors to prescribe medicines digitally
Patients to track their medication schedules
Administrators to manage system operations

The main goal of this project is to improve medication adherence, simplify prescription management, and provide a centralized healthcare communication system.

2. Problem Statement

In traditional healthcare systems, patients often forget to take medicines, misplace prescriptions, and face delays in refill approvals. Doctors also find it difficult to monitor patient adherence and update treatments efficiently.

To address these issues, a centralized digital system is required to streamline medication tracking, prescription handling, and communication between patients and healthcare providers.

3. Objectives
To develop a secure platform for managing prescriptions
To help patients track medication schedules and dosage
To enable doctors to monitor and update treatments
To automate refill request processes
To integrate AI-based support for user queries
4. Key Features
4.1 Secure Authentication
JWT-based login system
Role-based access control (Admin, Doctor, Patient)
4.2 Medication Tracking
Track daily medication schedules
View dosage and treatment progress
4.3 Prescription Management
Doctors create and manage prescriptions
Patients access prescription history
4.4 Refill Requests
Patients request prescription refills
Doctors approve or reject requests
4.5 AI Chatbot Support
Provides answers related to medicines and symptoms
Integrated using LLaMA model via Groq API
5. Technology Stack
Frontend
React
Vite
Tailwind CSS
React Router
TypeScript
Backend
Java
Spring Boot
REST APIs
LLaMA AI Model
Groq API
Database
MongoDB
Tools
VS Code
Git & GitHub
Postman
6. System Architecture

The application follows a three-layer architecture:

Frontend Layer: React-based user interface
Backend Layer: Spring Boot for business logic and APIs
Database Layer: MongoDB for data storage
7. System Workflow

The workflow begins with user registration, where users sign up as Admin, Doctor, or Patient. After authentication using JWT, users manage their profiles. Patients track medications and schedules, while doctors prescribe and manage treatments. The system ensures smooth interaction between all roles.

8. Database Design

The system uses MongoDB with the following collections:

Users: Stores user details and roles
Medications: Stores medicine and dosage information
Prescriptions: Links doctors, patients, and medications
Refill Requests: Tracks refill approval process
9. API Structure

The backend provides REST APIs such as:

POST /api/auth/register – Register user
POST /api/auth/login – User login
GET /api/medications – Fetch medications
POST /api/prescriptions – Create prescription
PUT /api/refills/{id} – Approve/reject refill
10. Project Structure
Online-Medication-Prescription-Tracker
│
├── backend/        # Spring Boot backend
├── frontend/       # React frontend
├── documentation/  # Project documents
├── README.md
└── .gitignore

11. Future Enhancements
Mobile application development
Integration with pharmacy systems
Wearable device integration
Advanced analytics dashboard
AI-based personalized reminders
12. Setup Instructions
Create a Groq API key
Set environment variable:
GROQ_API_KEY=your_api_key_here

Run backend application
Run frontend application
13. Acknowledgement

We would like to thank Infosys Springboard for providing this opportunity. Special thanks to our mentor for guidance and support. We also appreciate the efforts of all team members who contributed to the successful completion of this project.
