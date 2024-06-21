
import 'package:equatable/equatable.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {}

class PostsLoaded extends PostsState {
  final List posts;

  const PostsLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class PostsError extends PostsState {
  final String error;

  const PostsError({required this.error});

  @override
  List<Object> get props => [error];
}