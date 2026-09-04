import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/models.dart';
import '../widgets/avatar_widget.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({super.key});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  int _tabIndex = 0; // 0: Following, 1: All

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: const Text('Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(child: _buildStoriesFeed()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('Following', 0),
          const SizedBox(width: 12),
          _buildTab('All', 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesFeed() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: sampleStories.length,
      itemBuilder: (context, i) => _buildStoryCard(sampleStories[i]),
    );
  }

  Widget _buildStoryCard(Story story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                AvatarWidget(
                  initials: story.userName.split(' ').map((w) => w[0]).take(2).join(),
                  size: 40,
                  showOnline: story.isOwn,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.userName,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${story.timeAgo} · ${story.location}',
                        style: const TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: AppTheme.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Caption
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              story.caption,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),

          // Image placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: story.isOwn
                    ? [const Color(0xFFFF6B35), const Color(0xFFFF4081), const Color(0xFF7C3AED)]
                    : [const Color(0xFF4A2900), const Color(0xFF8B4513)],
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    story.isOwn ? Icons.wb_sunny_rounded : Icons.local_cafe_rounded,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 64,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      story.location,
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _buildActionBtn(Icons.favorite_border, '${story.likes}'),
                const SizedBox(width: 16),
                _buildActionBtn(Icons.chat_bubble_outline, '${story.comments} Comments'),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: AppTheme.textSecondary),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textSecondary, size: 20),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        ],
      ),
    );
  }
}
