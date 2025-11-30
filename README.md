# Event & Voucher App

A Flutter application for selling event tickets and vouchers with a modern, beautiful UI.

## Features

- ?? **Event Tickets**: Browse and purchase tickets for various events
- ?? **Vouchers**: Browse and purchase discount vouchers
- ?? **Shopping Cart**: Add items to cart and manage quantities
- ?? **Checkout**: Complete purchase with contact and payment information
- ?? **Modern UI**: Beautiful Material Design 3 interface
- ?? **Dark Mode**: Automatic dark mode support

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
??? main.dart                 # App entry point
??? models/                   # Data models
?   ??? event.dart
?   ??? voucher.dart
?   ??? cart_item.dart
??? providers/               # State management
?   ??? cart_provider.dart
??? services/                # Business logic
?   ??? event_service.dart
?   ??? voucher_service.dart
??? screens/                 # UI screens
?   ??? home_screen.dart
?   ??? events_screen.dart
?   ??? event_detail_screen.dart
?   ??? vouchers_screen.dart
?   ??? voucher_detail_screen.dart
?   ??? cart_screen.dart
?   ??? checkout_screen.dart
??? widgets/                 # Reusable widgets
?   ??? event_card.dart
?   ??? voucher_card.dart
??? theme/                   # App theme
    ??? app_theme.dart
```

## Features Overview

### Events
- Browse events by category
- View event details (date, venue, location, price)
- Add tickets to cart with quantity selection

### Vouchers
- Browse vouchers by category
- View voucher details with discount information
- Add vouchers to cart with quantity selection

### Shopping Cart
- View all items in cart
- Update quantities
- Remove items
- View total price

### Checkout
- Enter contact information
- Enter payment details
- Complete purchase

## Dependencies

- `provider`: State management
- `intl`: Date and number formatting
- `http`: HTTP requests (for future API integration)

## License

This project is open source and available for modification.
