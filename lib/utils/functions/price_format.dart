import 'package:intl/intl.dart';

extension FormattedPrice on int  {
  static final NumberFormat formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );
  String formatPrice() {
    return formatter.format(this);
  }
}

extension FormattedPriceDouble on double  {
  static final NumberFormat formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );
  String formatPrice() {
    return formatter.format(this);
  }
}