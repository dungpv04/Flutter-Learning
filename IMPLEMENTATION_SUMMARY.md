# BTTH02 - Flutter Application Summary

## Project Overview
This Flutter application implements five comprehensive form-based exercises as required by the CSE441 assignment:

### 📝 Exercise 1: Registration Form & OTP Verification
**File**: `registration_screen.dart`, `otp_verification_screen.dart`

**Features Implemented:**
- ✅ Full name input with validation
- ✅ Email input with format validation
- ✅ Phone number input (10 digits only)
- ✅ Password & confirm password (minimum 6 characters)
- ✅ Date picker for birth date
- ✅ Gender selection (Radio buttons: Nam/Nữ/Khác)
- ✅ Terms & conditions checkbox
- ✅ Form validation before submission
- ✅ SQLite data storage
- ✅ OTP verification screen (6 digits)
- ✅ Default OTP: "123456"
- ✅ Resend OTP functionality with 60-second countdown
- ✅ Success dialog after verification

### 🏠 Exercise 2: Address Form & Map Integration
**Files**: `address_screen.dart`, `address_list_screen.dart`, `map_picker_screen.dart`

**Features Implemented:**
- ✅ Recipient name input
- ✅ Phone number input
- ✅ Province/City dropdown
- ✅ District dropdown (dependent on province selection)
- ✅ Ward dropdown (dependent on district selection)
- ✅ Detailed address input (multiline)
- ✅ Map location picker (simulated)
- ✅ Address list management
- ✅ Edit/delete address functionality
- ✅ SQLite storage with coordinates

### 🛍️ Exercise 3: Product Form & Image Management
**Files**: `product_screen.dart`, `product_list_screen.dart`

**Features Implemented:**
- ✅ Product name input
- ✅ Price input (decimal support)
- ✅ Category dropdown selection
- ✅ Description input (multiline)
- ✅ Discount toggle switch
- ✅ Multiple image selection (gallery/camera)
- ✅ Image preview with remove functionality
- ✅ Product list with image gallery
- ✅ Edit/delete product functionality
- ✅ SQLite storage with image paths

### 🛒 Exercise 4: Order Wizard (Stepper Form)
**File**: `order_wizard_screen.dart`

**Features Implemented:**
- ✅ Multi-step form using Stepper widget
- ✅ Step 1: Customer information (name, email, phone)
- ✅ Step 2: Delivery address (province → district → ward cascade)
- ✅ Step 3: Payment method selection (cash/credit/transfer) & confirmation
- ✅ Step validation before proceeding
- ✅ Navigation between steps (next/previous)
- ✅ Order summary display
- ✅ Final confirmation checkbox
- ✅ Success dialog with order completion

### 🔍 Exercise 5: Product Filter & Dynamic Search
**File**: `product_filter_screen.dart`

**Features Implemented:**
- ✅ Price range filter (min/max input)
- ✅ Category dropdown filter
- ✅ Sort options (name A-Z, price ascending/descending, newest)
- ✅ Discount checkbox filter
- ✅ Available stock checkbox filter
- ✅ Real-time filter application
- ✅ Dynamic results display
- ✅ Results counter
- ✅ Reset filters functionality
- ✅ Empty state when no results found

## 🗄️ Database Structure (SQLite)

### Tables Created:
1. **users** - Store registration data
   - id, fullName, email, phoneNumber, password, birthDate, gender, createdAt

2. **addresses** - Store address information
   - id, recipientName, phoneNumber, province, district, ward, detailAddress, latitude, longitude, createdAt

3. **products** - Store product details
   - id, name, price, description, category, isDiscounted, createdAt

4. **product_images** - Store product image paths
   - id, productId, imagePath

## 🎨 UI/UX Features

### Design Elements:
- ✅ Material Design components
- ✅ Color-coded screens (Green for Registration, Orange for Address, Purple for Products)
- ✅ Form validation with error messages
- ✅ Loading indicators
- ✅ Empty state screens
- ✅ Confirmation dialogs
- ✅ Success/error snackbars
- ✅ Responsive layout

### Navigation:
- ✅ Home screen with menu cards
- ✅ Screen-to-screen navigation
- ✅ Back navigation
- ✅ Navigation to list screens from forms

## 📱 App Flow

1. **Home Screen** → Main menu with 5 exercise options
2. **Registration Flow** → Form → OTP → Success
3. **Address Flow** → Form → Map Picker → List Management
4. **Product Flow** → Form → Image Selection → List Management
5. **Order Wizard Flow** → Customer Info → Delivery Address → Payment → Confirmation
6. **Filter Flow** → Product Search → Dynamic Results → Real-time Updates

## 🛠️ Technical Implementation

### Dependencies Used:
- `sqflite` - SQLite database
- `path` - Path operations
- `shared_preferences` - Local storage
- `image_picker` - Camera/gallery access
- `intl` - Date formatting

### Code Organization:
```
lib/
├── main.dart                    # App entry point
├── database/
│   └── database_helper.dart     # SQLite operations
├── models/
│   └── data_models.dart         # Data model classes
├── screens/                     # All UI screens
├── utils/
│   └── app_utils.dart          # Utilities & constants
```

### Validation Logic:
- Required field validation
- Email format checking
- Phone number length validation
- Password strength verification
- Price numeric validation

## ✅ Requirements Compliance

**All PDF requirements have been implemented:**

1. ✅ **Bài 1**: Complete registration form with all specified fields and validation
2. ✅ **Bài 2**: Address form with dependent dropdowns and map integration
3. ✅ **Bài 3**: Product form with multiple controls and image handling
4. ✅ **Bài 4**: Multi-step order form using Stepper widget with validation
5. ✅ **Bài 5**: Dynamic product filter with real-time search results
6. ✅ **SQLite Storage**: All data stored in local database
7. ✅ **Form Validation**: Comprehensive validation for all inputs
8. ✅ **OTP Verification**: Working OTP system with resend functionality
9. ✅ **Map Integration**: Simulated map picker for location selection
10. ✅ **Image Management**: Multiple image upload and preview
11. ✅ **Step Navigation**: Wizard-style navigation with validation
12. ✅ **Dynamic Filtering**: Real-time search and filter functionality

## 🚀 How to Run

1. Ensure Flutter is installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application
4. Test with default OTP: "123456"

## 📋 Testing Checklist

- ✅ Registration form validation
- ✅ OTP verification (use "123456")
- ✅ Address form with dropdowns
- ✅ Map location picker
- ✅ Product form with images
- ✅ List management (view/edit/delete)
- ✅ Order wizard step navigation
- ✅ Order wizard validation
- ✅ Product filter functionality
- ✅ Dynamic search results
- ✅ Database operations
- ✅ Image handling

**Note**: This implementation provides a solid foundation for form handling and data storage in Flutter, following the assignment requirements while maintaining clean code structure and user-friendly interface.
