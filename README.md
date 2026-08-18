<div align="center">
  
  # 🍔 Beti (بيتي) - Advanced Restaurant Ecosystem
  
  **A scalable, full-stack Flutter application featuring Role-Based Access Control (RBAC), Clean Architecture, and real-time state management.**

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com/)
  [![Clean Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-success?style=for-the-badge)](#)
  [![State Management](https://img.shields.io/badge/State-Cubit-blue?style=for-the-badge)](#)

</div>

---

## 📋 Table of Contents
- [About The Project](#-about-the-project)
- [System Roles (RBAC)](#-system-roles-rbac)
- [Screenshots](#-screenshots)
- [Tech Stack & Architecture](#-tech-stack--architecture)
- [Getting Started](#-getting-started)
- [Contact](https://www.linkedin.com/in/mohamed-ragab-551300328?utm_source=share_via&utm_content=profile&utm_medium=member_android)

---

## 🚀 About The Project
**Beti (بيتي)** is not just a food ordering app; it is a complete restaurant management ecosystem. Built to demonstrate enterprise-level patterns, the app dynamically adapts its UI and business logic based on the authenticated user's role. It features a robust routing system, offline-ready cart management, and a highly decoupled architecture.

---

## 👥 System Roles (RBAC)
The application handles four distinct operational dashboards securely routed via Firebase Firestore:

1. 📱 **Customer:** Browse categorized menus, manage local carts, and place orders seamlessly.
2. 👑 **Admin:** Master control panel to oversee business operations, register new staff, and manage roles.
3. 💰 **Cashier:** Point of Sale (POS) interface to track transactions, process payments, and finalize physical orders.
4. 🍳 **Kitchen:** Real-time order tracking display to manage food preparation status.

---

## 📸 Screenshots

### 📱 1. Login
<p align="center">
  <img src="https://github.com/user-attachments/assets/19b204f0-b13e-4f28-8df9-169646fe10a4">
</p>

### 📱 2. Customer Experience (6 Screens)
<p align="center">
  <img src="https://github.com/user-attachments/assets/8d6fe19e-c09d-4c68-9723-5b466bb110cc" width="200" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/1f531455-f80d-44b3-ac21-929f0a6c67dd" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/d96d6235-8776-4959-8f7b-2bdb2288e9fa" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/59b21681-0343-403e-b01b-ae1cd1b8a7fd" width="200">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/db2380e6-ef2c-4ce6-ba61-730ca58f92f5" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/256c635d-2088-4e2c-93b4-3394dec1955e" width="200">;
</p>

### 👑 3. Admin Dashboard (8 Screens)
<p align="center">
  <img src="https://github.com/user-attachments/assets/910a8bc9-e4c5-4ab7-8c9d-c4bb2a6c25ae" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/025a1068-d963-484e-ad0a-70cfbfa0da93" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/dd1fd81e-6eb1-4497-aa05-c710ea94a48c" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/50d75a1d-4a2a-42e9-bce4-4856d8966132" width="200">
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/f4085b5a-23ae-4d9f-bcb5-eaee7c65d1a8" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/d866a02c-bf45-4949-aa1a-ac05ca870b00" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/4f797892-7386-44b2-97e3-c87fbf64fe30" width="200"> &nbsp;
  <img src="https://github.com/user-attachments/assets/b2a5dbd4-ca4c-4449-908f-073d19f40370" width="200">
</p>

### 💰 4. Cashier POS
<p align="center">
  <img src="https://github.com/user-attachments/assets/8e0d4e21-2fa8-4844-87ae-443434f52c5b" width="220">
</p>

### 🍳 5. Kitchen Display
<p align="center">
  <img src="https://github.com/user-attachments/assets/ef77193c-866a-4587-9654-cb1798d59be6" width="220">
</p>

---

## ⚙️ Tech Stack & Architecture

### Frontend & Core
* **Flutter:** Cross-platform UI.
* **BLoC / Cubit:** For predictable and testable state management.
* **GetIt:** Dependency injection (Service Locator) for decoupling layers.
* **Clean Architecture:** Strict separation into `Presentation`, `Domain`, and `Data` layers ensuring adherence to SOLID principles.

### Backend & Storage
* **Firebase Auth:** Secure user authentication.
* **Cloud Firestore:** NoSQL database for real-time order tracking and role storage.
* **ASP.NET Core Web API:** Integration endpoints for advanced server-side operations.
* **Microsoft SQL Server:** Relational database backing the ASP.NET APIs.

---

## 💻 Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites
* Flutter SDK (Latest Version)
* Git

### Installation
1. Clone the repo:
   ```bash
   git clone [https://github.com/](https://github.com/)[اسم_حسابك_هنا]/restaurant_app.git

1.Install NPM packages / Flutter dependencies:

    Bash
    flutter pub get
2.Run the application:

    Bash
    flutter run
📫 Contact
Mohamed - Junior Flutter Developer
