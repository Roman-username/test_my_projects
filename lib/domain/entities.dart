class User {
  final String uid;
  final String? name;
  final String? lastName;
  final String? photoURL;
  final String? email;

  const User({
    required this.uid,
    required this.name,
    required this.lastName,
    this.email,
    this.photoURL,
  });
}
