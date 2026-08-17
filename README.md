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

<div align="center">
  <table>
    <tr>
      <td align="center"><b>Customer App</b></td>
      <td align="center"><b>Admin Dashboard</b></td>
      <td align="center"><b>Cashier POS</b></td>
      <td align="center"><b>Kitchen Display</b></td>
    </tr>
    <tr>
      <td><img src="[اسحب_صورة_العميل_هنا]" width="220" alt="Customer UI"></td>
      <td><img src="[اسحب_صورة_الأدمن_هنا]" width="220" alt="Admin UI"></td>
      <td><img src="[اسحب_صورة_الكاشير_هنا]" width="220" alt="Cashier UI"></td>
      <td><img src="[اسحب_صورة_المطبخ_هنا]" width="220" alt="Kitchen UI"></td>
    </tr>
  </table>
</div>

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
