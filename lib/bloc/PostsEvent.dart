
import 'package:equatable/equatable.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPosts extends PostsEvent {}

class CreatePost extends PostsEvent {
  final Map<String, dynamic> post;

  const CreatePost(this.post);

  @override
  List<Object> get props => [post];
}

class UpdatePost extends PostsEvent {
  final Map<String, dynamic> post;

  const UpdatePost(this.post);

  @override
  List<Object> get props => [post];
}

class DeletePost extends PostsEvent {
  final int id;

  const DeletePost(this.id);

  @override
  List<Object> get props => [id];
}