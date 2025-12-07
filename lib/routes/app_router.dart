import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:event_and_voucher/services/event_service.dart';
import 'package:event_and_voucher/services/voucher_service.dart';
import 'package:event_and_voucher/providers/auth_provider.dart';
import 'package:event_and_voucher/screens/home/home_screen.dart';
import 'package:event_and_voucher/screens/events/events_screen.dart';
import 'package:event_and_voucher/screens/events/event_detail_screen.dart';
import 'package:event_and_voucher/screens/events/events_view_all_screen.dart';
import 'package:event_and_voucher/screens/events/search_screen.dart';
import 'package:event_and_voucher/screens/events/create_event_screen.dart';
import 'package:event_and_voucher/screens/events/edit_event_screen.dart';
import 'package:event_and_voucher/screens/vouchers/vouchers_screen.dart';
import 'package:event_and_voucher/screens/vouchers/voucher_detail_screen.dart';
import 'package:event_and_voucher/screens/cart/cart_screen.dart';
import 'package:event_and_voucher/screens/checkout/checkout_screen.dart';
import 'package:event_and_voucher/screens/auth/login_screen.dart';
import 'package:event_and_voucher/screens/auth/otp_verification_screen.dart';
import 'package:event_and_voucher/screens/auth/registration_screen.dart';
import 'package:event_and_voucher/screens/splash/splash_screen.dart';
import 'package:event_and_voucher/screens/onboarding/onboarding_screen.dart';
import 'package:event_and_voucher/screens/profile/organizer_profile_screen.dart';
import 'package:event_and_voucher/screens/notifications/notifications_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final currentLocation = state.matchedLocation;
      final isGoingToOtp = currentLocation == '/otp-verify';
      final isGoingToLogin = currentLocation == '/login';
      final isGoingToRegistration = currentLocation == '/registration';
      final isGoingToSplash = currentLocation == '/splash';
      final isGoingToOnboarding = currentLocation == '/onboarding';
      
      // Allow splash screen, onboarding, login, and registration navigation
      if (isGoingToSplash || isGoingToOnboarding || isGoingToLogin || isGoingToRegistration) {
        return null; // Allow navigation
      }
      
      // If authenticated and trying to access OTP page, redirect to home
      if (isAuthenticated && isGoingToOtp) {
        return '/';
      }
      
      // Allow navigation to OTP verify page without authentication
      if (isGoingToOtp) {
        return null; // Allow navigation
      }
      
      // Redirect to splash if not authenticated and trying to access protected routes
      if (!isAuthenticated) {
        return '/splash';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp-verify',
        name: 'otp-verify',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return OTPVerificationScreen(phoneNumber: phoneNumber);
        },
      ),
      GoRoute(
        path: '/registration',
        name: 'registration',
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return RegistrationScreen(phoneNumber: phoneNumber);
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return HomeScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'events',
            builder: (context, state) => const EventsScreen(),
          ),
          GoRoute(
            path: '/vouchers',
            name: 'vouchers',
            builder: (context, state) => const VouchersScreen(),
          ),
          GoRoute(
            path: '/cart',
            name: 'cart',
            builder: (context, state) => const CartScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/events/all',
        name: 'events-view-all',
        builder: (context, state) => const EventsViewAllScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/event/:id',
        name: 'event-detail',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          final event = EventService.getEventById(eventId);
          if (event == null) {
            return const Scaffold(
              body: Center(child: Text('Event not found')),
            );
          }
          return EventDetailScreen(event: event);
        },
      ),
      GoRoute(
        path: '/events/create',
        name: 'create-event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      GoRoute(
        path: '/event/:id/edit',
        name: 'edit-event',
        builder: (context, state) {
          final eventId = state.pathParameters['id']!;
          final event = EventService.getEventById(eventId);
          if (event == null) {
            return const Scaffold(
              body: Center(child: Text('Event not found')),
            );
          }
          return EditEventScreen(event: event);
        },
      ),
      GoRoute(
        path: '/voucher/:id',
        name: 'voucher-detail',
        builder: (context, state) {
          final voucherId = state.pathParameters['id']!;
          final voucher = VoucherService.getVoucherById(voucherId);
          if (voucher == null) {
            return const Scaffold(
              body: Center(child: Text('Voucher not found')),
            );
          }
          return VoucherDetailScreen(voucher: voucher);
        },
      ),
      GoRoute(
        path: '/checkout',
        name: 'checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const OrganizerProfileScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
    ],
  );
  
  return router;
});
