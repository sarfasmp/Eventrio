import 'package:event_and_voucher/core/network/network_service.dart';
import 'package:event_and_voucher/core/network/api_endpoints.dart';
import 'package:event_and_voucher/core/network/api_response.dart';
import 'package:event_and_voucher/models/event.dart';

/// Service for handling event-related API calls
class EventService extends NetworkService {
  EventService(super.apiClient);

  // Static mock data for backward compatibility
  static final List<Event> _mockEvents = [
    Event(
      id: '1',
      title: 'Summer Music Festival',
      description: 'Join us for an amazing summer music festival featuring top artists from around the world. Experience live performances, great food, and unforgettable memories.',
      imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
      date: DateTime.now().add(const Duration(days: 30)),
      venue: 'Central Park',
      location: 'New York, NY',
      price: 75.00,
      availableTickets: 500,
      category: 'Music',
    ),
    Event(
      id: '2',
      title: 'Tech Conference 2024',
      description: 'The biggest tech conference of the year. Learn from industry leaders, network with professionals, and discover the latest innovations.',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
      date: DateTime.now().add(const Duration(days: 45)),
      venue: 'Convention Center',
      location: 'San Francisco, CA',
      price: 299.00,
      availableTickets: 200,
      category: 'Technology',
    ),
    Event(
      id: '3',
      title: 'Food & Wine Expo',
      description: 'Taste exquisite cuisines and wines from renowned chefs and wineries. A culinary adventure you won\'t want to miss.',
      imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800',
      date: DateTime.now().add(const Duration(days: 60)),
      venue: 'Grand Hotel',
      location: 'Los Angeles, CA',
      price: 120.00,
      availableTickets: 300,
      category: 'Food & Drink',
    ),
    Event(
      id: '4',
      title: 'Comedy Night',
      description: 'An evening of laughter with top comedians. Get ready for a night full of jokes and entertainment.',
      imageUrl: 'https://images.unsplash.com/photo-1504609773096-104ff2c73ba4?w=800',
      date: DateTime.now().add(const Duration(days: 15)),
      venue: 'Comedy Club',
      location: 'Chicago, IL',
      price: 45.00,
      availableTickets: 150,
      category: 'Entertainment',
    ),
    Event(
      id: '5',
      title: 'Art Exhibition',
      description: 'Explore contemporary art from emerging and established artists. A visual feast for art enthusiasts.',
      imageUrl: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800',
      date: DateTime.now().add(const Duration(days: 20)),
      venue: 'Modern Art Museum',
      location: 'Miami, FL',
      price: 35.00,
      availableTickets: 250,
      category: 'Art',
    ),
    Event(
      id: '6',
      title: 'Marathon Run',
      description: 'Join thousands of runners in this annual marathon. Challenge yourself and support a great cause.',
      imageUrl: 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=800',
      date: DateTime.now().add(const Duration(days: 90)),
      venue: 'City Park',
      location: 'Boston, MA',
      price: 55.00,
      availableTickets: 1000,
      category: 'Sports',
    ),
  ];

  // Static methods for backward compatibility (returns mock data)
  static List<Event> getAllEvents() => _mockEvents;

  static Event? getEventById(String id) {
    try {
      return _mockEvents.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Event> getEventsByCategory(String category) {
    return _mockEvents.where((event) => event.category == category).toList();
  }

  /// Get all events (API)
  Future<ApiResponse<List<Event>>> getAllEventsApi() async {
    return get<List<Event>>(
      ApiEndpoints.events,
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Event.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [Event.fromJson(json as Map<String, dynamic>)];
      },
    );
  }

  /// Get event by ID (API)
  Future<ApiResponse<Event>> getEventByIdApi(String id) async {
    return get<Event>(
      ApiEndpoints.eventById(id),
      fromJson: (json) => Event.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get events by category (API)
  Future<ApiResponse<List<Event>>> getEventsByCategoryApi(String category) async {
    return get<List<Event>>(
      ApiEndpoints.eventsByCategory(category),
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Event.fromJson(item as Map<String, dynamic>)).toList();
        }
        return [Event.fromJson(json as Map<String, dynamic>)];
      },
    );
  }

  /// Create a new event (admin only)
  Future<ApiResponse<Event>> createEvent(Event event) async {
    return post<Event>(
      ApiEndpoints.events,
      data: event.toJson(),
      fromJson: (json) => Event.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update an existing event (admin only)
  Future<ApiResponse<Event>> updateEvent(String id, Event event) async {
    return put<Event>(
      ApiEndpoints.eventById(id),
      data: event.toJson(),
      fromJson: (json) => Event.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Delete an event (admin only)
  Future<ApiResponse<void>> deleteEvent(String id) async {
    return delete<void>(ApiEndpoints.eventById(id));
  }
}
