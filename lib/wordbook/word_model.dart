class Word {
  String eng, kor, engSentence, korSentence;

  Word({
    required this.eng,
    required this.kor,
    required this.engSentence,
    required this.korSentence,
  });

  Word.fromMap(Map<String, dynamic> map)
      : eng = map['eng'],
        kor = map['kor'],
        engSentence = map['engSentence'],
        korSentence = map['korSentence'];
}
