# 🍔 TapFoods - Full Stack Food Delivery Web Application

> A Full Stack Food Delivery Web Application built using Java, JSP, Servlets, JDBC, MySQL, HTML, CSS, JavaScript, BCrypt and Razorpay.

---

## 🚀 Project Overview

TapFoods is a full-stack food delivery web application that allows users to securely register and log in, browse restaurants, explore menus, search food items, manage a shopping cart, place orders, make online payments, manage their profile, and track previous orders through a responsive and user-friendly interface.

The customer module is fully functional with secure authentication, complete ordering workflow, Cash on Delivery, and Razorpay Test Mode payment integration.

---

# ✨ Features

## 🔐 Authentication

- Secure User Registration
- BCrypt Password Hashing
- Secure Login
- Session Management
- Change Password
- Logout

---

## 🍽 Restaurant & Menu Module

- Browse Restaurants
- Search Restaurants
- View Restaurant Menu
- Search Food Items
- View Food Details

---

## 🛒 Shopping Cart

- Add Items to Cart
- Update Item Quantity
- Remove Items
- Automatic Price Calculation
- Dynamic Grand Total

---

## 💳 Checkout & Payments

- Customer Delivery Details
- Delivery Address
- Cash on Delivery (COD)
- Razorpay Payment Gateway Integration
- Razorpay Test Mode Payments
- Secure Payment Verification
- Razorpay Order ID Management
- Razorpay Payment ID Management
- Payment Signature Verification
- Payment Status Storage
- Order Confirmation
- Order Success Page

---

## 📦 Order Management

- Place Orders
- Order History
- Search Orders
- Order Status Tracking
- Cancel Orders
- View Ordered Items
- Payment Method Information

---

## 👤 User Profile

- View Profile
- Edit Profile
- Update Delivery Address
- Change Password

---

# 🛠 Technology Stack

### Frontend

- HTML5
- CSS3
- JavaScript
- JSP

### Backend

- Java
- Jakarta Servlets
- JDBC
- DAO Architecture

### Database

- MySQL

### Security

- BCrypt Password Hashing
- Session-Based Authentication
- Razorpay Payment Signature Verification

### Payment Gateway

- Razorpay

### Server

- Apache Tomcat 10

### IDE

- Eclipse IDE

### Version Control

- Git
- GitHub

---

# 📂 Project Structure

```text
FoodDelivery
│
├── src/main/java
│   └── com.food
│       ├── DAO
│       ├── DAOImpl
│       ├── Model
│       ├── servlets
│       └── utility
│
├── src/main/webapp
│   ├── images
│   ├── WEB-INF
│   │   └── lib
│   ├── Cart.jsp
│   ├── Checkout.jsp
│   ├── Login.jsp
│   ├── Menu.jsp
│   ├── MyOrders.jsp
│   ├── OrderSuccess.jsp
│   ├── Profile.jsp
│   ├── RazorpayPayment.jsp
│   ├── Register.jsp
│   └── Restaurant.jsp
│
└── Database
