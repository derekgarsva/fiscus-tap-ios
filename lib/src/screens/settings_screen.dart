import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Configuración del Datáfono'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionHeader('TERMINAL'),
          _buildSettingTile(
            icon: Icons.smartphone_rounded,
            title: 'Dispositivo Vinculado',
            subtitle: 'Apple iPhone 11 (A2111 / A2221)',
            trailing: 'Conectado',
          ),
          _buildSettingTile(
            icon: Icons.nfc_rounded,
            title: 'Antena NFC',
            subtitle: 'CoreNFC ISO/IEC 14443 & ISO/IEC 7816',
            trailing: 'Activo',
          ),
          _buildSettingTile(
            icon: Icons.security_rounded,
            title: 'Cifrado de Seguridad',
            subtitle: 'Apple Secure Enclave & EMVCo Level 2',
            trailing: '100% Seguro',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('COMERCIO & LIQUIDACIÓN'),
          _buildSettingTile(
            icon: Icons.storefront_rounded,
            title: 'Nombre Comercial',
            subtitle: 'Mi Comercio Fiscus',
          ),
          _buildSettingTile(
            icon: Icons.account_balance_rounded,
            title: 'Cuenta de Abono (IBAN)',
            subtitle: 'ES91 •••• •••• •••• 4892 (Liquidación 24h)',
          ),
          _buildSettingTile(
            icon: Icons.percent_rounded,
            title: 'Tarifa Actual',
            subtitle: 'Fiscus Starter: 0 €/mes fijo (1,2% + 0,10 €)',
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('INFORMACIÓN DEL SISTEMA'),
          _buildSettingTile(
            icon: Icons.info_outline_rounded,
            title: 'Versión de Fiscus Tap',
            subtitle: 'v1.0.0 (Build 2026.10)',
          ),
          _buildSettingTile(
            icon: Icons.cloud_done_rounded,
            title: 'Servidores de Autorización',
            subtitle: 'Vercel Edge Global & Stripe Processing',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.accentLight, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
        trailing: trailing != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trailing,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
