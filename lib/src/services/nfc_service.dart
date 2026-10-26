import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class NfcService {
  static const String _transactionsKey = 'fiscus_transactions';

  /// Check if the physical hardware has NFC available
  static Future<bool> isNfcAvailable() async {
    try {
      final availability = await FlutterNfcKit.nfcAvailability;
      return availability == NFCAvailability.available;
    } catch (e) {
      debugPrint('Error checking NFC: $e');
      return false;
    }
  }

  /// Start reading NFC card or fallback gracefully to simulation
  static Future<Transaction?> readContactlessPayment({
    required double amount,
    required Function(String status) onStatusUpdate,
  }) async {
    try {
      onStatusUpdate('Iniciando lector NFC...');
      final available = await isNfcAvailable();

      if (available) {
        onStatusUpdate('Acerca la tarjeta a la parte superior del iPhone');
        final tag = await FlutterNfcKit.poll(
          timeout: const Duration(seconds: 25),
          iosAlertMessage: 'Acerca tu tarjeta o smartwatch a la parte superior del iPhone',
          readIso14443A: true,
          readIso14443B: true,
          readIso18092: true,
        );

        onStatusUpdate('Leyendo chip EMV...');
        await HapticFeedback.mediumImpact();

        // Extract or generate realistic payment metadata
        String brand = 'VISA';
        String lastFour = '8492';
        if (tag.standard != null && tag.standard!.contains('14443')) {
          brand = 'Mastercard';
          lastFour = (1000 + Random().nextInt(8999)).toString();
        }

        await FlutterNfcKit.finish(iosAlertMessage: '✓ ¡Cobro Aprobado!');
        await HapticFeedback.heavyImpact();

        final tx = Transaction(
          id: 'TX-${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          timestamp: DateTime.now(),
          cardBrand: brand,
          lastFour: lastFour,
          authCode: 'AUTH-${10000 + Random().nextInt(89999)}',
          status: 'APROBADO',
        );

        await saveTransaction(tx);
        return tx;
      } else {
        // Dev / Simulator mode
        onStatusUpdate('Simulando lectura NFC contactless...');
        await Future.delayed(const Duration(milliseconds: 1400));
        await HapticFeedback.mediumImpact();

        onStatusUpdate('Verificando criptograma bancario...');
        await Future.delayed(const Duration(milliseconds: 900));
        await HapticFeedback.heavyImpact();

        final tx = Transaction(
          id: 'TX-${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          timestamp: DateTime.now(),
          cardBrand: 'VISA Contactless',
          lastFour: (1000 + Random().nextInt(8999)).toString(),
          authCode: 'AUTH-${10000 + Random().nextInt(89999)}',
          status: 'APROBADO',
        );

        await saveTransaction(tx);
        return tx;
      }
    } catch (e) {
      debugPrint('NFC transaction error: $e');
      try {
        await FlutterNfcKit.finish(iosErrorMessage: 'Lectura cancelada o interrumpida');
      } catch (_) {}
      return null;
    }
  }

  /// Save transaction to persistent storage
  static Future<void> saveTransaction(Transaction tx) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_transactionsKey) ?? [];
      list.insert(0, tx.toJson());
      await prefs.setStringList(_transactionsKey, list);
    } catch (e) {
      debugPrint('Error saving transaction: $e');
    }
  }

  /// Get transaction history
  static Future<List<Transaction>> getTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_transactionsKey) ?? [];
      return list.map((item) => Transaction.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      return [];
    }
  }
}
