import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/blogs/blogs_cubit.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  void searchBlogs(String query, BuildContext context) {
    context.read<BlogsCubit>().getBlogsBySearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      leading: const Icon(CupertinoIcons.search),
      hintText: 'Search here what you looking for ...',
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) => searchBlogs(value, context),
      elevation: WidgetStateProperty.all(0.0),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20),
      ),
      constraints: const BoxConstraints(
        maxHeight: 60,
        minHeight: 50,
      ),
      shape: WidgetStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    );
  }
}
