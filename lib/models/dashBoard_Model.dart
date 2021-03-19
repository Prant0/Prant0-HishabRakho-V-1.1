class DashBoardModel {
  int entry;
  dynamic totalAmount;
  dynamic totalBankAmount;
  dynamic totalMfsAmount;
  dynamic totalCashAmount;
  List<BankDetails> bankDetails;

   List<MfsDetails> mfsDetails;
  dynamic totalPayable;
  dynamic totalReceivable;

  DashBoardModel(
      {this.entry,
      this.totalAmount,
      this.totalBankAmount,
      this.totalMfsAmount,
      this.totalCashAmount,
      this.bankDetails,
       this.mfsDetails,
      this.totalPayable,
      this.totalReceivable});

  factory DashBoardModel.fromJson(Map<String, dynamic> json) {
    return DashBoardModel(
      entry: json["entry"],
      totalAmount: json["total_amount"],
      totalBankAmount: json["total_bank_amount"],
      totalMfsAmount: json["total_mfs_amount"],
      totalCashAmount: json["total_cash_amount"],
      totalPayable: json["total_payable"],
      totalReceivable: json["total_receivable"],
      bankDetails: parseBankDetails(json),
      mfsDetails: mfsDetailss(json),
    );
  }

  static List<BankDetails> parseBankDetails(bankJson) {
    var list = bankJson["bank_details"] as List;
    List<BankDetails> bankDetailsList =
        list.map((data) => BankDetails.fromJson(data)).toList();
    return bankDetailsList;
  }

  static List<MfsDetails> mfsDetailss(mfsJson) {
    var list = mfsJson["mfs_details"] as List;
    List<MfsDetails> mfsDetailsList =
    list.map((data) => MfsDetails.fromJson(data)).toList();
    return mfsDetailsList;
  }
}

class BankDetails {
  int id;
  String storageHubName;
  String storageHubLogo;
  String userStorageHubAccountNumber;
  String userStorageHubAccountName;
  dynamic balance;
  String date;
  dynamic currentBankBalance;

  BankDetails(
      {this.id,
      this.storageHubName,
      this.storageHubLogo,
      this.userStorageHubAccountNumber,
      this.userStorageHubAccountName,
      this.balance,
      this.date,
      this.currentBankBalance});

  factory BankDetails.fromJson(Map<String, dynamic> parsedJson) {
    return BankDetails(
      id: parsedJson["id"],
      storageHubName: parsedJson["storage_hub_name"],
      storageHubLogo: parsedJson["storage_hub_logo"],
      userStorageHubAccountNumber:
          parsedJson["user_storage_hub_account_number"],
      userStorageHubAccountName: parsedJson["user_storage_hub_account_name"],
      balance: parsedJson["balance"],
      date: parsedJson["date"],
      currentBankBalance: parsedJson["current_bank_balance"],
    );
  }
}

class MfsDetails {
  int id;
  String storageHubName;
  String storageHubLogo;
  String userStorageHubAccountNumber;
  dynamic balance;
  String date;
  dynamic currentMfsBalance;

  MfsDetails(
      {this.id,
      this.storageHubName,
      this.storageHubLogo,
      this.userStorageHubAccountNumber,
      this.balance,
      this.date,
      this.currentMfsBalance});

  factory MfsDetails.fromJson(Map<String, dynamic> json) {
    return MfsDetails(
      id: json['id'],
      storageHubName: json['storage_hub_name'],
      storageHubLogo: json['storage_hub_logo'],
      userStorageHubAccountNumber: json['user_storage_hub_account_number'],
      balance: json['balance'],
      date: json['date'],
      currentMfsBalance: json['current_mfs_balance'],
    );
  }
}
