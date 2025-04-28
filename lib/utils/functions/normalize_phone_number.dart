String normalizePhoneNumber(String input) {
  String phone = input.trim();
  if (phone.startsWith('+62')) {
    return phone; // Already correct
  } else if (phone.startsWith('0')) {
    return '+62${phone.substring(1)}'; // Remove leading 0, add +62
  } else if (phone.startsWith('62')) {
    return '+$phone'; // Add '+' if missing
  } else {
    return '+62$phone'; // Assume missing all prefix
  }
}