import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../models/blog_model.dart';

class ReadBlogPage extends StatefulWidget {
  final Blog blog;

  const ReadBlogPage({super.key, required this.blog});

  @override
  State<ReadBlogPage> createState() => _ReadBlogPageState();
}

class _ReadBlogPageState extends State<ReadBlogPage> {
  late ScrollController _scrollController;
  var maxLines = 2;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >= 300 - kToolbarHeight) {
      setState(() {
        maxLines = 1;
      });
    } else {
      setState(() {
        maxLines = 2;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            shadowColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      bottomLeft: Radius.circular(6),
                    ),
                    color: _scrollController.hasClients &&
                            _scrollController.offset > 300 - kToolbarHeight
                        ? Colors.transparent
                        : Colors.black45,
                  ),
                  child: Hero(
                    tag: "${widget.blog.id}title",
                    child: Text(
                      widget.blog.title,
                      maxLines: maxLines,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: _scrollController.hasClients &&
                                _scrollController.offset > 300 - kToolbarHeight
                            ? Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87
                            : Colors.white,
                        fontSize: _scrollController.hasClients &&
                                _scrollController.offset > 300 - kToolbarHeight
                            ? 18.0
                            : 14.0,
                      ),
                    ),
                  ),
                ),
              ),
              centerTitle: true,
              background: Hero(
                tag: widget.blog.id,
                child: CachedNetworkImage(
                  imageUrl: widget.blog.photoUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: MarkdownBody(
                data: widget.blog.content,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(fontSize: 15, letterSpacing: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
