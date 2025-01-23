part of 'blogs_cubit.dart';

enum BlogsStatus { initial, loading, moreLoading, loaded, error }

class BlogsState extends Equatable {
  final List<Blog> blogs;
  final BlogsStatus status;
  final CustomError error;

  const BlogsState({
    required this.blogs,
    required this.status,
    required this.error,
  });

  factory BlogsState.initial() => const BlogsState(
        blogs: [],
        status: BlogsStatus.initial,
        error: CustomError(),
      );

  @override
  String toString() =>
      'BlogsState(blogs: $blogs, status: $status, error: $error)';

  BlogsState copyWith({
    List<Blog>? blogs,
    BlogsStatus? status,
    CustomError? error,
  }) {
    return BlogsState(
      blogs: blogs ?? this.blogs,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [blogs, status, error];
}
