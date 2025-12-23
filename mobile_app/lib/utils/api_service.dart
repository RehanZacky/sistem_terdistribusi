import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiService {
  // Login / Verify Customer
  static Future<Map<String, dynamic>> verifyCustomer({
    required String username,
    required String pin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.verifyCustomerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Login gagal: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // Get Accounts for Customer (hanya Giro/CA)
  static Future<Map<String, dynamic>> getAccounts(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getAccountsForCustomer(customerId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Gagal mengambil data rekening: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // Get Balance for specific account
  static Future<Map<String, dynamic>> getBalance(String accountNumber) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getBalanceForAccount(accountNumber)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Gagal mengambil saldo: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // Local Transfer
  static Future<Map<String, dynamic>> localTransfer({
    required String fromAccount,
    required String toAccount,
    required double amount,
    required int customerId,
    String description = 'Transfer lokal',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.localTransferUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'from_account': fromAccount,
          'to_account': toAccount,
          'amount': amount,
          'customer_id': customerId,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Transfer gagal: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }

  // Get Transaction History
  static Future<Map<String, dynamic>> getTransactionHistory(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getTransactionHistoryForCustomer(customerId)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'status': 'error',
          'message': 'Gagal mengambil histori transaksi: ${response.body}',
        };
      }
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Tidak dapat terhubung ke server: $e',
      };
    }
  }
}
