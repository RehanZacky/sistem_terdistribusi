class ApiConfig {
  // Base URL untuk Service API
  static const String baseUrl = 'http://localhost:8000';
  
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
