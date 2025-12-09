enum NotificationType {
  following,
  invite,
  comment,
  like,
}

class AppNotification {
  final String id;
  final String userId;
  final String userName;
  final String userImageUrl;
  final NotificationType type;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? eventId;
  final String? eventTitle;

  AppNotification({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.eventId,
    this.eventTitle,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${difference.inDays ~/ 7} weeks ago';
    }
  }

  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return timestamp.year == yesterday.year &&
        timestamp.month == yesterday.month &&
        timestamp.day == yesterday.day;
  }

  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] ?? '',
      userImageUrl: json['userImageUrl'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => NotificationType.like,
      ),
      message: json['message'] ?? '',
      timestamp: json['timestamp'] is String
          ? DateTime.parse(json['timestamp'])
          : json['timestamp'] is DateTime
              ? json['timestamp']
              : DateTime.now(),
      isRead: json['isRead'] ?? false,
      eventId: json['eventId'],
      eventTitle: json['eventTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'type': type.toString(),
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'eventId': eventId,
      'eventTitle': eventTitle,
    };
  }
}


