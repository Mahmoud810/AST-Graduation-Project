#!/bin/bash

echo "🔥 Deploying Firebase Rules..."

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Please install it first:"
    echo "   npm install -g firebase-tools"
    exit 1
fi

# Deploy Firestore rules
echo "📚 Deploying Firestore rules..."
firebase deploy --only firestore:rules

# Deploy Storage rules  
echo "📦 Deploying Storage rules..."
firebase deploy --only storage:rules

echo "✅ Firebase rules deployed successfully!"
