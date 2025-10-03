# BTTH02 - Flutter Forms & Data Storage

Flutter application implementing forms and data storage practice (CSE441 Assignment 02).

## Features

### 1. Registration Form (Bài 1)
- **User Registration with Validation**
  - Full name (required)
  - Email (with format validation)
  - Phone number (10 digits only)
  - Password & confirm password (min 6 characters, must match)
  - Birth date (date picker)
  - Gender selection (radio buttons: Nam/Nữ/Khác)
  - Terms & conditions checkbox
  
- **OTP Verification**
  - 6-digit OTP input
  - Default OTP: "123456"
  - Resend OTP functionality (60-second countdown)
  - Success notification

### 2. Address Form (Bài 2)
- **Address Management**
  - Recipient name
  - Phone number
  - Province/City dropdown
  - District dropdown (dependent on province)
  - Ward dropdown (dependent on district)
  - Detailed address (multiline)
  - Map location picker (optional)
  
- **Address List**
  - View all saved addresses
  - Edit existing addresses
  - Delete addresses with confirmation

### 3. Product Form (Bài 3)
- **Product Management**
  - Product name
  - Price (decimal numbers)
  - Description (multiline)
  - Category dropdown
  - Discount toggle switch
  - Multiple image selection (gallery/camera)
  
- **Product List**
  - View all products
  - Image gallery preview
  - Edit/delete products
  - Visual indicators for discounted items

### 4. Order Wizard (Bài 4)
- **Multi-Step Order Form (Stepper)**
  - Step 1: Customer information (name, email, phone)
  - Step 2: Delivery address (similar to address form)
  - Step 3: Payment method & confirmation
  - Navigation between steps
  - Form validation for each step
  - Order summary and confirmation

### 5. Product Filter (Bài 5)
- **Dynamic Product Search & Filter**
  - Price range filter (min/max)
  - Category dropdown filter
  - Sort options (name, price, date)
  - Discount filter (checkbox)
  - Available stock filter (checkbox)
  - Real-time filter application
  - Dynamic results display
  - Reset filters functionality

## Technical Implementation

### Database (SQLite)
- **Users table**: Store user registration data
- **Addresses table**: Store address information with optional coordinates
- **Products table**: Store product details
- **Product_images table**: Store product image paths

### Dependencies
- `sqflite`: SQLite database
- `path`: Path manipulation
- `shared_preferences`: Local storage
- `image_picker`: Camera/gallery access
- `intl`: Date formatting
- `google_maps_flutter`: Map integration (for future enhancement)
- `geolocator`: Location services (for future enhancement)

### Form Validation
- Required field validation
- Email format validation
- Phone number format and length validation
- Password strength and confirmation matching
- Numeric price validation

### Image Handling
- Multiple image selection from gallery
- Camera capture
- Image preview with remove functionality
- Error handling for broken images

## File Structure
```
lib/
├── main.dart                           # App entry point
├── database/
│   └── database_helper.dart            # SQLite database operations
├── models/
│   └── data_models.dart                # Data model classes
├── utils/
│   └── app_utils.dart                  # Utilities & constants
└── screens/
    ├── home_screen.dart                # Main menu
    ├── registration_screen.dart        # User registration form
    ├── otp_verification_screen.dart    # OTP verification
    ├── address_screen.dart             # Address form
    ├── address_list_screen.dart        # Address management
    ├── map_picker_screen.dart          # Map location picker
    ├── product_screen.dart             # Product form
    ├── product_list_screen.dart        # Product management
    ├── order_wizard_screen.dart        # Multi-step order form
    └── product_filter_screen.dart      # Product search & filter
```

## Usage

1. **Registration**: Fill out the registration form → verify with OTP "123456" → success
2. **Address**: Add addresses with location picker → manage in address list
3. **Product**: Create products with images → view in product gallery
4. **Order Wizard**: Step-by-step order creation → customer info → delivery → payment → confirm
5. **Product Filter**: Search and filter products → dynamic results → real-time updates

## Notes

- Map picker is simulated (no real Google Maps integration)
- Default OTP is "123456" for testing purposes
- Images are stored locally on device
- Sample location data is hardcoded for demonstration
