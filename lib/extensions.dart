import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

extension StringUtils on String {
  BigInt parse18Decimals() {
    return (Decimal.parse(this) * Decimal.ten.pow(18).toDecimal()).toBigInt();
  }

  String format18Decimals() {
    return Decimal.parse(
      (BigInt.parse(this) / BigInt.from(10).pow(18)).toString(),
    ).toString();
  }

  String formatDollars() {
    final dollarFormat = NumberFormat.currency(locale: "en_US", symbol: "\$");
    return dollarFormat.format(double.parse(format18Decimals()));
  }

  String ellipsizeAddress() {
    if (length <= 10) {
      return this;
    }
    String firstSix = substring(0, 6);
    String lastFour = substring(length - 4);
    return '$firstSix...$lastFour';
  }
}
