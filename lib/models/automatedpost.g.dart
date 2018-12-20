// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automatedpost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomatedPost _$AutomatedPostFromJson(Map<String, dynamic> json) {
  return AutomatedPost(json['userId'] as int, json['id'] as int,
      json['title'] as String, json['body'] as String);
}

Map<String, dynamic> _$AutomatedPostToJson(AutomatedPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body
    };
