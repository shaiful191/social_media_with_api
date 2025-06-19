import 'package:flutter/material.dart';
import 'package:social_meadia_with_api/services/apiServices.dart';
import 'package:social_meadia_with_api/utils/Snackbarhelper.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    var createBody = {
                      "title": titleController.text.toString(),
                      "description": descriptionController.text.toString(),
                      "userId": 1,
                    };
                    await createPost(createBody);
                  },
                  child: const Text('Create Post')),
        ],
      ),
    );
  }

  Future<void> createPost(var createBody) async {
    try {
      isLoading = true;

      final res = await ApiServices.postApi(
        'https://jsonplaceholder.typicode.com/posts',
        createBody,
        {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print('response:' + res.body);

      if (res.body != null) {
        isLoading = false;
        showSuccessMessage(context, massage: 'Post Created Successfully');
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
