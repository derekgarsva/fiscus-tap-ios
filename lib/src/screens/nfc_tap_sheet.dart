import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/nfc_service.dart';
import '../theme/app_theme.dart';
import 'receipt_screen.dart';

class NfcTapSheet extends StatefulWidget {
  final double amount;

  const NfcTapSheet({super.key, required this.amount});

  @override
  State<NfcTapSheet> createState() => _NfcTapSheetState();
}

class _NfcTapSheetState extends State<NfcTapSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  String _statusText = 'Listo para lectura contactless...';
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _startNfcReading();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _startNfcReading() async {
    final tx = await NfcService.readContactlessPayment(
      amount: widget.amount,
      onStatusUpdate: (status) {
        if (mounted) {
          setState(() {
            _statusText = status;
          });
        }
      },
    );

    if (tx != null && mounted) {
      setState(() {
        _isSuccess = true;
        _statusText = '✓ ¡Cobro de ${widget.amount.toStringAsFixed(2)} € Aprobado!';
      });

      await Future.delayed(const Duration(milliseconds: 900));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ReceiptScreen(transaction: tx),
          ),
        );
      }
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top drag indicator
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 28),

            // Amount Header
            Text(
              'TOTAL A COBRAR',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${widget.amount.toStringAsFixed(2)} €',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 32),

            // Animated NFC Wave Visual
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _animController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(160, 160),
                        painter: NfcWavePainter(
                          progress: _animController.value,
                          color: _isSuccess ? AppColors.success : AppColors.accent,
                        ),
                      );
                    },
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: _isSuccess
                          ? AppColors.success.withOpacity(0.15)
                          : AppColors.accentGlow,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isSuccess ? AppColors.success : AppColors.accent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _isSuccess ? Icons.check_circle_rounded : Icons.contactless_rounded,
                      size: 38,
                      color: _isSuccess ? AppColors.success : AppColors.accentLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isSuccess
                    ? AppColors.success.withOpacity(0.15)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: _isSuccess ? AppColors.success : AppColors.border,
                ),
              ),
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _isSuccess ? AppColors.success : AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cancel Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NfcWavePainter extends CustomPainter {
  final double progress;
  final Color color;

  NfcWavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 3; i++) {
      final currentProgress = (progress + (i * 0.33)) % 1.0;
      final radius = 36 + (currentProgress * 44);
      final opacity = (1.0 - currentProgress).clamp(0.0, 0.7);

      final paint = Paint()
        ..color = color.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant NfcWavePainter oldDelegate) => true;
}
