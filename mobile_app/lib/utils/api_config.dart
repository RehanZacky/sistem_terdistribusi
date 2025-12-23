import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  // Default Base URL
  static const String defaultBaseUrl = 'http://127.0.0.1:8000';
  
  // Dynamic base URL that can be changed from settings
  static String _baseUrl = defaultBaseUrl;
  
  static String get baseUrl => _baseUrl;
  
  // Initialize and load saved base URL
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString('base_url') ?? defaultBaseUrl;
  }
  
  // Save new base URL
  static Future<void> setBaseUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('base_url', url);
    _baseUrl = url;
  }
  
  // Reset to default
  static Future<void> resetToDefault() async {
    await setBaseUrl(defaultBaseUrl);
  }
  
  // Endpoints
  static const String verifyCustomer = '/internal/customer/verify';
  static const String getAccounts = '/internal/account/customer';
  static const String getBalance = '/internal/account/balance';
  static const String localTransfer = '/internal/transfer/local';
  static const String transactionHistory = '/internal/transaction/history';
  
  // Helper methods
  static String getAccountsForCustomer(int customerId) {
    return '$baseUrl$getAccounts/$customerId';
  }
  
  static String getBalanceForAccount(String accountNumber) {
    return '$baseUrl$getBalance/$accountNumber';
  }
  
  static String getTransactionHistoryForCustomer(int customerId) {
    return '$baseUrl$transactionHistory/$customerId';
  }
  
  static String get verifyCustomerUrl => '$baseUrl$verifyCustomer';
  static String get localTransferUrl => '$baseUrl$localTransfer';
}
