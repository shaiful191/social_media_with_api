import 'package:flutter/material.dart';
import 'package:social_meadia_with_api/services/apiServices.dart';
import 'package:social_meadia_with_api/utils/Snackbarhelper.dart';

class UpdatePostPage extends StatefulWidget {
  const UpdatePostPage({super.key});

  @override
  State<UpdatePostPage> createState() => _UpdatePostPageState();
}

class _UpdatePostPageState extends State<UpdatePostPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
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
                    var updateBody = {
                      "id": 1,
                      "title": titleController.text.toString(),
                      "body": descriptionController.text.toString(),
                      "userId": 1,
                    };
                    await updatePost(updateBody);
                  },
                  child: const Text('Update Post')),
        ],
      ),
    );
  }

  Future<void> updatePost(var updateBody) async {
    try {
      isLoading = true;

      final res = await ApiServices.updateApi(
        'https://jsonplaceholder.typicode.com/posts/1',
        updateBody,
        {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print('response:' + res.body);

      if (res.body != null) {
        isLoading = false;
        showSuccessMessage(context, massage: 'Post Updated Successfully');
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
