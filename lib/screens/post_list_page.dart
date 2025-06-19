import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:social_meadia_with_api/model/post_model.dart';
import 'package:social_meadia_with_api/screens/create_post_page.dart';
import 'package:social_meadia_with_api/screens/update_post_page.dart';
import 'package:social_meadia_with_api/services/apiServices.dart';
import 'package:social_meadia_with_api/utils/Snackbarhelper.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdatePostPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title:
                                  Text(snapshot.data![index].title.toString()),
                              subtitle:
                                  Text(snapshot.data![index].body.toString()),
                              leading: CircleAvatar(
                                child:
                                    Text(snapshot.data![index].id.toString()),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async{
                                 await deletePost(snapshot.data![index].id);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<PostModel>> fetchPosts() async {
    List<PostModel> postList = [];

    try {
      String url = 'https://jsonplaceholder.typicode.com/posts';

      final res = await ApiServices.getApi(url);

      if (res != null) {
        postList.clear();
        var posts = jsonDecode(res.body.toString());
        for (var post in posts) {
          postList.add(PostModel.fromJson(post));
        }
        return postList;
      } else {
        return postList;
      }
    } catch (e) {
      print('Error fetching posts: $e');
      return postList;
    }
  }


  Future<void> deletePost(int ?id) async {
    try {
      isLoading = true; 

      final res = await ApiServices.deleteApi(
        'https://jsonplaceholder.typicode.com/posts/$id',
        {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (res.body != null) {
        isLoading = false;
        showSuccessMessage(context, massage: 'Post Deleted Successfully');
        // return true;
      } else {
        isLoading = false;
        showErrorMessage(context, massage: 'Something went worng!');
        // return false;
      }
    } catch (e) {
      isLoading = false;
      showErrorMessage(context, massage: 'Something went worng!');
      print(e);
      // return false;
    }
  }


}
