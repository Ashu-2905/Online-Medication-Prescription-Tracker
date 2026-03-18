📄 Online Medication & Prescription Tracker
Project Documentation
1. Introduction

The Online Medication & Prescription Tracker is a full-stack web application designed to simplify medication management for patients and improve communication between doctors and patients. The system provides a centralized platform where users can manage prescriptions, track medications, and request refills digitally.

2. Objectives

To help patients track their medications and schedules

To enable doctors to manage prescriptions efficiently

To reduce manual errors and delays in medication management

To provide a secure and centralized healthcare system

3. System Overview

The system connects three main users:

Admin – Manages the system and users

Doctor – Prescribes medicines and monitors patients

Patient – Tracks medications and requests refills

The platform ensures smooth communication and data sharing between all users.

4. Technology Stack
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

LLaMA Model

Groq API

Database

MongoDB

Tools

VS Code

Git & GitHub

Postman

5. Key Features
5.1 Secure Authentication

JWT-based login system

Role-based access control

5.2 Medication Tracking

Track daily medicine schedules

View dosage and treatment progress

5.3 Prescription Management

Doctors create and update prescriptions

Patients access prescription history

5.4 Refill Requests

Patients request refills online

Doctors approve or reject requests

5.5 AI Chatbot

Answers queries related to medicines and symptoms

Provides intelligent responses using AI

6. System Workflow

The system workflow starts with user registration, where users create an account by selecting their role. After registration, users log in through authentication, which securely verifies their credentials. Once logged in, users manage their profile information. Patients can then track their medications and schedules, while doctors prescribe medicines by adding prescription details for patients.

7. Database Design

The system uses MongoDB with the following collections:

Users – Stores user details and roles

Medications – Contains medicine and dosage information

Prescriptions – Links doctors, patients, and medications

Refill Requests – Tracks refill processes

8. API Structure

The backend provides REST APIs such as:

POST /api/auth/login – User login

GET /api/medications – Fetch medications

POST /api/prescriptions – Create prescription

PUT /api/refills/{id} – Approve refill request

9. System Architecture

The system follows a three-layer architecture:

Frontend Layer – User interface built with React

Backend Layer – Business logic using Spring Boot

Database Layer – Data storage using MongoDB

10. Challenges and Solutions
Challenge: Medication Adherence

Patients forget to take medicines on time
Solution: Digital reminders and tracking system

Challenge: Prescription Management

Difficult for doctors to monitor patients
Solution: Centralized platform for real-time updates

Challenge: Refill Coordination

Manual refill process causes delays
Solution: Online refill request system

11. Future Enhancements

Mobile application development

Integration with pharmacy systems

Wearable device integration

AI-based personalized reminders

Advanced analytics dashboard

12. Conclusion

The Online Medication & Prescription Tracker provides an efficient and secure solution for managing medications digitally. It improves patient adherence, simplifies prescription handling, and enhances communication between healthcare stakeholders.

13. Acknowledgement

We would like to thank Infosys Springboard and our mentor for their guidance and support. We also appreciate the efforts of all team members in successfully completing this project.



