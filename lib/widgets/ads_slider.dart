import 'package:flutter/material.dart';
import '../app_theme.dart';

class AdsSlider extends StatefulWidget {
  final List<String> ads;
  final double height;
  final Duration autoScrollInterval;

  const AdsSlider({
    super.key,
    required this.ads,
    this.height = 60,
    this.autoScrollInterval = const Duration(seconds: 3),
  });

  @override
  State<AdsSlider> createState() => _AdsSliderState();
}

class _AdsSliderState extends State<AdsSlider> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(widget.autoScrollInterval, () {
      if (mounted && widget.ads.length > 1) {
        final nextPage = (_currentPage + 1) % widget.ads.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ads.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      height: widget.height,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _startAutoScroll();
              });
            },
            itemCount: widget.ads.length,
            itemBuilder: (context, index) {
              return _buildAdCard(widget.ads[index], index);
            },
          ),
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.ads.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: _currentPage == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppTheme.primary
                        : AppTheme.textMuted.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(String adText, int index) {
    final gradients = [
      [const Color(0xFFFF6B35), const Color(0xFFFF4081)],
      [const Color(0xFF7C3AED), const Color(0xFF2563EB)],
      [const Color(0xFF059669), const Color(0xFF22C55E)],
      [const Color(0xFFDC2626), const Color(0xFFD97706)],
    ];

    final gradient = gradients[index % gradients.length];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradient,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              adText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
