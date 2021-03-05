class People {
  People({this.id, this.nickname, this.photoUrl});
  final String id;
  final String nickname;
  final String photoUrl;

  factory People.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    final String id = data['id'];
    final String nickname = data['nickname'];
    final String photoUrl = data['photoUrl'];

    return People(
      id: id,
      nickname: nickname,
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'photoUrl': photoUrl,
    };
  }
}
