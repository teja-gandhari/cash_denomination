class NumberToTextConverter {
  static final List<String> _units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ];

  static final List<String> _tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  static String convertToIndianText(int number) {
    if (number == 0) {
      return 'Zero Rupees';
    }

    if (number < 0) {
      return 'Minus ${convertToIndianText(-number)}';
    }

    String words = '';

    // Handle crore part
    if ((number ~/ 10000000) > 0) {
      words += '${_convertLessThanThousand(number ~/ 10000000)} Crore ';
      number %= 10000000;
    }

    // Handle lakh part
    if ((number ~/ 100000) > 0) {
      words += '${_convertLessThanThousand(number ~/ 100000)} Lakh ';
      number %= 100000;
    }

    // Handle thousand part
    if ((number ~/ 1000) > 0) {
      words += '${_convertLessThanThousand(number ~/ 1000)} Thousand ';
      number %= 1000;
    }

    // Handle hundred part
    if ((number ~/ 100) > 0) {
      words += '${_convertLessThanThousand(number ~/ 100)} Hundred ';
      number %= 100;
    }

    // Handle remaining number (less than 100)
    if (number > 0) {
      if (words.isNotEmpty) {
        words += 'and ';
      }
      words += _convertLessThanHundred(number);
    }

    return '${words.trim()} Rupees';
  }

  static String _convertLessThanThousand(int number) {
    if (number == 0) {
      return '';
    }

    String words = '';

    if ((number ~/ 100) > 0) {
      words += '${_units[number ~/ 100]} Hundred ';
      number %= 100;
    }

    if (number > 0) {
      if (words.isNotEmpty) {
        words += 'and ';
      }
      words += _convertLessThanHundred(number);
    }

    return words.trim();
  }

  static String _convertLessThanHundred(int number) {
    if (number < 20) {
      return _units[number];
    } else {
      String words = _tens[number ~/ 10];
      if ((number % 10) > 0) {
        words += ' ${_units[number % 10]}';
      }
      return words;
    }
  }
}