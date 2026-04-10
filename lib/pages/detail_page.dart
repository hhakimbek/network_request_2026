import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:network_request_2026/model/post_model.dart';
import 'package:network_request_2026/pages/edit_post_page.dart';
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
  bool isLoading = false;


  @override
  void initState() {
    _apiGetPost();
    super.initState();
  }

  void _apiGetPost() {
    isLoading = true;
    setState(() {

    });
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${post.id}"),
        actions: [
          IconButton(
            onPressed: () {
              _deletePost();
            },
            icon: Icon(CupertinoIcons.delete,color: Colors.red,),
          ),
          IconButton(
            onPressed: () async {
              bool value = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostPage(post: post),));
              if(value) {
                _apiGetPost();
              }
            },
            icon: Icon(Icons.edit,color: Colors.blue,),
          ),
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
              Text(post.title),
              SizedBox(height: 20,),
              Text("Body",style: TextStyle(fontSize: 11,color: Colors.grey),),
              Text(post.body),
            ],
          ),
        ),
      ),
    );
  }
}
