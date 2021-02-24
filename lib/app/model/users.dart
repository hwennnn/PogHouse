class User {
  User({this.id, this.nickname, this.photoUrl});
  final String id;
  final String nickname;
  final String photoUrl;

  factory User.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String nickname = data['nickname'];
    final String photoUrl = data['photoUrl'];

    return User(
      id: id,
      nickname: nickname,
      photoUrl: photoUrl,
    );
  }
}
