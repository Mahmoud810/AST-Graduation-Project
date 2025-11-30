# 🔄 Sequence Diagrams - Pharmacy Application Workflows

## Overview
This document contains detailed sequence diagrams for all major workflows in the Pharmacy Application, showing the interaction between users, the Flutter app, and Firebase services.

## 1. User Authentication Flow

### 1.1 User Registration Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │Firebase Auth │    │ Firestore DB │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Enter registration                     │                   │
       │   details (email, password)             │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Validate input │                   │
       │                   │   (format, rules)│                   │
       │                   │                   │                   │
       │                   │3. Create user    │                   │
       │                   │   with Firebase  │                   │
       │                   │   Auth           │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Create user   │                   │
       │                   │                   │   account        │                   │
       │                   │                   │                   │
       │                   │5. Return user    │                   │
       │                   │   credential     │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Create user    │                   │
       │                   │   document in    │                   │
       │                   │   Firestore      │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │7. Save user      │
       │                   │                   │   profile data   │
       │                   │                   │                   │
       │                   │8. Return success  │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │9. Show registration│                   │                   │
       │   success message  │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │10. Navigate to    │                   │                   │
       │    Home screen    │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 1.2 User Login Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │Firebase Auth │    │ Firestore DB │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Enter login     │                   │                   │
       │   credentials     │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Validate input │                   │
       │                   │                   │                   │
       │                   │3. Sign in with   │                   │
       │                   │   Firebase Auth  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Authenticate   │                   │
       │                   │                   │   credentials    │                   │
       │                   │                   │                   │
       │                   │5. Return user    │                   │
       │                   │   credential     │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Fetch user     │                   │
       │                   │   profile from    │                   │
       │                   │   Firestore      │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │7. Retrieve user  │                   │
       │                   │                   │   document       │                   │
       │                   │                   │                   │
       │                   │8. Return user    │                   │
       │                   │   data           │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │9. Show login      │                   │                   │
       │   success         │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │10. Navigate to    │                   │                   │
       │    Home screen    │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 2. Product Management Flow

### 2.1 Browse Products Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Open Home       │                   │                   │
       │   screen          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Request products│                   │
       │                   │   list from       │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Query products │                   │
       │                   │                   │   collection     │                   │
       │                   │                   │                   │
       │                   │4. Return product  │                   │
       │                   │   data            │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │5. Load product    │                   │
       │                   │   images from     │                   │
       │                   │   Storage         │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │6. Fetch images   │                   │
       │                   │                   │   from storage   │                   │
       │                   │                   │                   │
       │                   │7. Return image    │                   │
       │                   │   URLs            │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │8. Display products│                   │                   │
       │   with images     │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │9. User can scroll │                   │                   │
       │   for more items  │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 2.2 Product Search Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Enter search    │                   │                   │
       │   query           │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Debounce search│                   │
       │                   │   input (300ms)  │                   │
       │                   │                   │                   │
       │                   │3. Query Firestore │                   │
       │                   │   with search     │                   │
       │                   │   parameters      │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Search products │                   │
       │                   │   by name,        │                   │
       │                   │   description,    │                   │
       │                   │   tags            │                   │
       │                   │                   │                   │
       │                   │5. Return matching │                   │
       │                   │   products        │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Load product    │                   │
       │                   │   images          │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │7. Fetch images   │                   │
       │                   │                   │                   │
       │                   │8. Return image    │                   │
       │                   │   URLs            │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │9. Display search  │                   │                   │
       │   results          │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 2.3 Product Details View Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap on product  │                   │                   │
       │   from list        │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Navigate to     │                   │
       │                   │   product details │                   │
       │                   │   screen          │                   │
       │                   │                   │                   │
       │                   │3. Fetch product   │                   │
       │                   │   details from    │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Get product    │                   │
       │                   │                   │   document       │                   │
       │                   │                   │                   │
       │                   │5. Return product  │                   │
       │                   │   details         │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Load all product│                   │
       │                   │   images from     │                   │
       │                   │   Storage         │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │7. Fetch all      │                   │
       │                   │                   │   product images │                   │
       │                   │                   │                   │
       │                   │8. Return image    │                   │
       │                   │   URLs            │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │                   │9. Load product    │                   │
       │                   │   reviews         │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │10. Get reviews   │                   │
       │                   │                   │   for product    │                   │
       │                   │                   │                   │
       │                   │11. Return reviews │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │12. Display product│                   │                   │
       │   details with    │                   │                   │
       │   images & reviews│                   │                   │
       │◄─────────────────┤                   │                   │
```

## 3. Shopping Cart Flow

### 3.1 Add to Cart Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │   Local Cache │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap "Add to     │                   │                   │
       │   Cart" button    │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update local    │                   │
       │                   │   cart state      │                   │
       │                   │   immediately     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Cache cart     │                   │
       │                   │                   │   data locally   │                   │
       │                   │                   │                   │
       │4. Update cart     │                   │                   │
       │   badge count     │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │                   │5. Sync with       │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │6. Update cart    │                   │
       │                   │                   │   document       │                   │
       │                   │                   │                   │
       │                   │7. Return success  │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │8. Show success     │                   │                   │
       │   message          │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 3.2 View Cart Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap cart icon    │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Navigate to     │                   │
       │                   │   cart screen     │                   │
       │                   │                   │                   │
       │                   │3. Fetch cart data │                   │
       │                   │   from Firestore  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Get cart        │                   │
       │                   │                   │   document       │                   │
       │                   │                   │                   │
       │                   │5. Return cart     │                   │
       │                   │   items           │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Fetch product   │                   │
       │                   │   details for     │                   │
       │                   │   each cart item  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │7. Get product     │                   │
       │                   │                   │   documents      │                   │
       │                   │                   │                   │
       │                   │8. Return product  │                   │
       │                   │   data            │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │9. Load product    │                   │
       │                   │   images          │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │10. Fetch images  │                   │
       │                   │                   │                   │
       │                   │11. Return image   │                   │
       │                   │   URLs           │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │12. Display cart    │                   │                   │
       │   with products    │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 3.3 Update Cart Quantity Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │   Local Cache │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Change quantity  │                   │                   │
       │   in cart          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update local    │                   │
       │                   │   cart state      │                   │
       │                   │   immediately     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Cache updated  │                   │
       │                   │                   │   cart data      │                   │
       │                   │                   │                   │
       │4. Recalculate     │                   │                   │
       │   totals           │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │                   │5. Sync with       │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │6. Update cart    │                   │
       │                   │                   │   document       │                   │
       │                   │                   │   with new       │                   │
       │                   │                   │   quantities     │                   │
       │                   │                   │                   │
       │                   │7. Return success  │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │8. Show updated    │                   │                   │
       │   cart totals      │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 4. Prescription Upload Flow

### 4.1 Prescription Upload Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │Firebase Storage│    │ Firestore DB │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap "Upload     │                   │                   │
       │   Prescription"   │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Show image      │                   │
       │                   │   source options  │                   │
       │                   │   (Camera/Gallery)│                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │3. Select image     │                   │                   │
       │   source          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │4. Capture/Select  │                   │
       │                   │   image           │                   │
       │                   │                   │                   │
       │5. Compress image  │                   │                   │
       │   and show preview│                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │6. Confirm upload  │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │7. Create          │                   │
       │                   │   prescription     │                   │
       │                   │   document in     │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │8. Save prescription│
       │                   │                   │   record         │
       │                   │                   │                   │
       │                   │9. Return          │                   │
       │                   │   prescription ID │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │                   │10. Upload image  │                   │
       │                   │    to Storage     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │11. Store image   │                   │
       │                   │                   │    in bucket      │                   │
       │                   │                   │                   │
       │                   │12. Return image  │                   │
       │                   │    URL           │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │13. Update        │                   │
       │                   │    prescription   │                   │
       │                   │    with image URL │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │14. Update record │                   │
       │                   │                   │                   │
       │                   │15. Return success │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │16. Show upload    │                   │                   │
       │    success        │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 4.2 Prescription Verification Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Pharmacist │    │ Admin Panel  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Login to admin   │                   │                   │
       │   panel           │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Authenticate    │                   │
       │                   │   pharmacist      │                   │
       │                   │                   │                   │
       │3. View pending    │                   │                   │
       │   prescriptions   │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │4. Fetch pending   │                   │
       │                   │   prescriptions   │                   │
       │                   │   from Firestore  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │5. Query pending  │                   │
       │                   │                   │   prescriptions  │                   │
       │                   │                   │                   │
       │                   │6. Return list     │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │7. Display list    │                   │                   │
       │   of prescriptions│                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │8. Click on        │                   │                   │
       │   prescription    │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │9. Fetch prescription│                  │
       │                   │   details         │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │10. Get prescription│                  │
       │                   │                   │    document       │                   │
       │                   │                   │                   │
       │                   │11. Load prescription│                  │
       │                   │    images from    │                   │
       │                   │    Storage        │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │12. Fetch images  │                   │
       │                   │                   │                   │
       │                   │13. Return image  │                   │
       │                   │    URLs           │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │14. Display        │                   │                   │
       │    prescription   │                   │                   │
       │    with images    │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │15. Verify/Reject  │                   │                   │
       │    prescription   │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │16. Update        │                   │
       │                   │    prescription   │                   │
       │                   │    status         │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │17. Update status │                   │
       │                   │                   │    and notes     │                   │
       │                   │                   │                   │
       │                   │18. Return success │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │19. Show updated   │                   │                   │
       │    status         │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 5. Checkout Process Flow

### 5.1 Checkout Initiation Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Payment Gateway│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap "Checkout"  │                   │                   │
       │   from cart        │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Navigate to     │                   │
       │                   │   checkout screen │                   │
       │                   │                   │                   │
       │                   │3. Fetch cart data │                   │
       │                   │   from Firestore  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Get cart        │                   │
       │                   │                   │   document       │                   │
       │                   │                   │                   │
       │                   │5. Return cart     │                   │
       │                   │   items & totals  │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Fetch user     │                   │
       │                   │   addresses      │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │7. Get user       │                   │
       │                   │                   │   addresses      │                   │
       │                   │                   │                   │
       │                   │8. Return addresses│                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │9. Display checkout│                   │                   │
       │   summary with     │                   │                   │
       │   address options │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 5.2 Order Placement Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Payment Gateway│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Confirm order    │                   │                   │
       │   details          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Create order    │                   │
       │                   │   document in     │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │3. Save order     │                   │
       │                   │                   │   with "pending" │                   │
       │                   │                   │   status         │                   │
       │                   │                   │                   │
       │                   │4. Return order ID │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │                   │5. Process payment │                   │
       │                   │   if required     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │6. Process payment│                   │
       │                   │                   │   transaction    │                   │
       │                   │                   │                   │
       │                   │7. Return payment  │                   │
       │                   │   result          │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │8. Update order    │                   │
       │                   │   status based    │                   │
       │                   │   on payment      │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │9. Update order   │                   │
       │                   │                   │   status         │                   │
       │                   │                   │                   │
       │                   │10. Clear cart     │                   │
       │                   │    in Firestore   │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │11. Clear cart    │                   │
       │                   │                   │    items         │                   │
       │                   │                   │                   │
       │                   │12. Return success │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │13. Show order     │                   │                   │
       │    confirmation    │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 6. Favorites Management Flow

### 6.1 Add to Favorites Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │   Local Cache │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap heart icon  │                   │                   │
       │   on product       │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update local    │                   │
       │                   │   favorites state │                   │
       │                   │   immediately     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Cache favorite │                   │
       │                   │                   │   locally        │                   │
       │                   │                   │                   │
       │4. Update heart    │                   │                   │
       │   icon to filled   │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │                   │5. Create favorite │                   │
       │                   │   document in     │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │6. Save favorite  │                   │
       │                   │                   │   record         │                   │
       │                   │                   │                   │
       │                   │7. Return success  │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │8. Show success     │                   │                   │
       │   message          │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 6.2 View Favorites Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap favorites   │                   │                   │
       │   tab/icon         │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Navigate to     │                   │
       │                   │   favorites screen │                   │
       │                   │                   │                   │
       │                   │3. Fetch user      │                   │
       │                   │   favorites from   │                   │
       │                   │   Firestore       │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Get favorite   │                   │
       │                   │                   │   documents      │                   │
       │                   │                   │                   │
       │                   │5. Return favorite │                   │
       │                   │   list            │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │6. Fetch product   │                   │
       │                   │   details for      │                   │
       │                   │   each favorite    │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │7. Get product     │                   │
       │                   │                   │   documents      │                   │
       │                   │                   │                   │
       │                   │8. Return product  │                   │
       │                   │   data            │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │9. Load product    │                   │
       │                   │   images          │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │10. Fetch images  │                   │
       │                   │                   │                   │
       │                   │11. Return image   │                   │
       │                   │   URLs           │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │12. Display        │                   │                   │
       │    favorites      │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 7. Order Management Flow

### 7.1 View Order History Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │ Firestore DB │    │Firebase Storage│
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Tap "Orders"    │                   │                   │
       │   from profile    │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Navigate to     │                   │
       │                   │   orders screen   │                   │
       │                   │                   │                   │
       │                   │3. Fetch user orders│                   │
       │                   │   from Firestore  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Query orders    │                   │
       │                   │                   │   by userId       │                   │
       │                   │                   │                   │
       │                   │5. Return order    │                   │
       │                   │   list            │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │6. Display order   │                   │                   │
       │   list with status │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │7. Tap on specific │                   │                   │
       │   order           │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │8. Navigate to     │                   │
       │                   │   order details   │                   │
       │                   │   screen          │                   │
       │                   │                   │                   │
       │                   │9. Fetch detailed  │                   │
       │                   │   order data      │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │10. Get order     │                   │
       │                   │                   │    document      │                   │
       │                   │                   │                   │
       │                   │11. Load product   │                   │
       │                   │    images         │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │12. Fetch images  │                   │
       │                   │                   │                   │
       │                   │13. Return image   │                   │
       │                   │    URLs           │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │14. Display order  │                   │                   │
       │    details        │                   │                   │
       │◄─────────────────┤                   │                   │
```

### 7.2 Order Status Updates Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Admin/Staff│    │ Admin Panel  │    │ Firestore DB │    │  Cloud Func  │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Update order    │                   │                   │
       │   status          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update order    │                   │
       │                   │   in Firestore    │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Update order   │                   │
       │                   │                   │   status         │                   │
       │                   │                   │                   │
       │                   │4. Trigger Cloud   │                   │
       │                   │   Function for    │                   │
       │                   │   notifications   │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │5. Send push      │                   │
       │                   │                   │   notification   │                   │
       │                   │                   │   to user        │                   │
       │                   │                   │                   │
       │                   │6. Return success  │                   │
       │                   │◄─────────────────────────────────────┤
       │                   │                   │                   │
       │7. Show updated    │                   │                   │
       │   status          │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 8. Error Handling Flow

### 8.1 Network Error Handling Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    User     │    │ Flutter App  │    │   Local Cache │    │ Firestore DB │
└─────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Perform action  │                   │                   │
       │   (e.g., add to   │                   │                   │
       │    cart)          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Try to sync     │                   │
       │                   │   with Firestore  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │3. Network error  │                   │
       │                   │                   │   occurs         │                   │
       │                   │                   │                   │
       │                   │4. Return error    │                   │
       │                   │◄─────────────────┤                   │
       │                   │                   │                   │
       │                   │5. Cache action    │                   │
       │                   │   locally         │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │6. Save for later │                   │
       │                   │                   │   sync           │                   │
       │                   │                   │                   │
       │7. Show "Offline"  │                   │                   │
       │   indicator       │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │8. Continue with   │                   │                   │
       │   cached data     │                   │                   │
       │◄─────────────────┤                   │                   │
       │                   │                   │                   │
       │9. When network    │                   │                   │
       │   returns:        │                   │                   │
       │                   │                   │                   │
       │                   │10. Auto-sync      │                   │
       │                   │    cached actions │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │11. Get pending   │                   │
       │                   │                   │    actions       │                   │
       │                   │                   │                   │
       │                   │12. Sync with      │                   │
       │                   │    Firestore      │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │13. Process all   │                   │
       │                   │                   │    pending actions│                   │
       │                   │                   │                   │
       │                   │14. Clear cache   │                   │
       │                   │    after sync     │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │15. Remove synced │                   │
       │                   │                   │    actions       │                   │
       │                   │                   │                   │
       │16. Show "Synced"  │                   │                   │
       │    message        │                   │                   │
       │◄─────────────────┤                   │                   │
```

## 9. Real-time Updates Flow

### 9.1 Real-time Cart Sync Sequence
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Device A   │    │ Firestore DB │    │  Device B    │    │  Device C    │
└─────────────┘    └──────────────┘    └─────────────┘    └─────────────┘
       │                   │                   │                   │
       │1. Update cart     │                   │                   │
       │   on Device A     │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update cart     │                   │
       │                   │   document       │                   │
       │                   │                   │                   │
       │                   │3. Trigger real-   │                   │
       │                   │   time listeners  │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │4. Notify Device B│                   │
       │                   │                   │                   │
       │                   │                   ├─────────────────►│
       │                   │                   │5. Update local   │                   │
       │                   │                   │   cart state     │                   │
       │                   │                   │                   │
       │                   │                   │6. Refresh UI     │                   │
       │                   │                   │◄─────────────────┤
       │                   │                   │                   │
       │                   │7. Notify Device C │                   │
       │                   │                   │                   │
       │                   │                   ├─────────────────►│
       │                   │                   │8. Update local   │                   │
       │                   │                   │   cart state     │                   │
       │                   │                   │                   │
       │                   │                   │9. Refresh UI     │                   │
       │                   │                   │◄─────────────────┤
```

### 9.2 Real-time Order Status Updates
```
┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Admin/Staff│    │ Firestore DB │    │   User App   │    │Push Notification│
└─────────────┘    └──────────────┘    └─────────────┘    └──────────────┘
       │                   │                   │                   │
       │1. Update order    │                   │                   │
       │   status          │                   │                   │
       ├─────────────────►│                   │                   │
       │                   │2. Update order    │                   │
       │                   │   document       │                   │
       │                   │                   │                   │
       │                   │3. Trigger Cloud   │                   │
       │                   │   Function        │                   │
       │                   ├─────────────────────────────────────►│
       │                   │                   │4. Send push      │                   │
       │                   │                   │   notification   │                   │
       │                   │                   │                   │
       │                   │                   │5. User receives  │                   │
       │                   │                   │   notification   │                   │
       │                   │                   │◄─────────────────┤
       │                   │                   │                   │
       │                   │6. User opens app  │                   │
       │                   │                   │                   │
       │                   │7. Real-time      │                   │
       │                   │   listener updates │                   │
       │                   │   order status    │                   │
       │                   ├─────────────────►│                   │
       │                   │                   │8. Update UI      │                   │
       │                   │                   │   with new status│                   │
       │                   │                   │                   │
       │                   │                   │9. Show updated   │                   │
       │                   │                   │   order status   │                   │
       │                   │                   │◄─────────────────┤
```

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Application**: Pharmacy Mobile App  
**Technology**: Flutter + Firebase
