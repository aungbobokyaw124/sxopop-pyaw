import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../app_theme.dart';
import '../services/firestore_service.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/ads_slider.dart';
import '../widgets/comments_sheet.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _postController = TextEditingController();

  final List<String> _ads = [
    'SXOPOP Premium - Try 30 days free!',
    'New feature: Voice messages now available',
    'Invite friends and earn rewards',
    'SXOPOP Web - Now available on desktop',
  ];

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _handleCreatePost() async {
    if (_postController.text.trim().isEmpty) return;

    try {
      await _firestoreService.createPost(
        content: _postController.text.trim(),
      );
      _postController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleLike(String postId) async {
    try {
      await _firestoreService.likePost(postId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to like post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showComments(String postId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentsSheet(postId: postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/app-icon.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.primary, AppTheme.accent],
                        ),
                      ),
                      child: const Center(
                        child: Text('S', style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SXOPOP',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          AdsSlider(ads: _ads),
          _buildCreatePost(),
          const Divider(color: AppTheme.divider),
          _buildPostsFeed(),
        ],
      ),
    );
  }

  Widget _buildCreatePost() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const AvatarWidget(initials: 'US', size: 40),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      style: const TextStyle(color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        hintStyle: const TextStyle(color: AppTheme.textMuted),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppTheme.divider, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionChip(Icons.photo_library_outlined, 'Photo'),
                  _buildActionChip(Icons.emoji_emotions_outlined, 'Feeling'),
                  _buildActionChip(Icons.send_outlined, 'Post', onTap: _handleCreatePost),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPostsFeed() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestoreService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primary),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              children: [
                Icon(Icons.post_add, color: AppTheme.textMuted, size: 64),
                SizedBox(height: 16),
                Text('No posts yet', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                SizedBox(height: 8),
                Text('Be the first to post!', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ],
            ),
          );
        }

        final posts = snapshot.data!.docs;

        return Column(
          children: posts.map((post) => _buildPostCard(post)).toList(),
        );
      },
    );
  }

  Widget _buildPostCard(DocumentSnapshot post) {
    final content = post['content'] as String? ?? '';
    final likes = post['likes'] as int? ?? 0;
    final comments = post['comments'] as int? ?? 0;

    return FutureBuilder<DocumentSnapshot>(
      future: _firestoreService.getUserProfile(post['userId']),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
        final userName = userData['name'] as String? ?? 'Unknown';
        final initials = userData['avatarInitials'] as String? ?? '??';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    AvatarWidget(
                      initials: initials,
                      size: 40,
                      showOnline: true,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(userName, style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(content, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _toggleLike(post.id),
                      child: Row(
                        children: [
                          const Icon(Icons.favorite_border, color: AppTheme.textSecondary, size: 20),
                          const SizedBox(width: 4),
                          Text('$likes', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => _showComments(post.id),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, color: AppTheme.textSecondary, size: 20),
                          const SizedBox(width: 4),
                          Text('$comments Comments', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
