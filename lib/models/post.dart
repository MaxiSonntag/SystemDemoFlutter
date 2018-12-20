abstract class PostData{
  int id;
  int userId;
  String title;
  String body;
}

class Post extends PostData{

  Post({int userId, int id, String title, String body}){
    super.userId = userId;
    super.id = id;
    super.title = title;
    super.body = body;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  @override
  String toString() {
    return "!! MANUALLY PARSED !!\nPost id: $id\nUser id: $userId\nTitle: $title\nBody: $body\n\n";
  }
}
