# Pesto AI
![project screen](https://github.com/karim1256/Pesto_AI/blob/main/20251001_1102_AI%20Veterinary%20Care%20App_remix_01k6fcma5ge96bkremw8mmfacp%20(1).png)

🎓 Graduation Project | Faculty of Computer Science – Misr University for Science and Technology (MUST)

🎧 In a fast-paced world, pet owners face challenges:
📌 Difficulty finding specialized vets  
📌 No easy way to diagnose skin conditions  
📌 Paper-based medical records often lost  
📌 Poor communication with vets  

🎯 That’s where **Pesto_AI** comes in – your smart veterinary companion 🐾

📱 **Pesto_AI is a dual-interface mobile app**:  
👨‍⚕️ **Vet Side:** Create a professional profile, record diagnoses, upload lab tests, and manage cases  
🐶 **Pet Owner Side:** Register pets and access two key features:

1️⃣ **AI-Powered Skin Diagnosis**  
Take a photo of a visible skin issue — our model predicts the condition with 97% accuracy and shows probability for each possible disease.

2️⃣ **Book Video Consultations**  
Select a time, get notified, and join a real-time video call. Diagnosis is auto-saved to the pet’s digital medical file.

🗂️ **Profiles for both users** keep medical history organized and accessible anytime.

💳 **Supports local payments** like Vodafone Cash, Masary, plus flexible premium plans.

💡 **Pesto_AI solves real-life problems by:**  
✅ Connecting vets and pet owners faster  
✅ Enabling informed decisions via AI  
✅ Keeping all medical records digital and secure  

🎬 Developed as part of our graduation project to bring AI into practical veterinary care.

---

🙏 **Special thanks to my amazing team:**  
🔹 Youssef Mohamed – AI model for disease classification (deep learning & computer vision)  
🔹 Karim Mamdoh – Flutter mobile app & UI/UX design  
🔹 Mohammed Abbas & Mohamed Ramadan – Backend infrastructure, APIs, database integration  

Proud to work with such a talented and dedicated team!

---

## Features

### For Patients (Pet Owners)
- **Authentication:** Secure sign-up, login, and password reset functionality.
- **Doctor Discovery:** Search for doctors, view detailed profiles including experience, certifications, and patient reviews.
- **Appointment Booking:** View doctor availability and book video consultation sessions.
- **AI Medical Check:** Upload a pet's image to get an AI-based preliminary diagnosis.
- **Video Consultations:** Engage in real-time video calls with doctors powered by Agora.
- **Profile Management:** Manage personal and pet's medical information, including species, breed, and health history.
- **Payment System:** Subscribe to a premium account to unlock full features, with payments handled through an integrated gateway.
- **Schedule Management:** Keep track of upcoming and past appointments.
- **Doctor Reviews:** Rate and review doctors after a session.

### For Doctors
- **Authentication & Onboarding:** Secure registration with a professional information submission process (certificates, experience).
- **Profile Management:** Manage personal and professional information.
- **Availability Management:** Set and update available time slots for appointments.
- **Session Management:** View upcoming booked sessions and patient details.
- **Video Consultations:** Conduct video calls with patients.
- **Post-Session Diagnosis:** Record medical history, diagnosis, and recommendations after each consultation.
- **Patient History:** Access a list of past patients and session details.

## Tech Stack & Architecture

- **Framework:** Flutter
- **Backend & Database:** Supabase (for authentication, database, and storage)
- **State Management:** Flutter BLoC (Cubit)
- **Real-time Communication:** Agora RTC Engine for video calls
- **Payments:** Integrated with Fawaterk payment gateway
- **AI/ML:** The app communicates with a separate Python-based prediction API via HTTP requests to perform image-based diagnosis.
- **Architecture:** The project follows a feature-driven architecture, separating core functionalities into distinct modules for patients, doctors, authentication, and payments.

## Project Structure

The project is organized into logical directories to maintain a clean and scalable codebase.

- `lib/`: Main directory for all Dart code.
  - `Core/`: Contains shared components like widgets, constants, themes, and services (e.g., `BottomBar`, `Widgets`, `VideoCall`).
  - `Features/`: Contains the core feature modules.
    - `PatientFeatures/`: All features specific to patients (booking, profile, scheduling).
    - `DoctorFeatures/`: All features specific to doctors (availability, diagnosis, profile).
    - `LogIn/`: Handles user authentication (login, signup, password management).
    - `payment/`: Manages the payment process and integration.
    - `Welcome/`: Contains the onboarding and splash screens.
  - `main.dart`: The entry point of the application, handling initialization and routing.

## App Visual

### video

[![View video on LinkedIn](screenshots/linkedin-demo-thumbnail.png)](https://www.linkedin.com/posts/karim-mamdouh-780086301_graduationproject-ai-flutter-activity-7341229163049013249-KXqB)

### 📸 Screenshots

### 🔑onboard
![onboard](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072347.png)

### 🏠 User Dashboard
![User Dashboard](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072436.png)

![Doctor Dashboard](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072452.png)

### 📅 Login & Sign Up
![Appointment Booking](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072514.png)

![Appointment Details](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072531.png)

![Video Call](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072623.png)

### 📖 home page
![Medical History](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072700.png)

### 🤖 AI skin diseases detector – Upload Image to gain result
![Pet Profile](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072733.png)

### 👨‍⚕️ Doctor Profile
![Case Management](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072800.png)

### 💳 Payment Gateway
![Prescription](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072818.png)

![Payment Gateway](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20072944.png)

### 🙍‍♂️ User Profile
![AI Upload](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073103.png)

### 📖 Medical History (doctor give diagnosis after appointment)
![AI Result](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073042.png)

### 🔔 Appointment Callender
![Notifications](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073231.png)

### 🎥 Medical Appointment (Video Call) 
![Settings](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073356.png)

![Doctor Profile](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073443.png)

### User & Doctor Reviews
![User Profile](https://github.com/karim1256/Pesto_AI/blob/main/Screenshot%202025-10-01%20073518.png)

---

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed.
- An editor like VS Code or Android Studio.

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/karim1256/Pesto_AI.git
    cd Pesto_AI
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Configure Environment Variables:**
    This project uses Supabase for the backend and Agora for video calls. You will need to create your own accounts and replace the placeholder keys in the code.

    - **Supabase:** In `lib/main.dart`, replace the placeholder `url` and `anonKey` with your own Supabase project credentials.
    - **Agora:** In `lib/Core/Consts/Constants.dart`, replace the placeholder `appId` and `token` with your Agora project credentials.
    - **Payment Gateway:** In `lib/Features/payment/Payment.dart`, replace the placeholder `accessToken` with your Fawaterk API key.
    - **AI Model:** Clone and run the AI Model:
      
      ```sh
      git clone https://github.com/Yassaadel/dog-skin-disease-api.git
      cd dog-skin-disease-api
      ```
    - **Prediction API:** In `lib/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart`, update the `uri` in `postImageForPrediction` to point to your deployed prediction server.

4. **Run the application:**
    ```sh
    flutter run
    ```
