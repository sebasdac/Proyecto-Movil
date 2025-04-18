class User {
  final String accessToken;
  final String refreshToken;
  final String usuarioID;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.usuarioID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      usuarioID: json['usuarioID'],
    );
  }
}
