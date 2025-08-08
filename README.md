# 🌿 Plant Disease Detection App

A **Flutter mobile application** for the [Plant Disease Detection API](https://github.com/pankajrajparajuli/plantdiseasedetection_-django-backend).  
It allows users to **register, log in, upload plant images for AI-based disease detection**, and **view/manage their prediction history** — all secured with **JWT authentication**.  

---

## 📱 Features

| Feature                     | Description                                      |
|-----------------------------|--------------------------------------------------|
| **User Authentication**     | Register, log in, log out (JWT-secured)          |
| **AI-based Detection**      | Upload plant images for instant disease analysis |
| **Prediction History**      | View all previous predictions with details       |
| **History Management**      | Delete individual predictions or clear all       |
| **Profile Management**      | Update user profile information easily           |
| **Modern UI**               | Smooth and responsive Flutter-based interface    |

---

## 🔗 API Integration

This app communicates with the **[Plant Disease Detection API](https://github.com/pankajrajparajuli/plantdiseasedetection_-django-backend)** built using Django REST Framework.

| Method | Endpoint                              | Purpose                              |
|--------|---------------------------------------|--------------------------------------|
| POST   | `/api/account/register/`              | Register new users                   |
| POST   | `/api/account/login/`                 | Login & obtain JWT tokens           |
| POST   | `/api/detection/predict/`            | Upload images for disease prediction |
| GET    | `/api/detection/history/`            | Fetch prediction history             |
| DELETE | `/api/detection/history/{id}/delete/` | Delete a specific prediction         |
| DELETE | `/api/detection/history/clear/`      | Clear all prediction history         |

---

## 🛠 Tech Stack

| Technology      | Purpose                        |
|-----------------|--------------------------------|
| **Flutter 3.x** | Cross-platform mobile app dev  |
| **HTTP**  | API communication              |
| **Provider/Riverpod** | State management *(if used)* |
| **JWT**         | Secure authentication          |

---

## 🚀 Getting Started

### 1. **Clone the repository**
    git clone https://github.com/pankajrajparajuli/flutter_app_plant_guard.git
    cd flutter_app_plant_guard

### 2. **Install dependencies**
    flutter pub get

### 3. **Configure API URL**
Open `lib/config/api_config.dart` and set the API base URL:
    
    const String apiBaseUrl = "http://YOUR_SERVER_IP:8000/api";

### 4. **Run the app**
    flutter run

