# StockSense

StockSense is a Flutter-based full-stack mobile inventory and stock management application for small retail businesses.

## Problem
Small retail businesses often rely on manual stock counts or spreadsheets, which can cause inaccurate inventory records, missed low-stock items, duplicate entries, and slow product identification.

## Solution
StockSense will provide a mobile workflow for staff to:

- View inventory and stock levels
- Add, edit, and delete product records
- Search and filter products
- Identify low-stock items
- Scan product barcodes/QR codes using the device camera
- Persist product data remotely using Firebase Firestore
- Display clear validation and error feedback

## Planned Screens
1. Dashboard
2. Inventory List
3. Product Details
4. Add / Edit Product
5. Barcode Scanner
6. Settings / About

## Technology Stack
- Flutter / Dart
- Firebase Firestore
- Firebase Core
- Camera-based barcode/QR scanning
- GitHub for version control and collaboration

## Architecture
Flutter UI → Services / State → Firebase Firestore

Camera Sensor → Barcode/QR value → Product lookup → Inventory record

## Team Workstreams
- **Sakif:** app structure, navigation, UI/UX, dashboard, inventory list, integration, documentation coordination
- **Nikesh:** Firebase, Firestore data layer, product model, CRUD operations, validation, backend error handling
- **Kamal:** camera/barcode integration, product detail flow, low-stock behaviour, testing and sensor validation

All team members will contribute to testing, documentation, GitHub collaboration, and the final presentation.

## Project Requirements
The final solution will include at least five functional screens, meaningful device sensor integration, remote data persistence, read/write backend operations, validation and error handling, secure communication, professional documentation, and a live stakeholder demonstration.

## Status
Project setup in progress.
