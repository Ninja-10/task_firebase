
class AppFormValidator {
  String _validatePhoneNumber(String phoneNumber) {
    print("Inside if block");
    if (phoneNumber.length != 10) {
      return "Please enter a valid phone number";
    }

    return null;
  }

    AppFormValidatorData validatePhoneNumber(String phoneNumber) {
    String _phoneNumberError;
    bool _isValid = false;
    if (phoneNumber != null) {
      _phoneNumberError = _validatePhoneNumber(phoneNumber);
      if (_phoneNumberError != null) {
        _isValid = false;
      } else {
        _isValid = true;
      }
    }
    return AppFormValidatorData(
        phoneNumberError: _phoneNumberError, isValid: _isValid);
  }
}

class AppFormValidatorData {
  final String emailError;
  final String phoneNumberError;
  final String passwordError;
  final String nameError;
  final bool isValid;
  // final bool isPhoneNumberValid;
  // final bool isEmailValid;
  // final bool isNameValid;
  // final bool isPasswordValid;

  AppFormValidatorData(
      {this.emailError,
      this.phoneNumberError,
      this.nameError,
      this.passwordError,
        this.isValid
        // this.isEmailValid,
        // this.isPhoneNumberValid,
        // this.isNameValid,
        // this.isPasswordValid

      });
}