
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tech_wire/data/services/api_service.dart';
import 'package:tech_wire/presentation/screens/article_detail_screen.dart';
import '../../data/models/Article.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<Article> articles = [];
  final ApiService api = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchTopHeadlines(category: "technology");
      setState(() {
        articles = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading news: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechWire"),
        centerTitle: true,
      ),
      body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: fetchArticles,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                  final article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(12),),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          article.urlToImage != ''
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                                child: Image.network(
                                  article.urlToImage,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                             ) : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(article.title, style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        article.sourceName,
                                        style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                            )
                          ],
                      ),
                    ),
                  );
              })),
    );
  }
}
