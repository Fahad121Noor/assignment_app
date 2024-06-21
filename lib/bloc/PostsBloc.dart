import 'package:assignment_app/bloc/PostsEvent.dart';
import 'package:assignment_app/bloc/PostsState.dart';
import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../api/ApiService.dart';

class PostsBloc extends HydratedBloc<PostsEvent, PostsState> {
  final ApiService apiService;
  PostsBloc({required this.apiService}) : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<CreatePost>(_onCreatePost);
    on<UpdatePost>(_onUpdatePost);
    on<DeletePost>(_onDeletePost);
  }

  void _onFetchPosts(FetchPosts event, Emitter<PostsState> emit) async {
    emit(PostsLoading());
    try {
      final response = await apiService.get('/posts');
      emit(PostsLoaded(posts: response.data));
    } catch (error) {
      emit(PostsError(error: error.toString()));
    }
  }

  void _onCreatePost(CreatePost event, Emitter<PostsState> emit) async {
    try {
      await apiService.post('/posts', event.post);
      add(FetchPosts());
    } catch (error) {
      emit(PostsError(error: error.toString()));
    }
  }

  void _onUpdatePost(UpdatePost event, Emitter<PostsState> emit) async {
    try {
      await apiService.put('/posts/${event.post['id']}', event.post);
      add(FetchPosts());
    } catch (error) {
      emit(PostsError(error: error.toString()));
    }
  }

  void _onDeletePost(DeletePost event, Emitter<PostsState> emit) async {
    try {
      await apiService.delete('/posts/${event.id}');
      add(FetchPosts());
    } catch (error) {
      emit(PostsError(error: error.toString()));
    }
  }

  @override
  PostsState? fromJson(Map<String, dynamic> json) {
    try {
      final posts = json['posts'] as List;
      final DateTime timestamp = DateTime.parse(json['timestamp']);
      if (DateTime.now().difference(timestamp) < Duration(minutes: 1)) {
        return PostsLoaded(posts: posts);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PostsState state) {
    if (state is PostsLoaded) {
      return {
        'posts': state.posts,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    return null;
  }
}
