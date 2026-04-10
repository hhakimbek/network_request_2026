import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_request_2026/model/post_model.dart';
import 'package:network_request_2026/services/http_service.dart';

class DetailPage extends StatefulWidget {
  final int postId;
  const DetailPage({super.key, required this.postId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  TextEditingController bodyCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();

  Post post = Post(userId: 0, id: 0, title: "...", body: "...");
  bool isLoading = true;


  @override
  void initState() {
    _apiGetPost();
    super.initState();
  }

  void _apiGetPost() {
    Network.GET("${Network.API_LIST}/${widget.postId}").then((value) {
      if(value!=null) {
        Map<String,dynamic> json = jsonDecode(value);
        post = Post.fromJson(json);
        bodyCtrl.text = post.body;
        titleCtrl.text = post.title;
        isLoading = false;
      } else {
        isLoading = false;
      }
      setState(() {});
    },);
  }

  void _deletePost() {
    isLoading = true;
    setState(() {

    });
    Network.DELETE("${Network.API_DELETE}/${post.id}").then((value) {
      isLoading = false;
      setState(() {
      });
      Navigator.pop(context);
    },);
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
      setState(() {

      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.id.toString()),
        actions: [
          IconButton(
            onPressed: () {
              _deletePost();
            },
            icon: Icon(CupertinoIcons.delete,color: Colors.red,),
          )
        ],
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
    );
  }
}
