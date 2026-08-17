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
- [Contact](#-contact)

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

### 📱 1. Customer Experience (4 Screens)
<p align="center">
  <img src="[صورة_العميل_1_هنا]" width="200"> &nbsp;
  <img src="[صورة_العميل_2_هنا]" width="200"> &nbsp;
  <img src="[صورة_العميل_3_هنا]" width="200"> &nbsp;
  <img src="[صورة_العميل_4_هنا]" width="200">
</p>

### 👑 2. Admin Dashboard (8 Screens)
<p align="center">
  <img src="[صورة_الأدمن_1_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_2_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_3_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_4_هنا]" width="200">
</p>
<p align="center">
  <img src="[صورة_الأدمن_5_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_6_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_7_هنا]" width="200"> &nbsp;
  <img src="[صورة_الأدمن_8_هنا]" width="200">
</p>

### 💰 3. Cashier POS
<p align="center">
  <img src="[صورة_الكاشير_هنا]" width="220">
</p>

### 🍳 4. Kitchen Display
<p align="center">
  <img src="[صورة_المطبخ_هنا]" width="220">
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
