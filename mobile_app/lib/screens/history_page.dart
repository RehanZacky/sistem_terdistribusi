import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_session.dart';
import '../providers/session_provider.dart';
import '../utils/api_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final session = Provider.of<SessionProvider>(context, listen: false);
      final result = await ApiService.getTransactionHistory(session.currentUser!.userId);

      if (result['count'] != null) {
        final transactionList = (result['history'] as List)
            .map((json) => Transaction.fromJson(json))
            .toList();

        setState(() {
          _transactions = transactionList;
          _totalCount = result['count'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Gagal mengambil histori transaksi';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('📜 Histori Transaksi'),
        backgroundColor: const Color(0xFF2A2A3C),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : _transactions.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 64,
                            color: Colors.white38,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'ℹ️ Belum ada transaksi',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: const Color(0xFF2A2A3C),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.analytics,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Total transaksi: $_totalCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: _loadHistory,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = _transactions[index];
                                final isSuccess = transaction.status == 'SUCCESS';

                                return Card(
                                  color: const Color(0xFF2A2A3C),
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: isSuccess
                                                    ? Colors.green.withValues(alpha: 0.2)
                                                    : Colors.red.withValues(alpha: 0.2),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                isSuccess ? Icons.check_circle : Icons.cancel,
                                                color: isSuccess ? Colors.green : Colors.red,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Transaksi #${transaction.transactionId}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    transaction.type,
                                                    style: const TextStyle(
                                                      color: Colors.white60,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              'Rp ${transaction.amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                              style: TextStyle(
                                                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.white12,
                                          height: 24,
                                        ),
                                        _buildInfoRow('Dari', transaction.from),
                                        const SizedBox(height: 8),
                                        _buildInfoRow('Ke', transaction.to),
                                        const SizedBox(height: 8),
                                        _buildInfoRow('Status', transaction.status),
                                        const SizedBox(height: 8),
                                        _buildInfoRow('Waktu', transaction.date),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }
}
