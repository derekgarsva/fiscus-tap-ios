import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';

class ReceiptScreen extends StatelessWidget {
  final Transaction transaction;

  const ReceiptScreen({super.key, required this.transaction});

  void _shareViaWhatsApp(BuildContext context) async {
    final dateStr = DateFormat('dd/MM/yyyy HH:mm').format(transaction.timestamp);
    final msg = Uri.encodeComponent(
      '🧾 *TICKET DIGITAL FISCUS TAP*\n\n'
      'Importe: ${transaction.amount.toStringAsFixed(2)} €\n'
      'Tarjeta: ${transaction.cardBrand} (•••• ${transaction.lastFour})\n'
      'Autorización: ${transaction.authCode}\n'
      'Fecha: $dateStr\n'
      'Terminal: Fiscus Tap iPhone 11\n\n'
      '¡Gracias por su compra!',
    );

    final url = Uri.parse('whatsapp://send?text=$msg');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        final webUrl = Uri.parse('https://wa.me/?text=$msg');
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp no está instalado o no disponible.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final formattedDate = dateFormat.format(transaction.timestamp);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Comprobante de Pago'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // Success Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.success,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),

              Text(
                '¡Cobro Aprobado!',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Transacción procesada correctamente',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // Digital Ticket Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Brand Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'fiscus',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'tap',
                          style: const TextStyle(
                            color: AppColors.accentLight,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Amount
                    Text(
                      '${transaction.amount.toStringAsFixed(2)} €',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 16),

                    // Metadata rows
                    _buildTicketRow('Método', '${transaction.cardBrand} •••• ${transaction.lastFour}'),
                    _buildTicketRow('Autorización', transaction.authCode),
                    _buildTicketRow('Fecha y Hora', formattedDate),
                    _buildTicketRow('Terminal ID', 'FT-IPHONE11-01'),
                    _buildTicketRow('Estado', 'APROBADO EMV'),

                    const SizedBox(height: 20),

                    // QR Code
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: QrImageView(
                        data: 'https://fiscus-tap-web.vercel.app/receipt?id=${transaction.id}&amt=${transaction.amount}',
                        version: QrVersions.auto,
                        size: 140,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Escanea para ver ticket digital',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _shareViaWhatsApp(context),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Enviar ticket por WhatsApp'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: const Text(
                    'Realizar Nuevo Cobro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
