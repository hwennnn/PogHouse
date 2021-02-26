class APIPath {
  static String aPeople(String uid) => 'people/$uid';
  static String people() => 'people/';
  static String peopleFav(String uid) => 'people/$uid/favorite/';
  static String room(String roomId) => 'rooms/$roomId/';
  static String rooms(String uid) => 'people/$uid/rooms/';
}
