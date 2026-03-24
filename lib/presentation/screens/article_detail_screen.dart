import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/Article.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.article.sourceName),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(widget.article.url, subject: widget.article.title);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(widget.article.url)),
          ),
        ],
      ),
    );
  }
}