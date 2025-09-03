# Amazon Clone - Flutter E-commerce App

A full-stack Amazon clone built with Flutter and Node.js, featuring user authentication, product management, shopping cart, and admin panel functionality.

## 🚀 Features

### User Features
- **Authentication System** - User registration, login, and JWT-based authentication
- **Home Screen** - Featured products carousel, categories, and deal of the day
- **Product Browsing** - Category-wise product listing and search functionality  
- **Product Details** - Detailed product view with images, descriptions, and reviews
- **Shopping Cart** - Add to cart, quantity management, and checkout
- **User Account** - Profile management and order history
- **Search** - Advanced search with filters and suggestions

### Admin Features
- **Admin Dashboard** - Comprehensive admin panel for managing the store
- **Product Management** - Add, edit, and delete products with image uploads
- **Order Management** - Track and manage customer orders
- **Analytics** - Sales analytics and reporting

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Flutter SDK** - Cross-platform mobile development
- **Dart** - Programming language
- **Provider** - State management
- **Material Design 3** - Modern UI components

### Backend (Node.js)
- **Express.js** - Web framework for API development
- **MongoDB** - NoSQL database for data storage
- **Mongoose** - MongoDB object modeling
- **JWT** - JSON Web Tokens for authentication
- **bcryptjs** - Password hashing

## 📦 Dependencies

### Flutter Packages
```yaml
dependencies:
  http: ^1.4.0                    # HTTP requests
  provider: ^6.1.5               # State management
  shared_preferences: ^2.5.3     # Local data storage
  badges: ^3.1.2                 # UI badges for cart items
  carousel_slider: ^5.1.1        # Image carousel component
  dotted_border: ^3.1.0          # Dotted border widgets
  image_picker: ^1.1.2           # Image selection from gallery/camera
  cloudinary_public: ^0.23.1     # Cloud image storage and management
  google_fonts: ^6.2.1           # Custom Google Fonts
  cupertino_icons: ^1.0.8        # iOS-style icons
```

### Node.js Packages
```json
{
  "express": "^5.1.0",           // Web framework
  "mongoose": "^8.17.0",         // MongoDB object modeling
  "mongodb": "^6.18.0",          // MongoDB driver
  "bcryptjs": "^3.0.2",          // Password hashing
  "http": "^0.0.1-security"      // HTTP utilities
}
```

## 🏗️ Project Structure

### Flutter App Structure
```
lib/
├── core/
│   ├── constants/          # Global variables and constants
│   ├── models/            # Data models (User, Product)
│   ├── providers/         # State management providers
│   ├── routing/           # App routing and navigation
│   └── widgets/           # Reusable UI components
├── features/
│   ├── account/           # User account and orders
│   ├── admin/             # Admin panel functionality
│   ├── auth/              # Authentication screens
│   ├── cart/              # Shopping cart management
│   ├── home/              # Home screen and categories
│   ├── product_details/   # Product detail views
│   └── search/            # Search functionality
├── app.dart               # Main app configuration
└── main.dart              # App entry point
```

### Backend Structure
```
server/
├── middlewares/
│   ├── admin.js           # Admin authorization middleware
│   └── auth.js            # Authentication middleware
├── models/
│   ├── product.js         # Product data model
│   └── user.js            # User data model
├── routes/
│   ├── admin.js           # Admin API routes
│   ├── auth.js            # Authentication routes
│   └── product.js         # Product management routes
├── index.js               # Server entry point
└── package.json           # Node.js dependencies
```

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Node.js and npm
- MongoDB database
- Cloudinary account for image storage

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd amazon
```

2. **Setup Flutter App**
```bash
flutter pub get
```

3. **Setup Backend Server**
```bash
cd server
npm install
```

4. **Environment Variables**
Create a `.env` file in the server directory:
```env
MONGO_DB=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
```

5. **Run the Application**

Backend server:
```bash
cd server
npm run dev
```

Flutter app:
```bash
flutter run
```



The app includes:
- Modern Material Design 3 UI
- Responsive design for different screen sizes
- Smooth animations and transitions
- Image carousels and product galleries
- Interactive shopping cart with badges
- Professional admin dashboard

## 🔐 Authentication

- JWT-based authentication system
- Secure password hashing with bcrypt
- Role-based access control (User/Admin)
- Persistent login with shared preferences

## 💾 Data Storage

- **MongoDB** - Primary database for users, products, and orders
- **Cloudinary** - Cloud storage for product images
- **SharedPreferences** - Local storage for user sessions

## 🎨 UI/UX Features

- **Google Fonts** - Custom typography
- **Carousel Slider** - Interactive product showcases
- **Dotted Borders** - Elegant UI elements
- **Badges** - Visual cart item counters
- **Material Design 3** - Modern and consistent design system

---

*Built with ❤️ using Flutter and Node.js*
