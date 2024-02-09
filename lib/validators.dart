String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Обязательное поле';
  } else if (name.contains(' ')) {
    return 'Поле не должно содержать пробелов';
  }
  return null;
}
