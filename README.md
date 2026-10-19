<<<<<<< HEAD
# 🍴 Foodie — Premium Online Food Ordering Application

A full-stack Java web application for online food ordering, featuring a modern Aurora Glassmorphism UI, restaurant and menu browsing, user authentication, cart management, checkout, payment pages, and order management.

Foodie is built using Java, Jakarta EE, Servlets, JSP, JDBC, MySQL, HTML, CSS, and JavaScript, and is designed to run on Apache Tomcat.

---



##  📋 Table of Contents

Features

Technology Stack

Project Architecture

Project Structure

Getting Started

Database Configuration

Build and Run

Application Screenshots

Security

Future Improvements

Developer

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


## 🏗️ Project Architecture
    The application follows a layered Java web application architecture.

##  1. Presentation Layer
    HTML pages, JSP pages, CSS stylesheets, and JavaScript files provide the user interface and client-side interactions.
    
##  2. Controller Layer
    Java Servlets handle incoming HTTP requests and coordinate application operations.

##  3. Data Access Layer
   DAO interfaces and implementation classes organize database access and data-related operations.

##  4. Model Layer
    Java model classes represent application entities such as users, carts, menu data, restaurants, and orders
    
##  5. Database Layer
    MySQL stores application data through JDBC connections.

##  Architecture Diagram

                  User / Browser
                       |
                       v
          HTML + CSS + JavaScript + JSP
                       |
                       v
                Java Servlets
                  Controller
                       |
                       v
                DAO Interfaces
                       |
                       v
                DAO Implementations
                       |
                       v
                  JDBC Layer
                       |
                       v
                 MySQL Database

              Apache Tomcat Server
           Hosts the Java web application
           

## 🚀 Getting Started

### Prerequisites
Install the following software before running the application:

 - JDK: Java Development Kit compatible with your source code. Your project documentation specifies Java 25.

 - Apache Tomcat: Version 10.1.x.

 - MySQL Server: Version 8.0 or another compatible version.

 - IDE: Visual Studio Code or Eclipse IDE.

## 2. Configure the Java Environment
   Verify your Java installation:

    java -version
    javac -version

  Ensure the required JDK is configured in your IDE and build environment.

## 3. Configure Apache Tomcat
     1.  Install Apache Tomcat 10.1.x.
    
     2. Configure the appropriate JDK.
      
     3. Ensure the application uses Jakarta-compatible Servlet APIs.
      
     4. Configure the application deployment and context path.
      
     5. Verify that the required libraries are available.

### 🗄️ Database Configuration
1. Create a MySQL database named `food_app`.
2. Configure credentials in `src/main/java/com/tap/util/DBConnection.java`.

### Build & Run
    Your project includes a PowerShell build script named build.ps1.
    
    From the directory containing that script, run:

##  powershell -ExecutionPolicy Bypass -File .\build.ps1

    The script should compile and deploy the application according to its configured paths. Check its output for compilation errors or deployment failures.


##  👨‍💻 Developer

##   Harsha Tatapudi

##   GitHub:https://github.com/harshatatapudi5/foodie_app
     
##  📸 Application Screenshots

    
![Uploading image.png…](https://github.com/harshatatapudi5/foodie_app/blob/41491524b019d43df1df3a4d0597415e239c7d25/Screenshot%202026-10-19%20183039.png)

![Uploading image.png…](https://github.com/harshatatapudi5/foodie_app/blob/main/Screenshot%202026-10-19%20184115.png?raw=true)





##  🔐 Security
     - Hash passwords securely before storing them.

    - Validate input on the server side.
    
    - Protect routes that require authentication.
    
    - Use prepared SQL statements for database operations.
    
    - Keep database credentials outside public source control.
    
    - Configure appropriate session management.
    
    - Use HTTPS and secure cookie settings in production.


##  🔮 Future Improvements
     Possible improvements for the application include:

         - Integrating a verified online payment gateway.

         - Adding automated tests for controllers and DAO classes.
        
         - Improving input validation and error handling.
        
         - Adding pagination and advanced restaurant filtering.
        
         - Improving accessibility and mobile responsiveness.
        
         - Deploying the application with a production database and secure configuration.

```
=======


