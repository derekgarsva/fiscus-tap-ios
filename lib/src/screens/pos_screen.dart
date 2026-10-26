import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'nfc_tap_sheet.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String _amountCentsString = '0';

  double get _amount => (int.tryParse(_amountCentsString) ?? 0) / 100.0;

  void _onDigitPress(String digit) {
    HapticFeedback.lightImpact();
    if (_amountCentsString == '0') {
      _amountCentsString = digit;
    } else if (_amountCentsString.length < 8) {
      _amountCentsString += digit;
    }
    setState(() {});
  }

  void _onBackspace() {
    HapticFeedback.lightImpact();
    if (_amountCentsString.length > 1) {
      _amountCentsString = _amountCentsString.substring(0, _amountCentsString.length - 1);
    } else {
      _amountCentsString = '0';
    }
    setState(() {});
  }

  void _onClear() {
    HapticFeedback.mediumImpact();
    setState(() {
      _amountCentsString = '0';
    });
  }

  void _addPreset(int euros) {
    HapticFeedback.lightImpact();
    final currentCents = int.tryParse(_amountCentsString) ?? 0;
    final newCents = currentCents + (euros * 100);
    setState(() {
      _amountCentsString = newCents.toString();
    });
  }

  void _startCharge() {
    if (_amount <= 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Introduce un importe superior a 0,00 €'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NfcTapSheet(amount: _amount),
    ).then((_) {
      // Reset input on return
      setState(() {
        _amountCentsString = '0';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 14),
            ),
            const SizedBox(width: 8),
            const Text('fiscus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
            const Text('tap', style: TextStyle(color: AppColors.accentLight, fontWeight: FontWeight.w800, fontSize: 17)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'NFC Activo',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Amount Display Box
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'IMPORTE DEL COBRO',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${_amount.toStringAsFixed(2)} €',
                        style: TextStyle(
                          color: _amount > 0 ? AppColors.textPrimary : AppColors.textMuted,
                          fontSize: 64,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Quick Preset Buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildPresetBtn(5),
                          _buildPresetBtn(10),
                          _buildPresetBtn(20),
                          _buildPresetBtn(50),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Numpad Keypad (Apple Touch Style)
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNumpadRow(['1', '2', '3']),
                    _buildNumpadRow(['4', '5', '6']),
                    _buildNumpadRow(['7', '8', '9']),
                    _buildNumpadActionRow(),
                  ],
                ),
              ),
            ),

            // Primary Charge CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _amount > 0 ? _startCharge : null,
                  icon: const Icon(Icons.contactless_rounded, size: 24),
                  label: Text(
                    _amount > 0
                        ? 'Cobrar ${_amount.toStringAsFixed(2)} € con NFC'
                        : 'Introduce un importe',
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    disabledBackgroundColor: AppColors.surfaceElevated,
                    disabledForegroundColor: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetBtn(int euros) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ActionChip(
        label: Text('+$euros €'),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        onPressed: () => _addPreset(euros),
      ),
    );
  }

  Widget _buildNumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) => _buildNumpadKey(d)).toList(),
    );
  }

  Widget _buildNumpadActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Clear
        _buildNumpadKey('C', isAction: true, onTap: _onClear),
        // Zero
        _buildNumpadKey('0'),
        // Backspace
        _buildNumpadKey('⌫', isAction: true, onTap: _onBackspace),
      ],
    );
  }

  Widget _buildNumpadKey(String text, {bool isAction = false, VoidCallback? onTap}) {
    return SizedBox(
      width: 76,
      height: 76,
      child: Material(
        color: isAction ? AppColors.surface : AppColors.surfaceElevated,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap ?? () => _onDigitPress(text),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isAction ? AppColors.textSecondary : AppColors.textPrimary,
                fontSize: 26,
                fontWeight: isAction ? FontWeight.w600 : FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
