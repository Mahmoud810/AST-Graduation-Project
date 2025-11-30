# 🗄️ Pharmacy Application - Database Design Documentation

## Overview
This document outlines the complete database design for the Pharmacy Application using Firebase Firestore and Firebase Storage.

## 1. Firebase Firestore Collections

### 1.1 Users Collection
```javascript
users/{userId}
{
  email: "user@example.com",
  username: "john_doe",
  phone: "+1234567890",
  createdAt: timestamp,
  lastLogin: timestamp,
  profile: {
    firstName: "John",
    lastName: "Doe",
    dateOfBirth: timestamp,
    gender: "male|female|other"
  },
  addresses: [
    {
      id: "address_id",
      type: "home|work|other",
      street: "123 Main St",
      city: "City",
      state: "State",
      zipCode: "12345",
      isDefault: true
    }
  ],
  preferences: {
    notifications: true,
    emailMarketing: false,
    language: "en"
  }
}
```

### 1.2 Products Collection
```javascript
products/{productId}
{
  name: "Paracetamol 500mg",
  description: "Pain relief medication",
  category: "pain_relief",
  subcategory: "fever_reducer",
  price: 12.99,
  currency: "USD",
  images: [
    "https://storage.googleapis.com/.../product1.jpg",
    "https://storage.googleapis.com/.../product2.jpg"
  ],
  inStock: true,
  quantity: 150,
  requiresPrescription: false,
  manufacturer: "PharmaCorp",
  brand: "MediBrand",
  dosage: "500mg",
  form: "tablet|capsule|liquid|cream",
  ageRestriction: null,
  tags: ["pain", "fever", "headache"],
  rating: 4.5,
  reviewCount: 128,
  createdAt: timestamp,
  updatedAt: timestamp,
  isActive: true
}
```

### 1.3 Cart Collection
```javascript
cart/{cartId}
{
  userId: "user_id_reference",
  items: [
    {
      productId: "product_id_reference",
      quantity: 2,
      addedAt: timestamp,
      price: 12.99,
      requiresPrescription: false
    }
  ],
  totalAmount: 25.98,
  currency: "USD",
  createdAt: timestamp,
  updatedAt: timestamp,
  isActive: true
}
```

### 1.4 Favorites Collection
```javascript
favourites/{favouriteId}
{
  userId: "user_id_reference",
  productId: "product_id_reference",
  addedAt: timestamp
}
```

### 1.5 Orders Collection
```javascript
orders/{orderId}
{
  userId: "user_id_reference",
  orderNumber: "ORD-2025-001234",
  items: [
    {
      productId: "product_id_reference",
      quantity: 2,
      price: 12.99,
      totalPrice: 25.98,
      requiresPrescription: false
    }
  ],
  totalAmount: 25.98,
  currency: "USD",
  status: "pending|confirmed|preparing|ready|delivered|cancelled",
  paymentStatus: "pending|paid|failed|refunded",
  paymentMethod: "cod|card|online",
  orderDate: timestamp,
  estimatedDelivery: timestamp,
  actualDelivery: timestamp,
  deliveryAddress: {
    street: "123 Main St",
    city: "City",
    state: "State",
    zipCode: "12345",
    instructions: "Ring doorbell"
  },
  prescriptionIds: ["prescription_id_1"],
  trackingNumber: "TRACK123456",
  notes: "Customer requested special packaging",
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### 1.6 Prescriptions Collection
```javascript
prescriptions/{prescriptionId}
{
  userId: "user_id_reference",
  images: [
    "https://storage.googleapis.com/.../prescription1.jpg",
    "https://storage.googleapis.com/.../prescription2.jpg"
  ],
  uploadDate: timestamp,
  status: "pending|verified|rejected|expired",
  verifiedBy: "pharmacist_id",
  verifiedDate: timestamp,
  expiryDate: timestamp,
  notes: "Valid for 3 months",
  linkedProducts: ["product_id_1", "product_id_2"],
  doctor: {
    name: "Dr. Smith",
    license: "MD12345",
    clinic: "Medical Center"
  },
  patient: {
    name: "John Doe",
    age: 35,
    weight: "70kg"
  },
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### 1.7 Categories Collection
```javascript
categories/{categoryId}
{
  name: "Pain Relief",
  description: "Medications for pain and fever",
  image: "https://storage.googleapis.com/.../category.jpg",
  icon: "pain_relief_icon",
  parentId: null,
  order: 1,
  isActive: true,
  productCount: 45,
  createdAt: timestamp
}
```

### 1.8 Reviews Collection
```javascript
reviews/{reviewId}
{
  userId: "user_id_reference",
  productId: "product_id_reference",
  orderId: "order_id_reference",
  rating: 5,
  title: "Very effective",
  comment: "This product worked great for my headache",
  images: [],
  helpfulVotes: 12,
  isVerifiedPurchase: true,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## 2. Firebase Storage Structure

### 2.1 Product Images
```
products/
├── {productId}/
│   ├── main.jpg
│   ├── thumbnail.jpg
│   ├── gallery/
│   │   ├── 1.jpg
│   │   ├── 2.jpg
│   │   └── 3.jpg
```

### 2.2 Prescription Images
```
prescriptions/
├── {userId}/
│   ├── {prescriptionId}/
│   │   ├── page1.jpg
│   │   ├── page2.jpg
│   │   └── thumbnail.jpg
```

### 2.3 User Profile Images
```
users/
├── {userId}/
│   ├── profile.jpg
│   └── thumbnail.jpg
```

### 2.4 Category Images
```
categories/
├── {categoryId}/
│   ├── image.jpg
│   └── icon.svg
```

## 3. Database Relationships

### 3.1 Entity Relationship Diagram

```
User (1) ←→ (N) Cart
User (1) ←→ (N) Orders
User (1) ←→ (N) Prescriptions
User (1) ←→ (N) Favorites
User (1) ←→ (N) Reviews

Product (1) ←→ (N) Cart Items
Product (1) ←→ (N) Order Items
Product (1) ←→ (N) Favorites
Product (1) ←→ (N) Reviews
Product (N) ←→ (1) Category

Order (1) ←→ (N) Prescriptions
Order (1) ←→ (N) Reviews

Category (1) ←→ (N) Products
Category (N) ←→ (N) Category (self-referencing for hierarchy)
```

### 3.2 Key Relationships

#### User-Cart Relationship
- **Type**: One-to-One
- **Implementation**: Cart document contains userId field
- **Constraints**: Each user has exactly one active cart

#### User-Orders Relationship
- **Type**: One-to-Many
- **Implementation**: Orders collection contains userId field
- **Constraints**: User can have multiple orders over time

#### Product-Cart Relationship
- **Type**: Many-to-Many
- **Implementation**: Cart items array in cart document
- **Constraints**: Same product can appear in multiple carts

#### Prescription-Order Relationship
- **Type**: Many-to-Many
- **Implementation**: Order contains prescriptionIds array
- **Constraints**: One prescription can be used for multiple orders

## 4. Security Rules

### 4.1 Firestore Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Cart rules - users can only access their own cart
    match /cart/{cartId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // Products are publicly readable, only admin can write
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null && 
        isAdmin(request.auth.uid);
    }
    
    // Orders - users can only access their own orders
    match /orders/{orderId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // Prescriptions - strict access control
    match /prescriptions/{prescriptionId} {
      allow read: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // Favorites - user-specific access
    match /favourites/{favouriteId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // Reviews - users can read all, write their own
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
      allow update: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}

function isAdmin(uid) {
  return exists(/databases/$(database)/documents/admins/$(uid));
}
```

### 4.2 Storage Security Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // User profile images
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Prescription images - strict access
    match /prescriptions/{userId}/{prescriptionId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Product images - public read, admin write
    match /products/{productId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && isAdmin(request.auth.uid);
    }
    
    // Category images - public read, admin write
    match /categories/{categoryId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && isAdmin(request.auth.uid);
    }
  }
}
```

## 5. Indexing Strategy

### 5.1 Composite Indexes
```javascript
// Products - search and filtering
products: [
  ["category", "ASC"],
  ["price", "ASC"]
],
[
  ["inStock", "ASC"],
  ["rating", "DESC"]
],
[
  ["requiresPrescription", "ASC"],
  ["category", "ASC"]
]

// Orders - user queries
orders: [
  ["userId", "ASC"],
  ["orderDate", "DESC"]
],
[
  ["status", "ASC"],
  ["orderDate", "DESC"]
]

// Reviews - product queries
reviews: [
  ["productId", "ASC"],
  ["rating", "DESC"]
],
[
  ["productId", "ASC"],
  ["createdAt", "DESC"]
]
```

### 5.2 Single Field Indexes
```javascript
// Products
products.name: array
products.tags: array
products.category: ascending
products.price: ascending
products.rating: ascending

// Orders
orders.status: ascending
orders.orderDate: ascending
orders.userId: ascending

// Prescriptions
prescriptions.userId: ascending
prescriptions.status: ascending
```

## 6. Data Validation

### 6.1 Product Data Validation
```javascript
// Required fields validation
validateProduct = {
  name: isString() && isNotEmpty(),
  price: isNumber() && isGreaterThan(0),
  category: isString() && isIn(validCategories),
  inStock: isBoolean(),
  requiresPrescription: isBoolean()
}
```

### 6.2 User Data Validation
```javascript
validateUser = {
  email: isEmail(),
  username: isString() && lengthBetween(3, 30),
  phone: isPhoneNumber() || isNull()
}
```

## 7. Performance Optimization

### 7.1 Data Modeling Best Practices
- **Denormalization**: Duplicate frequently accessed data
- **Batch Operations**: Use batch writes for multiple documents
- **Pagination**: Implement cursor-based pagination
- **Caching**: Cache frequently accessed products

### 7.2 Query Optimization
```javascript
// Efficient product queries
db.collection('products')
  .where('category', '==', 'pain_relief')
  .where('inStock', '==', true)
  .orderBy('rating', 'desc')
  .limit(20)

// Cart optimization with transactions
const batch = db.batch();
batch.update(cartRef, { items: newItems, totalAmount: newTotal });
batch.update(productRef, { quantity: FieldValue.increment(-quantity) });
await batch.commit();
```

## 8. Backup and Recovery

### 8.1 Data Backup Strategy
- **Daily Backups**: Automated daily exports
- **Point-in-Time Recovery**: 7-day retention
- **Cross-Region Replication**: Multi-region setup
- **Export Format**: JSON and CSV formats

### 8.2 Recovery Procedures
1. **Identify Corruption**: Monitor data integrity
2. **Select Recovery Point**: Choose appropriate backup
3. **Restore Process**: Import data to staging first
4. **Validation**: Verify data integrity
5. **Cutover**: Switch to restored data

## 9. Migration Strategy

### 9.1 Schema Versioning
```javascript
// Schema version tracking
schema_info: {
  version: "1.0.0",
  lastUpdated: timestamp,
  migrationHistory: [
    {
      version: "1.0.0",
      date: timestamp,
      description: "Initial schema"
    }
  ]
}
```

### 9.2 Migration Process
1. **Planning**: Define migration steps
2. **Backup**: Create full backup
3. **Testing**: Test on staging environment
4. **Execution**: Run migration scripts
5. **Validation**: Verify data integrity
6. **Monitoring**: Watch for issues

## 10. Monitoring and Analytics

### 10.1 Database Metrics
- **Query Performance**: Monitor slow queries
- **Storage Usage**: Track storage consumption
- **Read/Write Operations**: Monitor API usage
- **Error Rates**: Track failed operations

### 10.2 Analytics Events
```javascript
// Track user interactions
analytics.logEvent('product_viewed', {
  product_id: productId,
  category: category,
  user_id: userId
});

analytics.logEvent('cart_updated', {
  user_id: userId,
  items_count: items.length,
  total_amount: totalAmount
});
```

---

**Document Version**: 1.0  
**Last Updated**: November 2025  
**Database**: Firebase Firestore  
**Storage**: Firebase Storage
