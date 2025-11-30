# 🔥 Firebase Structure Documentation - Pharmacy Application

## Overview
This document details the complete Firebase structure for the Pharmacy Application, including Firestore collections, Firebase Storage organization, and security rules.

## 1. Project Configuration

### 1.1 Firebase Project Settings
```json
{
  "projectId": "pharmacy-app-graduation",
  "databaseURL": "https://pharmacy-app-graduation.firebaseio.com",
  "storageBucket": "pharmacy-app-graduation.appspot.com",
  "locationId": "us-central",
  "defaultDatabase": "pharmacy-app-graduation"
}
```

### 1.2 Firebase Services Used
- **Firebase Authentication** - User authentication
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - File storage
- **Firebase Analytics** - User analytics
- **Firebase Crashlytics** - Error reporting
- **Firebase Cloud Messaging** - Push notifications

## 2. Firestore Database Structure

### 2.1 Collection Overview
```
pharmacy-app-graduation/
├── users/
├── products/
├── categories/
├── cart/
├── orders/
├── prescriptions/
├── favourites/
├── reviews/
├── addresses/
├── notifications/
└── app_settings/
```

### 2.2 Detailed Collection Schemas

#### Users Collection
```javascript
/users/{userId}
{
  // Basic Information
  email: "user@example.com",
  username: "john_doe_123",
  phone: "+1234567890",
  verified: true,
  
  // Profile Data
  profile: {
    firstName: "John",
    lastName: "Doe",
    dateOfBirth: timestamp("1985-06-15"),
    gender: "male",
    avatar: "https://storage.googleapis.com/.../avatar.jpg"
  },
  
  // Timestamps
  createdAt: timestamp("2025-11-01T10:00:00Z"),
  lastLogin: timestamp("2025-11-30T15:30:00Z"),
  updatedAt: timestamp("2025-11-30T15:30:00Z"),
  
  // Preferences
  preferences: {
    language: "en",
    currency: "USD",
    notifications: {
      email: true,
      push: true,
      sms: false,
      orderUpdates: true,
      promotions: false
    },
    theme: "light",
    units: "metric"
  },
  
  // Status
  status: "active", // active, suspended, deleted
  isEmailVerified: true,
  isPhoneVerified: true
}
```

#### Products Collection
```javascript
/products/{productId}
{
  // Basic Information
  name: "Paracetamol 500mg Tablets",
  description: "Effective pain relief and fever reduction medication",
  shortDescription: "Pain relief tablets",
  sku: "MED-001-PAR-500",
  barcode: "1234567890123",
  
  // Pricing
  price: 12.99,
  currency: "USD",
  compareAtPrice: 15.99,
  cost: 8.50,
  taxRate: 0.08,
  
  // Inventory
  inventory: {
    quantity: 150,
    reserved: 5,
    available: 145,
    reorderLevel: 20,
    trackQuantity: true
  },
  
  // Classification
  category: "pain_relief",
  subcategory: "fever_reducer",
  brand: "MediBrand",
  manufacturer: "PharmaCorp",
  tags: ["pain", "fever", "headache", "over-the-counter"],
  
  // Media
  images: [
    {
      url: "https://storage.googleapis.com/.../product-main.jpg",
      alt: "Paracetamol 500mg tablets box",
      isPrimary: true,
      order: 1
    },
    {
      url: "https://storage.googleapis.com/.../product-detail.jpg",
      alt: "Paracetamol tablets close-up",
      isPrimary: false,
      order: 2
    }
  ],
  
  // Medical Information
  medical: {
    dosage: "500mg",
    form: "tablet",
    ageRestriction: null,
    requiresPrescription: false,
    activeIngredients: ["Paracetamol"],
    sideEffects: ["Nausea", "Headache"],
    warnings: ["Do not exceed 4 tablets in 24 hours"],
    contraindications: ["Liver disease", "Alcohol dependence"]
  },
  
  // Ratings and Reviews
  rating: {
    average: 4.5,
    count: 128,
    distribution: {
      5: 85,
      4: 25,
      3: 12,
      2: 4,
      1: 2
    }
  },
  
  // Shipping and Handling
  shipping: {
    weight: 0.1, // kg
    dimensions: {
      length: 10, // cm
      width: 5,
      height: 3
    },
    hazmat: false,
    temperatureControlled: false,
    fragile: false
  },
  
  // SEO and Marketing
  seo: {
    title: "Paracetamol 500mg - Pain Relief Tablets",
    description: "Buy Paracetamol 500mg tablets online. Fast pain relief.",
    keywords: ["paracetamol", "pain relief", "fever reducer"]
  },
  
  // Status and Timestamps
  status: "active", // active, inactive, discontinued
  featured: false,
  createdAt: timestamp("2025-10-15T09:00:00Z"),
  updatedAt: timestamp("2025-11-20T14:30:00Z"),
  publishedAt: timestamp("2025-10-15T09:00:00Z")
}
```

#### Categories Collection
```javascript
/categories/{categoryId}
{
  name: "Pain Relief",
  description: "Medications for pain management and fever reduction",
  slug: "pain-relief",
  image: {
    url: "https://storage.googleapis.com/.../category-pain-relief.jpg",
    alt: "Pain relief medications category"
  },
  icon: "pill",
  color: "#2196F3",
  
  // Hierarchy
  parentId: null, // null for top-level categories
  level: 1,
  order: 1,
  
  // SEO
  seo: {
    title: "Pain Relief Medications",
    description: "Browse our selection of pain relief medications",
    keywords: ["pain", "relief", "fever", "headache"]
  },
  
  // Status
  status: "active",
  isActive: true,
  productCount: 45,
  
  // Timestamps
  createdAt: timestamp("2025-10-01T10:00:00Z"),
  updatedAt: timestamp("2025-11-15T11:30:00Z")
}
```

#### Cart Collection
```javascript
/cart/{userId} // Using userId as document ID for one-to-one relationship
{
  userId: "user_12345",
  items: [
    {
      id: "cart_item_1",
      productId: "product_12345",
      variant: {
        size: "500mg",
        form: "tablet"
      },
      quantity: 2,
      unitPrice: 12.99,
      totalPrice: 25.98,
      addedAt: timestamp("2025-11-30T10:15:00Z"),
      requiresPrescription: false,
      inStock: true,
      notes: "Buy one get one free"
    }
  ],
  
  // Pricing Summary
  pricing: {
    subtotal: 25.98,
    tax: 2.08,
    shipping: 4.99,
    discount: 0.00,
    total: 33.05,
    currency: "USD"
  },
  
  // Applied Discounts
  discounts: [
    {
      code: "WELCOME10",
      type: "percentage",
      value: 10,
      amount: 2.60
    }
  ],
  
  // Shipping Information
  shipping: {
    method: "standard",
    estimatedDelivery: timestamp("2025-12-03T00:00:00Z"),
    address: {
      street: "123 Main St",
      city: "Anytown",
      state: "CA",
      zipCode: "12345",
      country: "USA"
    }
  },
  
  // Timestamps
  createdAt: timestamp("2025-11-30T10:00:00Z"),
  updatedAt: timestamp("2025-11-30T10:15:00Z"),
  expiresAt: timestamp("2025-12-30T10:00:00Z"), // Cart expiration
  
  // Status
  status: "active" // active, abandoned, converted
}
```

#### Orders Collection
```javascript
/orders/{orderId}
{
  // Order Information
  orderNumber: "ORD-2025-001234",
  userId: "user_12345",
  
  // Items
  items: [
    {
      productId: "product_12345",
      name: "Paracetamol 500mg Tablets",
      sku: "MED-001-PAR-500",
      quantity: 2,
      unitPrice: 12.99,
      totalPrice: 25.98,
      image: "https://storage.googleapis.com/.../product-thumb.jpg"
    }
  ],
  
  // Financial Information
  pricing: {
    subtotal: 25.98,
    tax: 2.08,
    shipping: 4.99,
    discount: 2.60,
    total: 33.05,
    currency: "USD"
  },
  
  // Order Status
  status: "confirmed", // pending, confirmed, preparing, ready, shipped, delivered, cancelled
  paymentStatus: "paid", // pending, paid, failed, refunded
  fulfillmentStatus: "processing", // pending, processing, shipped, delivered
  
  // Payment Information
  payment: {
    method: "credit_card",
    provider: "stripe",
    transactionId: "txn_1234567890",
    paidAt: timestamp("2025-11-30T10:20:00Z"),
    amount: 33.05
  },
  
  // Shipping Information
  shipping: {
    method: "standard",
    carrier: "UPS",
    trackingNumber: "1Z12345678901234567",
    estimatedDelivery: timestamp("2025-12-03T00:00:00Z"),
    actualDelivery: null,
    address: {
      recipientName: "John Doe",
      street: "123 Main St",
      city: "Anytown",
      state: "CA",
      zipCode: "12345",
      country: "USA",
      phone: "+1234567890"
    },
    instructions: "Leave at front door"
  },
  
  // Prescription Information
  prescriptions: [
    {
      prescriptionId: "prescription_12345",
      verified: true,
      verifiedBy: "pharmacist_001",
      verifiedAt: timestamp("2025-11-30T10:18:00Z")
    }
  ],
  
  // Timeline
  timeline: [
    {
      status: "placed",
      timestamp: timestamp("2025-11-30T10:15:00Z"),
      note: "Order placed successfully"
    },
    {
      status: "confirmed",
      timestamp: timestamp("2025-11-30T10:20:00Z"),
      note: "Payment confirmed"
    }
  ],
  
  // Notes
  notes: "Customer requested special packaging for fragile items",
  internalNotes: "High priority customer",
  
  // Timestamps
  createdAt: timestamp("2025-11-30T10:15:00Z"),
  updatedAt: timestamp("2025-11-30T10:20:00Z")
}
```

#### Prescriptions Collection
```javascript
/prescriptions/{prescriptionId}
{
  // Basic Information
  userId: "user_12345",
  prescriptionNumber: "RX-2025-001234",
  
  // Images
  images: [
    {
      url: "https://storage.googleapis.com/.../prescription-page1.jpg",
      thumbnail: "https://storage.googleapis.com/.../prescription-page1-thumb.jpg",
      page: 1,
      uploadedAt: timestamp("2025-11-30T09:30:00Z"),
      size: 2048576, // bytes
      format: "image/jpeg"
    }
  ],
  
  // Prescription Details
  details: {
    patientName: "John Doe",
    patientAge: 35,
    doctorName: "Dr. Sarah Smith",
    doctorLicense: "MD123456",
    clinic: "Medical Center",
    prescriptionDate: timestamp("2025-11-28T00:00:00Z"),
    expiryDate: timestamp("2026-02-28T00:00:00Z")
  },
  
  // Medications
  medications: [
    {
      name: "Amoxicillin",
      dosage: "500mg",
      frequency: "3 times daily",
      duration: "7 days",
      quantity: 21,
      instructions: "Take with food"
    }
  ],
  
  // Verification
  verification: {
    status: "verified", // pending, verified, rejected, expired
    verifiedBy: "pharmacist_001",
    verifiedAt: timestamp("2025-11-30T10:00:00Z"),
    notes: "Valid prescription, no contraindications found",
    rejectionReason: null
  },
  
  // Usage
  usage: {
    linkedOrders: ["order_12345"],
    usedQuantity: 10,
    remainingQuantity: 11,
    lastUsed: timestamp("2025-11-30T10:15:00Z")
  },
  
  // Status
  status: "active", // active, used, expired, cancelled
  
  // Timestamps
  createdAt: timestamp("2025-11-30T09:30:00Z"),
  updatedAt: timestamp("2025-11-30T10:00:00Z")
}
```

#### Reviews Collection
```javascript
/reviews/{reviewId}
{
  // Review Information
  userId: "user_12345",
  productId: "product_12345",
  orderId: "order_12345",
  rating: 5,
  title: "Excellent product!",
  content: "This product worked exactly as expected. Fast delivery and great quality.",
  
  // Media
  images: [
    {
      url: "https://storage.googleapis.com/.../review-image1.jpg",
      thumbnail: "https://storage.googleapis.com/.../review-image1-thumb.jpg"
    }
  ],
  
  // Verification
  isVerifiedPurchase: true,
  isRecommended: true,
  
  // Engagement
  helpfulVotes: 12,
  totalVotes: 15,
  response: {
    content: "Thank you for your feedback!",
    respondedBy: "merchant_001",
    respondedAt: timestamp("2025-11-30T11:00:00Z")
  },
  
  // Moderation
  status: "approved", // pending, approved, rejected, hidden
  flagged: false,
  flaggedReason: null,
  
  // Timestamps
  createdAt: timestamp("2025-11-30T10:45:00Z"),
  updatedAt: timestamp("2025-11-30T11:00:00Z")
}
```

## 3. Firebase Storage Structure

### 3.1 Storage Bucket Organization
```
pharmacy-app-graduation.appspot.com/
├── products/
│   ├── {productId}/
│   │   ├── images/
│   │   │   ├── main.jpg
│   │   │   ├── thumbnail.jpg
│   │   │   └── gallery/
│   │   │       ├── 1.jpg
│   │   │       ├── 2.jpg
│   │   │       └── 3.jpg
│   │   └── documents/
│   │       ├── safety-sheet.pdf
│   │       └── instructions.pdf
├── users/
│   ├── {userId}/
│   │   ├── avatar/
│   │   │   ├── original.jpg
│   │   │   └── thumbnail.jpg
│   │   └── documents/
│   │       ├── id-card.jpg
│   │       └── medical-record.pdf
├── prescriptions/
│   ├── {userId}/
│   │   ├── {prescriptionId}/
│   │   │   ├── page1.jpg
│   │   │   ├── page1-thumb.jpg
│   │   │   ├── page2.jpg
│   │   │   └── page2-thumb.jpg
├── categories/
│   ├── {categoryId}/
│   │   ├── image.jpg
│   │   ├── icon.svg
│   │   └── banner.jpg
├── reviews/
│   ├── {reviewId}/
│   │   ├── images/
│   │   │   ├── 1.jpg
│   │   │   └── 1-thumb.jpg
└── system/
    ├── logos/
    ├── banners/
    └── placeholders/
```

### 3.2 File Naming Conventions
```
Products:
- products/{productId}/images/main_{timestamp}.jpg
- products/{productId}/images/thumb_{timestamp}.jpg
- products/{productId}/images/gallery/{order}_{timestamp}.jpg

Users:
- users/{userId}/avatar/original_{timestamp}.jpg
- users/{userId}/avatar/thumb_{timestamp}.jpg

Prescriptions:
- prescriptions/{userId}/{prescriptionId}/page{number}_{timestamp}.jpg
- prescriptions/{userId}/{prescriptionId}/page{number}_thumb_{timestamp}.jpg

Categories:
- categories/{categoryId}/image_{timestamp}.jpg
- categories/{categoryId}/icon_{timestamp}.svg
```

## 4. Security Rules

### 4.1 Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    function isValidUser(data) {
      return data.keys().hasAll(['email', 'username']) &&
        data.email is string &&
        data.username is string &&
        data.username.size() >= 3 &&
        data.username.size() <= 30;
    }
    
    function isValidProduct(data) {
      return data.keys().hasAll(['name', 'price', 'category']) &&
        data.name is string &&
        data.price is number &&
        data.price >= 0 &&
        data.category is string;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write: if isOwner(userId);
      allow create: if isAuthenticated() && isOwner(userId) && isValidUser(resource.data);
      allow update: if isOwner(userId) && isValidUser(resource.data);
    }
    
    // Products collection
    match /products/{productId} {
      allow read: if true; // Public read access
      allow create: if isAdmin() && isValidProduct(resource.data);
      allow update: if isAdmin() && isValidProduct(resource.data);
      allow delete: if isAdmin();
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read: if true; // Public read access
      allow write: if isAdmin();
    }
    
    // Cart collection (using userId as document ID)
    match /cart/{userId} {
      allow read, write: if isOwner(userId);
      allow create: if isOwner(userId);
    }
    
    // Orders collection
    match /orders/{orderId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if isOwner(resource.data.userId);
      allow update: if isAdmin(); // Only admins can update order status
    }
    
    // Prescriptions collection
    match /prescriptions/{prescriptionId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // Favorites collection
    match /favourites/{favouriteId} {
      allow read, write: if isOwner(resource.data.userId);
      allow create: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Reviews collection
    match /reviews/{reviewId} {
      allow read: if true; // Public read access
      allow create: if isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // Addresses collection
    match /addresses/{addressId} {
      allow read, write: if isOwner(resource.data.userId);
      allow create: if isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId);
      allow delete: if isOwner(resource.data.userId);
    }
    
    // Admin collection (for admin user management)
    match /admins/{adminId} {
      allow read, write: if isAdmin();
    }
  }
}
```

### 4.2 Firebase Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isAdmin() {
      return isAuthenticated() && 
        exists(/databases/$(database)/documents/admins/$(request.auth.uid));
    }
    
    // Product images - public read, admin write
    match /products/{productId}/{allPaths=**} {
      allow read: if true;
      allow write: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // User files - owner only
    match /users/{userId}/{allPaths=**} {
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);
      allow delete: if isOwner(userId);
    }
    
    // Prescription images - strict access control
    match /prescriptions/{userId}/{prescriptionId}/{allPaths=**} {
      allow read: if isOwner(userId) || isAdmin();
      allow write: if isOwner(userId);
      allow delete: if isOwner(userId) || isAdmin();
    }
    
    // Category images - public read, admin write
    match /categories/{categoryId}/{allPaths=**} {
      allow read: if true;
      allow write: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // Review images - public read, owner write
    match /reviews/{reviewId}/{allPaths=**} {
      allow read: if true;
      allow write: if isOwner(resource.data.userId) || isAdmin();
      allow delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // System files - admin only
    match /system/{allPaths=**} {
      allow read, write: if isAdmin();
      allow delete: if isAdmin();
    }
    
    // File size and type validation
    match /{allPaths=**} {
      allow write: if request.resource.size < 10 * 1024 * 1024 && // 10MB limit
        (request.resource.contentType.matches('image/.*') ||
         request.resource.contentType.matches('application/pdf'));
    }
  }
}
```

## 5. Index Configuration

### 5.1 Composite Indexes
```javascript
// Auto-generated indexes for common queries

// Products - search and filtering
products: [
  {
    "collectionGroup": "products",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "category", "order": "ASCENDING"},
      {"fieldPath": "price", "order": "ASCENDING"}
    ]
  },
  {
    "collectionGroup": "products",
    "queryScope": "COLLECTION", 
    "fields": [
      {"fieldPath": "status", "order": "ASCENDING"},
      {"fieldPath": "featured", "order": "ASCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  },
  {
    "collectionGroup": "products",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "tags", "arrayConfig": "CONTAINS"},
      {"fieldPath": "rating.average", "order": "DESCENDING"}
    ]
  }
]

// Orders - user queries
orders: [
  {
    "collectionGroup": "orders",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "userId", "order": "ASCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  },
  {
    "collectionGroup": "orders", 
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "status", "order": "ASCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  }
]

// Reviews - product queries
reviews: [
  {
    "collectionGroup": "reviews",
    "queryScope": "COLLECTION",
    "fields": [
      {"fieldPath": "productId", "order": "ASCENDING"},
      {"fieldPath": "rating", "order": "DESCENDING"}
    ]
  },
  {
    "collectionGroup": "reviews",
    "queryScope": "COLLECTION", 
    "fields": [
      {"fieldPath": "productId", "order": "ASCENDING"},
      {"fieldPath": "createdAt", "order": "DESCENDING"}
    ]
  }
]
```

### 5.2 Single Field Indexes
```javascript
// Products collection indexes
"products": {
  "fields": [
    {"name": "name", "mode": "ASCENDING"},
    {"name": "category", "mode": "ASCENDING"},
    {"name": "price", "mode": "ASCENDING"},
    {"name": "rating.average", "mode": "ASCENDING"},
    {"name": "status", "mode": "ASCENDING"},
    {"name": "featured", "mode": "ASCENDING"},
    {"name": "tags", "mode": "ASCENDING"},
    {"name": "createdAt", "mode": "ASCENDING"},
    {"name": "updatedAt", "mode": "ASCENDING"}
  ]
}

// Orders collection indexes
"orders": {
  "fields": [
    {"name": "userId", "mode": "ASCENDING"},
    {"name": "status", "mode": "ASCENDING"},
    {"name": "paymentStatus", "mode": "ASCENDING"},
    {"name": "orderNumber", "mode": "ASCENDING"},
    {"name": "createdAt", "mode": "ASCENDING"},
    {"name": "updatedAt", "mode": "ASCENDING"}
  ]
}

// Prescriptions collection indexes
"prescriptions": {
  "fields": [
    {"name": "userId", "mode": "ASCENDING"},
    {"name": "status", "mode": "ASCENDING"},
    {"name": "verification.status", "mode": "ASCENDING"},
    {"name": "createdAt", "mode": "ASCENDING"},
    {"name": "expiryDate", "mode": "ASCENDING"}
  ]
}
```

## 6. Firebase Configuration Files

### 6.1 firebase.json
```json
{
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ]
  },
  "functions": {
    "predeploy": [
      "npm --prefix \"$RESOURCE_DIR\" run lint",
      "npm --prefix \"$RESOURCE_DIR\" run build"
    ]
  },
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "storage": {
      "port": 9199
    },
    "hosting": {
      "port": 5000
    },
    "ui": {
      "enabled": true,
      "port": 4000
    },
    "singleProjectMode": true
  }
}
```

### 6.2 firestore.indexes.json
```json
{
  "indexes": [
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "category",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "price",
          "order": "ASCENDING"
        }
      ]
    },
    {
      "collectionGroup": "products",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "featured",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    }
  ],
  "fieldOverrides": [
    {
      "collectionGroup": "products",
      "fieldPath": "tags",
      "indexes": [
        {
          "order": "ASCENDING",
          "queryScope": "COLLECTION"
        },
        {
          "arrayConfig": "CONTAINS",
          "queryScope": "COLLECTION"
        }
      ]
    }
  ]
}
```

## 7. Data Migration Scripts

### 7.1 Initial Data Setup
```javascript
// Initialize categories
const categories = [
  {
    name: "Pain Relief",
    description: "Medications for pain management",
    slug: "pain-relief",
    icon: "pill",
    color: "#2196F3"
  },
  {
    name: "Cold & Flu",
    description: "Cold and flu medications",
    slug: "cold-flu",
    icon: "thermometer",
    color: "#4CAF50"
  }
];

// Batch write categories
const batch = db.batch();
categories.forEach(category => {
  const docRef = db.collection('categories').doc();
  batch.set(docRef, {
    ...category,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    status: 'active',
    isActive: true,
    productCount: 0
  });
});
await batch.commit();
```

### 7.2 Sample Products Data
```javascript
// Sample product data
const sampleProducts = [
  {
    name: "Paracetamol 500mg",
    description: "Effective pain relief medication",
    category: "pain-relief",
    price: 12.99,
    inventory: { quantity: 150, available: 150 },
    medical: {
      dosage: "500mg",
      form: "tablet",
      requiresPrescription: false
    },
    status: "active"
  }
];

// Import products
for (const product of sampleProducts) {
  await db.collection('products').add({
    ...product,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    rating: { average: 0, count: 0 }
  });
}
```

## 8. Backup and Recovery

### 8.1 Automated Backup Configuration
```javascript
// Cloud Function for daily backups
exports.dailyBackup = functions.pubsub
  .schedule('0 2 * * *') // Daily at 2 AM
  .timeZone('America/New_York')
  .onRun(async (context) => {
    const backup = {
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      collections: {}
    };
    
    // Backup each collection
    const collections = ['users', 'products', 'orders', 'cart', 'prescriptions'];
    
    for (const collectionName of collections) {
      const snapshot = await db.collection(collectionName).get();
      backup.collections[collectionName] = snapshot.docs.map(doc => ({
        id: doc.id,
        data: doc.data()
      }));
    }
    
    // Save backup to storage
    const backupRef = storage.bucket().file(`backups/${Date.now()}.json`);
    await backupRef.save(JSON.stringify(backup));
    
    console.log('Backup completed successfully');
  });
```

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Firebase Project**: pharmacy-app-graduation  
**Environment**: Production
