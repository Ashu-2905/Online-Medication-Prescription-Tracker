Online Medication & Prescription Tracker
Overview

The Online Medication & Prescription Tracker is a full-stack healthcare management system designed to help patients, doctors, and administrators manage medications and prescriptions efficiently. The platform allows doctors to prescribe medicines digitally, patients to track their medication schedules, and administrators to manage system operations.

The goal of this project is to improve medication adherence, simplify prescription management, and provide a centralized system for healthcare communication.

Features
Secure Authentication

JWT-based login and authentication system

Role-based access for Admin, Doctor, and Patient

Medication Tracking

Patients can track their daily medication schedules

View dosage instructions and treatment progress

Prescription Management

Doctors can create, update, and manage prescriptions for patients

Patients can view their prescription history

Refill Requests

Patients can request prescription refills

Doctors can approve or reject refill requests

AI Chatbot Support

AI-powered chatbot to answer queries related to medicines and symptoms

Uses LLaMA model integrated through Groq API

Technology Stack
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

System Architecture

The application follows a full-stack architecture consisting of three main layers:

Frontend: React-based user interface for patients, doctors, and admins

Backend: Spring Boot server that handles business logic and REST APIs

Database: MongoDB for storing users, medications, prescriptions, and refill records

Workflow

Register – Users register as a patient, doctor, or admin.

Authenticate – Users log in securely using JWT authentication.

Profile – Users manage their personal or professional information.

Track – Patients track medications and treatment schedules.

Prescribe – Doctors create and manage prescriptions for patients.

Project Structure
Online-Medication-Prescription-Tracker
│
├── backend/        # Spring Boot backend application
├── frontend/       # React frontend application
├── docs/           # Project documentation
├── README.md
└── .gitignore

Future Enhancements

Mobile application for easier access

Integration with pharmacy systems and hospital records

Wearable device integration for health monitoring

Advanced analytics dashboard for treatment insights

AI-driven personalized medication reminders

## Setup Instructions

1. Create a Groq API key from Groq dashboard
2. Set environment variable:

   GROQ_API_KEY=your_api_key_here

3. Run the backend application


Acknowledgement

We would like to thank Infosys Springboard for providing this learning opportunity and platform. Special thanks to our mentor for their guidance and support throughout the project. We also appreciate the teamwork and collaboration of all team members who contributed to the successful development of this project.

Authors

Ashu
