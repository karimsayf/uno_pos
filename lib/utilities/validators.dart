String? emptyFieldValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'لا يمكن أن يكون الحقل فارغاً';
  } else {
    return null;
  }
}

String? emailFieldValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'لا يمكن أن يكون الحقل فارغاً';
  } else if (!val.contains('@')) {
    return 'يرجى إدخال البريد الإلكتروني بشكل صحيح';
  } else {
    return null;
  }
}

String? phoneValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'لا يمكن أن يكون الحقل فارغاً';
  } else if (!val.toString().startsWith('0')) {
    return 'رقم الهاتف يجب أن يبدأ بصفر';
  } else if (val.toString().length != 11 || !isNumeric(val)) {
    return 'يرجى إدخال رقم الهاتف بشكل صحيح';
  } else {
    return null;
  }
}

String? passwordValidator(String? val) {
  if (val == null || val.isEmpty) {
    return 'لا يمكن أن يكون الحقل فارغاً';
  } else if (val.toString().length < 6) {
    return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
  } else {
    return null;
  }
}

bool isNumeric(String value) {
  return int.tryParse(value) != null;
}
