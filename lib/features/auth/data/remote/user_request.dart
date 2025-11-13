class SignInRequest {
  final String username;
  final String password;

  const SignInRequest({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }
}

class SignUpRequest {
  final String username;
  final String password;

  const SignUpRequest({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {'username': username, 'password': password};
  }
}