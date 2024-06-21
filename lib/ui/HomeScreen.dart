import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/PostsBloc.dart';
import '../bloc/PostsEvent.dart';
import '../bloc/PostsState.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment App')),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsLoaded) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return ListTile(
                  title: Text(post['title']),
                  subtitle: Text(post['body']),
                  onLongPress: () {
                    _showDeleteDialog(context, post['id']);
                  },
                  onTap: () {
                    _showPostDialog(context, post: post);
                  },
                );
              },
            );
          } else if (state is PostsError) {
            return Center(child: Text('Failed to fetch posts: ${state.error}'));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPostDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      builder: (context) {
        return Builder(
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Delete will not work as this is fake API?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _deletePost(context, postId);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }



  void _showPostDialog(BuildContext context, {Map<String, dynamic>? post}) {
    final titleController = TextEditingController(text: post?['title']);
    final bodyController = TextEditingController(text: post?['body']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(post == null ? 'Add Post' : 'Update Post'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPost = {
                  'title': titleController.text,
                  'body': bodyController.text,
                  if (post != null) 'id': post['id'],
                };

                Navigator.of(context).pop();
                if (post == null) {
                  context.read<PostsBloc>().add(CreatePost(newPost));
                } else {
                  context.read<PostsBloc>().add(UpdatePost(newPost));
                }
                Navigator.of(context).pop();
              },
              child: Text(post == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
  void _deletePost(BuildContext context, int id) {
    context.read<PostsBloc>().add(DeletePost(id));
  }
}
