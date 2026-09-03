import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/models.dart';
import '../widgets/avatar_widget.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({super.key});

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  int _step = 0; // 0=start, 1=details, 2=feeling, 3=tag, 4=review
  final TextEditingController _captionController = TextEditingController();
  String _selectedFeeling = '';
  String _selectedActivity = '';
  String _shareWith = 'Public';
  bool _shareToStory = false;
  bool _shareToFeed = true;
  bool _hasImage = false;
  String _location = 'Yangon, Myanmar';
  List<Friend> _friends = getSampleFriends();

  final List<String> _feelings = ['Happy', 'Love', 'Excited', 'Chill', 'Sad'];
  final List<String> _feelingEmojis = ['😊', '❤️', '😄', '😌', '😢'];
  final List<String> _activities = ['Traveling', 'Eating', 'Working', 'Study', 'Sport'];
  final List<String> _activityEmojis = ['✈️', '🍕', '💼', '📚', '⚽'];
  final List<String> _shareOptions = ['Public', 'Friends', 'Only Me'];

  int get _selectedFriendCount => _friends.where((f) => f.isSelected).length;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: _buildCurrentStep(),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0: return _buildStartStep();
      case 1: return _buildDetailsStep();
      case 2: return _buildFeelingStep();
      case 3: return _buildTagStep();
      case 4: return _buildReviewStep();
      default: return _buildStartStep();
    }
  }

  // ─────────────────────────────────────────
  // STEP 0: Start
  // ─────────────────────────────────────────
  Widget _buildStartStep() {
    return Column(
      children: [
        _buildTopBar('Post', canPost: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAuthorRow(),
              const SizedBox(height: 12),
              _buildTextField(),
              const SizedBox(height: 16),
              _buildMetaFields(),
              const SizedBox(height: 16),
              _buildMediaBar(),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // STEP 1: Details
  // ─────────────────────────────────────────
  Widget _buildDetailsStep() {
    return Column(
      children: [
        _buildTopBar('Post', canPost: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAuthorRow(),
              const SizedBox(height: 12),
              _buildTextField(),
              const SizedBox(height: 12),
              _buildDetailItem(Icons.location_on_outlined, 'Where you live?', subtitle: _location),
              _buildDetailItem(Icons.people_outline, 'With who?', subtitle: _selectedFriendCount > 0 ? '$_selectedFriendCount people' : null, onTap: () => setState(() => _step = 3)),
              _buildImagePlaceholder(),
              const SizedBox(height: 8),
              _buildMediaBar(),
              const SizedBox(height: 16),
              _buildDetailItem(Icons.location_on, 'Add Location', subtitle: _location),
              _buildDetailItem(Icons.people, 'Tag People', subtitle: _selectedFriendCount > 0 ? '$_selectedFriendCount people >' : null, onTap: () => setState(() => _step = 3)),
              _buildShareToRow(),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // STEP 2: Feeling / Activity
  // ─────────────────────────────────────────
  Widget _buildFeelingStep() {
    return Column(
      children: [
        _buildBackBar('What are you feeling?'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSearchField('Search feelings...'),
              const SizedBox(height: 16),
              _buildSectionLabel('Popular'),
              const SizedBox(height: 12),
              _buildEmojiGrid(_feelings, _feelingEmojis, isFeeling: true),
              const SizedBox(height: 16),
              _buildSectionLabel('Activity'),
              const SizedBox(height: 12),
              _buildEmojiGrid(_activities, _activityEmojis, isFeeling: false),
              const SizedBox(height: 16),
              _buildSectionLabel('Custom'),
              const SizedBox(height: 8),
              _buildSearchField('Add your own feeling'),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // STEP 3: Tag People
  // ─────────────────────────────────────────
  Widget _buildTagStep() {
    return Column(
      children: [
        _buildBackBar('Tag People'),
        _buildSearchField('Search friends...', padding: const EdgeInsets.all(16)),
        Expanded(
          child: ListView.builder(
            itemCount: _friends.length,
            itemBuilder: (context, i) => _buildFriendTile(_friends[i], i),
          ),
        ),
        if (_selectedFriendCount > 0)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => setState(() => _step = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text('Done ($_selectedFriendCount)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────
  // STEP 4: Review & Post
  // ─────────────────────────────────────────
  Widget _buildReviewStep() {
    return Column(
      children: [
        _buildTopBar('Post', canPost: true, onPost: _handlePost),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAuthorRow(showMeta: true),
              const SizedBox(height: 12),
              Text(
                _captionController.text.isEmpty ? 'Beautiful sunset with best friends!' : _captionController.text,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, color: AppTheme.textMuted, size: 14),
                  Text(_location, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                  const SizedBox(width: 8),
                  const Icon(Icons.people, color: AppTheme.textMuted, size: 14),
                  Text(
                    _selectedFriendCount > 0 ? 'With Best Friends' : 'Public',
                    style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildImagePlaceholder(tall: true),
              const SizedBox(height: 16),
              _buildToggleRow('Add to your story', _shareToStory, (v) => setState(() => _shareToStory = v)),
              _buildToggleRow('Share to feed', _shareToFeed, (v) => setState(() => _shareToFeed = v)),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePost() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Posted!', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('Your post has been shared.', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(
            onPressed: () { Navigator.pop(context); Navigator.pop(context); },
            child: const Text('OK', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Shared Components
  // ─────────────────────────────────────────

  Widget _buildTopBar(String title, {bool canPost = false, VoidCallback? onPost}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: AppTheme.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(child: Center(
            child: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: canPost ? (onPost ?? () => setState(() => _step = 4)) : () => setState(() => _step = 4),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Post', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackBar(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
            onPressed: () => setState(() => _step = _step > 0 ? _step - 1 : 0),
          ),
          Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAuthorRow({bool showMeta = false}) {
    return Row(
      children: [
        const AvatarWidget(initials: 'AB', size: 44),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Aung Bo Bo Kyaw', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
            if (showMeta)
              Row(children: [
                const Icon(Icons.public, color: AppTheme.textMuted, size: 12),
                const SizedBox(width: 4),
                Text(_shareWith, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted, size: 14),
              ])
            else
              const Text('What\'s on your mind?', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _captionController,
      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'Write something...',
        hintStyle: TextStyle(color: AppTheme.textMuted),
        border: InputBorder.none,
      ),
    );
  }

  Widget _buildMetaFields() {
    return Column(
      children: [
        _buildDetailItem(Icons.location_on_outlined, 'Where you live?', onTap: () {}),
        _buildDetailItem(Icons.people_outline, 'With who?', onTap: () => setState(() => _step = 3)),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(subtitle ?? label, style: TextStyle(color: subtitle != null ? AppTheme.primary : AppTheme.textSecondary, fontSize: 14))),
            if (subtitle == null) const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder({bool tall = false}) {
    return GestureDetector(
      onTap: () => setState(() => _hasImage = true),
      child: Container(
        height: tall ? 200 : 120,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          gradient: _hasImage
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF6B35), Color(0xFFFF4081), Color(0xFF7C3AED)],
                )
              : null,
        ),
        child: _hasImage
            ? Stack(children: [
                Center(child: Icon(Icons.wb_sunny_rounded, color: Colors.white.withOpacity(0.6), size: 64)),
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _hasImage = false),
                    child: Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Icon(Icons.add_photo_alternate_outlined, color: AppTheme.textMuted, size: 32),
                SizedBox(height: 8),
                Text('Add Photo / Video', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
              ]),
      ),
    );
  }

  Widget _buildMediaBar() {
    return Row(
      children: [
        _buildMediaBtn(Icons.photo_library_outlined, 'Photo / Video', onTap: () { setState(() { _hasImage = true; _step = 1; }); }),
        const SizedBox(width: 12),
        _buildMediaBtn(Icons.emoji_emotions_outlined, 'Feeling / Activity', onTap: () => setState(() => _step = 2)),
      ],
    );
  }

  Widget _buildMediaBtn(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildShareToRow() {
    return Row(
      children: [
        const Icon(Icons.public, color: AppTheme.textMuted, size: 18),
        const SizedBox(width: 8),
        const Text('Share to', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _shareWith,
            dropdownColor: AppTheme.surface,
            style: const TextStyle(color: AppTheme.textPrimary),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted),
            items: _shareOptions.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
            onChanged: (v) => setState(() => _shareWith = v!),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(String hint, {EdgeInsets? padding}) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppTheme.textMuted),
            prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted, size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.w600));
  }

  Widget _buildEmojiGrid(List<String> items, List<String> emojis, {required bool isFeeling}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) {
        final isSelected = isFeeling ? _selectedFeeling == items[i] : _selectedActivity == items[i];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isFeeling) {
                _selectedFeeling = _selectedFeeling == items[i] ? '' : items[i];
              } else {
                _selectedActivity = _selectedActivity == items[i] ? '' : items[i];
              }
            });
            Future.delayed(const Duration(milliseconds: 300), () => setState(() => _step = 1));
          },
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppTheme.primary.withOpacity(0.2) : AppTheme.surfaceLight,
                  border: isSelected ? Border.all(color: AppTheme.primary, width: 2) : null,
                ),
                child: Center(child: Text(emojis[i], style: const TextStyle(fontSize: 26))),
              ),
              const SizedBox(height: 6),
              Text(items[i], style: TextStyle(color: isSelected ? AppTheme.primary : AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildFriendTile(Friend friend, int index) {
    return InkWell(
      onTap: () => setState(() => _friends[index].isSelected = !_friends[index].isSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            AvatarWidget(initials: friend.initials, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.name, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
                  Text(friend.username, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: friend.isSelected ? AppTheme.primary : Colors.transparent,
                border: Border.all(color: friend.isSelected ? AppTheme.primary : AppTheme.textMuted, width: 2),
              ),
              child: friend.isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primary,
            activeTrackColor: AppTheme.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
