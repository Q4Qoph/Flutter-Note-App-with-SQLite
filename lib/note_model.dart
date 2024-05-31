class Note{
  final int id;
  final String title;
  final String body;

  Note({required this.id, required this.title, required this.body});

  Map<String,dynamic> toMap(){
    return({
      'id':id,
      'title': title,
      'body': body,
    });
  }
}