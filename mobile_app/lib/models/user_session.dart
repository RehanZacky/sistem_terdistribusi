class UserSession {
  final int userId;
  final String username;
  final String customerName;
  
  UserSession({
    required this.userId,
    required this.username,
    required this.customerName,
  });
  
  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      userId: json['user_id'],
      username: json['username'] ?? '',
      customerName: json['customer_name'] ?? '',
    );
  }
}

class Account {
  final int accountId;
  final String accountNumber;
  final String accountName;
  final String accountType;
  final String currency;
  final double availableBalance;
  final double clearBalance;
  final String productName;
  
  Account({
    required this.accountId,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currency,
    required this.availableBalance,
    required this.clearBalance,
    required this.productName,
  });
  
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'],
      accountNumber: json['account_number'],
      accountName: json['account_name'],
      accountType: json['account_type'] ?? '',
      currency: json['currency'],
      availableBalance: (json['available_balance'] as num).toDouble(),
      clearBalance: (json['clear_balance'] as num).toDouble(),
      productName: json['product_name'],
    );
  }
}

class Transaction {
  final int transactionId;
  final String type;
  final double amount;
  final String from;
  final String to;
  final String status;
  final String date;
  
  Transaction({
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.from,
    required this.to,
    required this.status,
    required this.date,
  });
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      from: json['from'] ?? '',
      to: json['to'] ?? '',
      status: json['status'],
      date: json['date'],
    );
  }
}
