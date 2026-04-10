import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:network_request_2026/pages/create_post_page.dart';
import 'package:network_request_2026/pages/detail_page.dart';
import '../model/post_model.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> posts = [];
  bool isLoading = true;

  void _apiPostList() {
    setState(() {
      isLoading = true;
    });
    Network.GET(Network.API_LIST).then((response) {
      if (response != null) {
        final List decoded = jsonDecode(response);
        setState(() {
          posts = decoded.map((e) => Post.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _apiPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        actions: [
          IconButton(
            onPressed: () {
              _apiPostList();
            },
            icon: Icon(Icons.get_app),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : posts.isEmpty
          ? const Center(child: Text("No data"))
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => DetailPage(postId: post.id),)),
                  leading: Text("#${post.id}"),
                  title: Text(post.title),
                  subtitle: Text(post.body),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool value = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePostPage(),));
          if(value) {
            _apiPostList();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
