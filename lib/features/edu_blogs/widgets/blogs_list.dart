import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../cubits/blogs/blogs_cubit.dart';
import 'blog_item.dart';

class BlogsList extends StatefulWidget {
  const BlogsList({super.key});

  @override
  State<BlogsList> createState() => _BlogsListState();
}

class _BlogsListState extends State<BlogsList> {
  final _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('get more blogs');
      print(_scrollController.position.maxScrollExtent);

      context.read<BlogsCubit>().getMoreBlogs();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((_) async {
      final blogsCubit = context.read<BlogsCubit>();

      if (blogsCubit.state.status == BlogsStatus.initial) {
        blogsCubit.getBlogs();
      }
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogsCubit, BlogsState>(
      builder: (context, state) {
        if (state.status == BlogsStatus.loading) {
          // Show shimmer loading for the initial loading state
          return ListView.builder(
            padding: const EdgeInsets.only(top: 4),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[300]!
                    : Colors.grey[900]!,
                highlightColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey[100]!
                    : Colors.grey[800]!,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: 100.0,
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        height: 16.0,
                      ),
                      const SizedBox(height: 8.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100.0,
                        height: 16.0,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state.status == BlogsStatus.error) {
          // Show error message
          return const Center(
            child: Text(
              'Error Loading Blogs!',
              textAlign: TextAlign.center,
            ),
          );
        }

        // Show existing blogs with animations and shimmer effect for more loading
        return AnimationLimiter(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 4),
            itemCount: state.blogs.length +
                (state.status == BlogsStatus.moreLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < state.blogs.length) {
                // Display the existing blog items with staggered animations
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 15.0,
                    child: FadeInAnimation(
                      child: BlogItem(blog: state.blogs[index]),
                    ),
                  ),
                );
              } else {
                // Display shimmer effect at the end while more blogs are loading
                return Shimmer.fromColors(
                  baseColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[300]!
                      : Colors.grey[900]!,
                  highlightColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[100]!
                          : Colors.grey[800]!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 100.0,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          height: 16.0,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: 100.0,
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
