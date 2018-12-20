import 'package:json_annotation/json_annotation.dart';
import 'post.dart';
part 'automatedpost.g.dart';



@JsonSerializable()
class AutomatedPost extends PostData{

  AutomatedPost(int userId, int id, String title, String body){
    super.userId = userId;
    super.id = id;
    super.title = title;
    super.body = body;
  }

  factory AutomatedPost.fromJson(Map<String, dynamic> json) => _$AutomatedPostFromJson(json);

  Map<String, dynamic> toJson() => _$AutomatedPostToJson(this);

  @override
  String toString() {
    return "!! AUTOMATICALLY PARSED !!\nPost id: $id\nUser id: $userId\nTitle: $title\nBody: $body\n\n";
  }
}