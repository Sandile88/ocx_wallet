import 'package:flutter/material.dart';

class NFCPulseAnimation extends StatefulWidget {
  const NFCPulseAnimation({Key? key}) : super(key: key);

  @override
  _NFCPulseAnimationState createState() => _NFCPulseAnimationState();
}

class _NFCPulseAnimationState extends State<NFCPulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller setup
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Scale animation
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Opacity animation
    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Pulse wave animation
    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pulse Wave Animation
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse Waves
                  _buildPulseWave(1.5),
                  _buildPulseWave(2.0),
                  _buildPulseWave(2.5),

                  // Animated NFC Icon
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(
                      opacity: _opacityAnimation.value,
                      child: const Icon(
                        Icons.nfc,
                        size: 200,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          // Tap Instruction Text
          const Text(
            'Tap to Transfer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Build pulse wave effect
  Widget _buildPulseWave(double multiplier) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: 1 - _pulseAnimation.value,
          child: Container(
            width: 200 * _pulseAnimation.value * multiplier,
            height: 200 * _pulseAnimation.value * multiplier,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.2),
            ),
          ),
        );
      },
    );
  }
}
