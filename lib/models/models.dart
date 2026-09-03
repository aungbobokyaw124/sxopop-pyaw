class ChatUser {
  final String name;
  final String username;
  final String avatarInitials;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final bool isTyping;

  const ChatUser({
    required this.name,
    required this.username,
    required this.avatarInitials,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.isTyping = false,
  });
}

class Story {
  final String userName;
  final String userHandle;
  final String timeAgo;
  final String location;
  final String caption;
  final int likes;
  final int comments;
  final bool isOwn;

  const Story({
    required this.userName,
    required this.userHandle,
    required this.timeAgo,
    required this.location,
    required this.caption,
    this.likes = 0,
    this.comments = 0,
    this.isOwn = false,
  });
}

class Friend {
  final String name;
  final String username;
  final String initials;
  bool isSelected;

  Friend({
    required this.name,
    required this.username,
    required this.initials,
    this.isSelected = false,
  });
}

// Sample data
final List<ChatUser> sampleChats = [
  ChatUser(
    name: 'Thura Zaw',
    username: '@thurazaw',
    avatarInitials: 'TZ',
    lastMessage: 'Typing...',
    time: '9:41 AM',
    unreadCount: 2,
    isOnline: true,
    isTyping: true,
  ),
  ChatUser(
    name: 'Su Myat',
    username: '@sumyat',
    avatarInitials: 'SM',
    lastMessage: 'See you tomorrow!',
    time: '9:30 AM',
    unreadCount: 1,
    isOnline: true,
  ),
  ChatUser(
    name: 'Family Group',
    username: 'Ko Aung: Photo',
    avatarInitials: 'FG',
    lastMessage: 'Ko Aung: Photo',
    time: '8:45 AM',
    isOnline: false,
  ),
  ChatUser(
    name: 'Best Friends',
    username: '@bestfriends',
    avatarInitials: 'BF',
    lastMessage: 'May: 😂😂😂',
    time: '8:20 AM',
    isOnline: false,
  ),
  ChatUser(
    name: 'Nanda Kyaw',
    username: '@nandakyaw',
    avatarInitials: 'NK',
    lastMessage: 'Thanks!',
    time: 'Yesterday',
    isOnline: false,
  ),
  ChatUser(
    name: 'Thet Htar',
    username: '@thethtar',
    avatarInitials: 'TH',
    lastMessage: 'Voice message',
    time: 'Yesterday',
    isOnline: false,
  ),
];

final List<Story> sampleStories = [
  Story(
    userName: 'Aung Bo Bo Kyaw',
    userHandle: '@aungbobkyaw',
    timeAgo: '2h ago',
    location: 'Yangon',
    caption: 'Beautiful sunset today! 🌅',
    likes: 128,
    comments: 24,
    isOwn: true,
  ),
  Story(
    userName: 'El Thinzar',
    userHandle: '@elthinzar',
    timeAgo: '4h ago',
    location: 'Mandalay',
    caption: 'Coffee time ☕',
    likes: 64,
    comments: 8,
  ),
];

final List<String> storyUsers = [
  'Nay Lin', 'El Thinzar', 'Ko Aung', 'May Th',
];

List<Friend> getSampleFriends() => [
  Friend(name: 'Thura Zaw', username: '@thurazaw', initials: 'TZ'),
  Friend(name: 'Su Myat', username: '@sumyat', initials: 'SM'),
  Friend(name: 'Nanda Kyaw', username: '@nandakyaw', initials: 'NK'),
  Friend(name: 'May Thandar', username: '@maythandar', initials: 'MT'),
  Friend(name: 'Ko Aung', username: '@koaung', initials: 'KA'),
  Friend(name: 'Thet Htar', username: '@thethtar', initials: 'TH'),
];
