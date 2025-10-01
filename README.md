# Pesto AI

[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/karim1256/Pesto_AI)

Pesto AI is a comprehensive telehealth application built with Flutter. It connects patients with veterinary doctors, offering features for appointment booking, video consultations, and profile management for both user types. The application also includes an AI-powered medical check feature for preliminary diagnosis from images.

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

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK: Make sure you have the Flutter SDK installed.
- An editor like VS Code or Android Studio.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/karim1256/Pesto_AI.git
    cd Pesto_AI
    ```

2.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

3.  **Configure Environment Variables:**
    This project uses Supabase for the backend and Agora for video calls. You will need to create your own accounts and replace the placeholder keys in the code.

    -   **Supabase:** In `lib/main.dart`, replace the placeholder `url` and `anonKey` with your own Supabase project credentials.
        ```dart
        await Supabase.initialize(
          url: "YOUR_SUPABASE_URL",
          anonKey: "YOUR_SUPABASE_ANON_KEY",
        );
        ```
    -   **Agora:** In `lib/Core/Consts/Constants.dart`, replace the placeholder `appId` and `token` with your Agora project credentials.
        ```dart
        const appId = "YOUR_AGORA_APP_ID";
        const token = "YOUR_AGORA_TOKEN";
        ```
    -   **Payment Gateway:** In `lib/Features/payment/Payment.dart`, replace the placeholder `accessToken` with your Fawaterk API key.
        ```dart
        String accessToken = 'YOUR_FAWATERK_ACCESS_TOKEN';
        ```
    -   **AI Prediction API:** In `lib/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart`, update the `uri` in the `postImageForPrediction` method to point to your deployed prediction server.
        ```dart
         var uri = Uri.parse('http://YOUR_API_IP_ADDRESS:5000/api/v1/predict');
        ```

4.  **Run the application:**
    ```sh
    flutter run
