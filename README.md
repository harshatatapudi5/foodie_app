# 🍴 Foodie — Premium Online Food Ordering Application

Foodie is a full-stack Java / Jakarta EE web application for online food delivery, featuring a modern **Aurora Glassmorphism UI**, secure authentication, dynamic cart management, order tracking, and MySQL persistence.

---

## ✨ Features

- **Aurora Glassmorphism UI**: High-contrast, dark-mode design system with frosted glass cards, atmospheric ambient lighting, and smooth responsive layouts.
- **Restaurant & Menu Browsing**: Real-time cuisine filtering (Biryani, Pizza, Burgers, Chinese, Desserts, Healthy), in-menu search, and Veg/Non-Veg toggles.
- **Cart & Steppers**: Dynamic quantity controls, subtotal and tax calculations, and instant coupon code validation (`FOODIE50`, `WELCOME`).
- **Checkout & Multi-Step Ordering**: Delivery address management, standard vs. express delivery options, and delivery notes.
- **Payment Gateway Integration**: Multi-method selection (UPI, Credit/Debit Card, Net Banking, Cash on Delivery) with SSL encryption badges.
- **Live Order Tracking**: Interactive simulated live delivery tracking map with courier partner details and progress timeline.
- **Order History & Receipts**: Complete list of past orders with detailed receipt breakdown and print option.
- **User Profile**: Account management, saved addresses, and live order/spending metrics.
- **Secure Authentication**: BCrypt password hashing and session-based authentication for protected routes.

---

## 🛠️ Tech Stack

- **Backend**: Java 25, Jakarta EE (Servlets, JSP)
- **Database**: MySQL (`food_app`), JDBC
- **Server**: Apache Tomcat 10.1.x
- **Frontend**: HTML5, CSS3 (Aurora Glassmorphism tokens), Vanilla JavaScript
- **Security**: jBCrypt (Password Hashing)

---

## 🚀 Getting Started

### Prerequisites
- JDK 17+ or JDK 25
- Apache Tomcat 10.1+
- MySQL Server 8.0+

### Database Setup
1. Create a MySQL database named `food_app`.
2. Configure credentials in `src/main/java/com/tap/util/DBConnection.java`.

### Build & Run
Compile Java sources and sync to Tomcat:
```powershell
powershell -ExecutionPolicy Bypass -File build.ps1
```
Open in browser:
```
http://localhost:8080/JEE/
```
