# Screen Directory Structure

This document describes the organized screen directory structure.

## Directory Organization

```
lib/screens/
??? auth/                    # Authentication screens
?   ??? login_screen.dart
?   ??? otp_verification_screen.dart
?
??? home/                    # Main navigation shell
?   ??? home_screen.dart
?
??? events/                  # Event-related screens
?   ??? events_screen.dart
?   ??? event_detail_screen.dart
?
??? vouchers/                # Voucher-related screens
?   ??? vouchers_screen.dart
?   ??? voucher_detail_screen.dart
?
??? cart/                    # Shopping cart screen
?   ??? cart_screen.dart
?
??? checkout/                # Checkout screen
    ??? checkout_screen.dart
```

## Feature-Based Organization

- **auth/**: All authentication flows (login, OTP verification)
- **home/**: Main navigation container with bottom navigation
- **events/**: Event browsing and detail views
- **vouchers/**: Voucher browsing and detail views
- **cart/**: Shopping cart management
- **checkout/**: Order completion flow

## Benefits

1. **Clear Organization**: Easy to find screens by feature
2. **Scalability**: Easy to add new screens within their feature directory
3. **Maintainability**: Related screens are grouped together
4. **Navigation**: Clear structure makes code navigation easier
