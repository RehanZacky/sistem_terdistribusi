import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_session.dart';
import '../providers/session_provider.dart';
import '../utils/api_service.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key? key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final _toAccountController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController(text: 'Transfer lokal');

  List<Account> _accounts = [];
  Account? _selectedAccount;
  bool _isLoading = false;
  bool _isLoadingAccounts = true;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  @override
  void dispose() {
    _toAccountController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _isLoadingAccounts = true;
    });

    try {
      final session = Provider.of<SessionProvider>(context, listen: false);
      final result = await ApiService.getAccounts(session.currentUser!.userId);

      if (result['status'] == 'success') {
        final accountList = (result['accounts'] as List)
            .map((json) => Account.fromJson(json))
            .toList();

        setState(() {
          _accounts = accountList;
          if (_accounts.isNotEmpty) {
            _selectedAccount = _accounts[0];
          }
          _isLoadingAccounts = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Gagal mengambil data rekening';
          _isLoadingAccounts = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoadingAccounts = false;
      });
    }
  }

  Future<void> _handleTransfer() async {
    if (_selectedAccount == null) {
      setState(() {
        _errorMessage = 'Pilih rekening sumber terlebih dahulu';
      });
      return;
    }

    if (_toAccountController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Nomor rekening tujuan harus diisi!';
      });
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Jumlah transfer harus lebih dari 0!';
      });
      return;
    }

    if (_selectedAccount!.accountNumber == _toAccountController.text) {
      setState(() {
        _errorMessage = 'Tidak bisa transfer ke rekening yang sama!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final session = Provider.of<SessionProvider>(context, listen: false);
      final result = await ApiService.localTransfer(
        fromAccount: _selectedAccount!.accountNumber,
        toAccount: _toAccountController.text,
        amount: amount,
        customerId: session.currentUser!.userId,
        description: _descriptionController.text,
      );

      if (result['status'] == 'success') {
        setState(() {
          _successMessage = '✅ Transfer berhasil! ID transaksi: ${result['transaction_id']}';
          _toAccountController.clear();
          _amountController.clear();
          _descriptionController.text = 'Transfer lokal';
        });
        
        // Reload accounts to update balance
        _loadAccounts();
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Transfer gagal';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('💸 Transfer Lokal'),
        backgroundColor: const Color(0xFF2A2A3C),
        elevation: 0,
      ),
      body: _isLoadingAccounts
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_accounts.isEmpty)
                    const Center(
                      child: Text(
                        'Tidak ada rekening yang ditemukan',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  else ...[
                    const Text(
                      'Ambil dana dari rekening:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A3C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Account>(
                          isExpanded: true,
                          value: _selectedAccount,
                          dropdownColor: const Color(0xFF2A2A3C),
                          style: const TextStyle(color: Colors.white),
                          items: _accounts.map((account) {
                            return DropdownMenuItem<Account>(
                              value: account,
                              child: Text(
                                '${account.accountName} - ${account.accountNumber} (Saldo: Rp ${account.availableBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')})',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (Account? newValue) {
                            setState(() {
                              _selectedAccount = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Ke rekening tujuan:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _toAccountController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nomor rekening',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.account_balance, color: Colors.blueAccent),
                        filled: true,
                        fillColor: const Color(0xFF2A2A3C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Jumlah (Rp):',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _amountController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.attach_money, color: Colors.blueAccent),
                        filled: true,
                        fillColor: const Color(0xFF2A2A3C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Deskripsi:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descriptionController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Deskripsi transfer',
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon: const Icon(Icons.description, color: Colors.blueAccent),
                        filled: true,
                        fillColor: const Color(0xFF2A2A3C),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (_successMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _successMessage!,
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleTransfer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Kirim Transfer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
