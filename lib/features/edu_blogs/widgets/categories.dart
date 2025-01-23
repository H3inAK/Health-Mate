import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../cubits/blogs/blogs_cubit.dart';
import '../cubits/categories/blog_categories_cubit.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final categories = [
    "All",
    "Nutrition and Diet",
    "Exercise and Workouts",
    "Mental Health",
    "Fitness T&T",
    "Lifestyle and Wellness",
    "Sports"
  ];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      final blogCategoriesCubit = context.read<BlogCategoriesCubit>();
      if (blogCategoriesCubit.state.status == BlogCategoriesStatus.initial) {
        blogCategoriesCubit.getBlogCategories();
      }
    });
    super.initState();
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    context.read<BlogsCubit>().getBlogsByCategory(category);
  }

  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: BlocBuilder<BlogCategoriesCubit, BlogCategoriesState>(
        builder: (context, state) {
          if (state.status == BlogCategoriesStatus.loading) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade300
                  : Colors.grey.shade900,
              highlightColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade100
                  : Colors.grey.shade800,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  return ChoiceChip(
                    label: Text(categories[index]),
                    selected: categories[index] == selectedCategory,
                    onSelected: (bool selected) {
                      selectCategory(categories[index]);
                    },
                  );
                },
              ),
            );
          }

          if (state.status == BlogCategoriesStatus.error) {
            print('categories error');
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return ChoiceChip(
                  label: Text(categories[index]),
                  selected: categories[index] == selectedCategory,
                  onSelected: (bool selected) {
                    selectCategory(categories[index]);
                  },
                );
              },
            );
          }

          final blogCategories = state.blogCategories;
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: blogCategories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return ChoiceChip(
                label: Text(blogCategories[index]),
                selected: blogCategories[index] == selectedCategory,
                onSelected: (bool selected) {
                  selectCategory(blogCategories[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}
