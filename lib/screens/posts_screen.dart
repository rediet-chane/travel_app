import 'package:flutter/material.dart';
import '../controllers/api_handler.dart';
import '../models/post_model.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final ApiHandler apiHandler = ApiHandler();
  List<PostModel> currentPosts = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    loadPage(1);
  }

  Future<void> loadPage(int pageNumber) async {
    if (isLoading) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      List<PostModel> newPosts = await apiHandler.fetchPostsPage(pageNumber);
      
      setState(() {
        if (newPosts.isEmpty) {
          hasMore = false;
        } else {
          currentPosts = newPosts;
          currentPage = pageNumber;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  void goToNextPage() {
    if (hasMore) {
      loadPage(currentPage + 1);
    }
  }

  void goToPreviousPage() {
    if (currentPage > 1) {
      loadPage(currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Page indicator
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Page $currentPage',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Content area
          Expanded(
            child: isLoading && currentPosts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : currentPosts.isEmpty
                    ? const Center(child: Text('No posts found'))
                    : ListView.builder(
                        itemCount: currentPosts.length,
                        itemBuilder: (context, index) {
                          final post = currentPosts[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Text(
                                          '${post.id}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          post.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    post.body,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          
          // Loading indicator for page changes
          if (isLoading && currentPosts.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          
          // Previous/Next buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button
                Expanded(
                  child: ElevatedButton(
                    onPressed: currentPage > 1 ? goToPreviousPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('← Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Next button
                Expanded(
                  child: ElevatedButton(
                    onPressed: hasMore ? goToNextPage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Next →'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}