part of 'blog_categories_cubit.dart';

enum BlogCategoriesStatus { initial, loading, loaded, error }

class BlogCategoriesState extends Equatable {
  final List<String> blogCategories;
  final BlogCategoriesStatus status;
  final CustomError error;

  const BlogCategoriesState({
    required this.blogCategories,
    required this.status,
    required this.error,
  });

  factory BlogCategoriesState.initial() => const BlogCategoriesState(
        blogCategories: [
          "All",
          "Nutrition and Diet",
          "Exercise and Workouts",
          "Mental Health",
          "Fitness T&T",
          "Lifestyle and Wellness",
          "Sports"
        ],
        status: BlogCategoriesStatus.initial,
        error: CustomError(),
      );

  @override
  String toString() =>
      'BlogCategoriesState(blogCategories: $blogCategories, status: $status, error: $error)';

  BlogCategoriesState copyWith({
    List<String>? blogCategories,
    BlogCategoriesStatus? status,
    CustomError? error,
  }) {
    return BlogCategoriesState(
      blogCategories: blogCategories ?? this.blogCategories,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [blogCategories, status, error];
}
