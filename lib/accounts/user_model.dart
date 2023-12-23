class User {
  String username, id;
  int money, basicWordsIndex;
  dynamic email;

  User({
    required this.username,
    required this.id,
    required this.money,
    required this.basicWordsIndex,
    required this.email,
  });

  User.fromMap(Map<String, dynamic> map)
      : username = map['username'],
        id = map['id'],
        money = map['money'],
        basicWordsIndex = map['basicWordsIndex'],
        email = map['email'];
}
