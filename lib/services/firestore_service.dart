import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getChatId(String user1, String user2) {
    final users = [user1, user2]..sort();
    return '${users[0]}_${users[1]}';
  }

  Future<void> createUserProfile({
    required String name,
    required String username,
    String? bio,
    String? location,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await _firestore.collection('users').doc(user.uid).set({
      'name': name,
      'username': username,
      'bio': bio ?? '',
      'location': location ?? '',
      'email': user.email,
      'avatarInitials':
          name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join(),
      'createdAt': FieldValue.serverTimestamp(),
      'isOnline': true,
    });
  }

  Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  Future<void> updateOnlineStatus(bool isOnline) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.uid).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final chatId = _getChatId(user.uid, receiverId);
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': user.uid,
      'receiverId': receiverId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
    await _firestore.collection('chats').doc(chatId).set({
      'participants': [user.uid, receiverId],
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
      'lastSenderId': user.uid,
    });
  }

  Stream<QuerySnapshot> getMessages(String receiverId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    final chatId = _getChatId(user.uid, receiverId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserChats() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return _firestore
        .collection('chats')
        .where('participants', arrayContains: user.uid)
        .snapshots();
  }

  Future<void> createPost({
    required String content,
    String? location,
    List<String>? taggedUsers,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await _firestore.collection('posts').add({
      'userId': user.uid,
      'content': content,
      'location': location ?? '',
      'taggedUsers': taggedUsers ?? [],
      'likes': 0,
      'comments': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore.collection('posts').snapshots();
  }

  Future<void> likePost(String postId) async {
    await _firestore.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  Future<void> addComment({
    required String postId,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'userId': user.uid,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }

  Stream<QuerySnapshot> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }
}
