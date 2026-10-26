import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/nfc_service.dart';
import '../theme/app_theme.dart';
import 'receipt_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final list = await NfcService.getTransactions();
    if (mounted) {
      setState(() {
        _transactions = list;
        _isLoading = false;
      });
    }
  }

  double get _totalVolume =>
      _transactions.fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Actividad y Cobros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() => _isLoading = true);
              _loadHistory();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : RefreshIndicator(
              onRefresh: () async => _loadHistory(),
              color: AppColors.accent,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Total Volume Card
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF141726), Color(0xFF1F253E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VOLUMEN TOTAL PROCESADO',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_totalVolume.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${_transactions.length} cobros',
                                style: const TextStyle(
                                  color: AppColors.success,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Liquidación automática 24h',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Historial Reciente',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_transactions.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(
                            'No hay transacciones registradas',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                          ),
                        ],
                      ),
                    )
                  else
                    ..._transactions.map((tx) {
                      final timeStr = DateFormat('dd MMM, HH:mm').format(tx.timestamp);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.accentGlow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.contactless_rounded,
                              color: AppColors.accentLight,
                            ),
                          ),
                          title: Text(
                            '${tx.amount.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),
                          subtitle: Text(
                            '${tx.cardBrand} •••• ${tx.lastFour} • $timeStr',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ReceiptScreen(transaction: tx),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }
}
