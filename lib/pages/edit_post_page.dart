import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_request_2026/model/post_model.dart';
import 'package:network_request_2026/services/http_service.dart';

class EditPostPage extends StatefulWidget {
  final Post post;
  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {

  TextEditingController bodyCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();

  late Post post;
  bool isLoading = true;
  bool isChange = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    post = widget.post;
    bodyCtrl.text = post.body;
    titleCtrl.text = post.title;
    isLoading = false;
    setState(() {

    });
  }

  void _updatePost() {
    String title  = titleCtrl.text.trim();
    String body  = bodyCtrl.text.trim();
    if(title.isEmpty || body.isEmpty) {
      print("Malumotlar bo'sh");
      return;
    }
    if(title==post.title && body==post.body) {
      print("O'zgarish yo'q");
      return;
    }
    post.body = body;
    post.title = title;

    isLoading = true;
    setState(() {

    });

    Network.PUT("${Network.API_DELETE}/${post.id}",post.toJson()).then((value) {
      isLoading = false;
      isChange = true;
      setState(() {

      });
      Navigator.pop(context,isChange);
    },);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(!didPop) {
          Navigator.pop(context,isChange);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("#${post.id}"),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: isLoading?
            CircularProgressIndicator()
                :Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Title",style: TextStyle(fontSize: 11,color: Colors.grey),),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                Text("Body",style: TextStyle(fontSize: 11,color: Colors.grey),),
                TextField(
                  controller: bodyCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 20,),
                MaterialButton(
                    onPressed: () {
                      _updatePost();
                    },
                    minWidth: double.infinity,
                    color: Colors.blueAccent,
                    child: Text("Update",style: TextStyle(color: Colors.white),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
