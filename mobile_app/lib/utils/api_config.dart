class ApiConfig {
  // Base URL untuk Service API
  // Gunakan 127.0.0.1 untuk Chrome/Web atau IP komputer untuk mobile device
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // Alternative: Jika run di mobile device fisik, ganti dengan IP komputer
  // Contoh: static const String baseUrl = 'http://192.168.1.10:8000';
  
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
