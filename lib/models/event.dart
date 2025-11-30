class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;
  final String venue;
  final String location;
  final double price;
  final int availableTickets;
  final String category;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
    required this.venue,
    required this.location,
    required this.price,
    required this.availableTickets,
    required this.category,
  });

  bool get isAvailable => availableTickets > 0;

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : json['date'] is DateTime
              ? json['date']
              : DateTime.now(),
      venue: json['venue'] ?? '',
      location: json['location'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      availableTickets: json['availableTickets'] ?? json['available_tickets'] ?? 0,
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'date': date.toIso8601String(),
      'venue': venue,
      'location': location,
      'price': price,
      'availableTickets': availableTickets,
      'category': category,
    };
  }
}
