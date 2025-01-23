import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/custom_error.dart';
import '../../models/blog_model.dart';
import '../../repositories/blogs_repository.dart';

part 'blogs_state.dart';

class BlogsCubit extends Cubit<BlogsState> {
  BlogsCubit(
    this.blogsRepository,
  ) : super(BlogsState.initial());

  final BlogsRepository blogsRepository;

  List<Blog> get blogs => state.blogs;

  int _currentPage = 1;
  final int _limit = 6;

  Future<void> getBlogs({int allLimit = 6}) async {
    emit(state.copyWith(status: BlogsStatus.loading));
    try {
      final blogs = await blogsRepository.fetchBlogs(limit: allLimit);
      emit(state.copyWith(
        status: BlogsStatus.loaded,
        blogs: blogs,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogsStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }

  Future<void> getMoreBlogs() async {
    if (state.status == BlogsStatus.moreLoading ||
        state.status == BlogsStatus.loading) return;

    _currentPage++;
    final totoalPages = blogsRepository.totalPages;
    print("Current Page : $_currentPage");
    print("Total Pages : $totoalPages");
    if (_currentPage > totoalPages) {
      _currentPage = totoalPages;
      return;
    }
    try {
      emit(state.copyWith(status: BlogsStatus.moreLoading));
      final moreBlogs =
          await blogsRepository.fetchBlogs(page: _currentPage, limit: _limit);
      emit(state.copyWith(
        status: BlogsStatus.loaded,
        blogs: List.of(state.blogs)..addAll(moreBlogs),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogsStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }

  Future<void> getBlogsByCategory(String category) async {
    emit(state.copyWith(status: BlogsStatus.loading));
    if (category == "All") {
      await getBlogs(allLimit: _currentPage * _limit);
      return;
    }
    try {
      final blogs = await blogsRepository.fetchBlogsByCategory(category);
      if (blogs == null) {
        emit(state.copyWith(status: BlogsStatus.error, blogs: []));
      } else {
        emit(state.copyWith(status: BlogsStatus.loaded, blogs: blogs));
      }
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          status: BlogsStatus.error,
          error: CustomError(message: e.message),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BlogsStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  Future<void> getBlogsBySearch(String query) async {
    emit(state.copyWith(status: BlogsStatus.loading));
    try {
      final blogs = await blogsRepository.fetchBlogsBySearch(query);
      if (blogs == null) {
        emit(state.copyWith(status: BlogsStatus.error, blogs: []));
      } else {
        emit(state.copyWith(status: BlogsStatus.loaded, blogs: blogs));
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: BlogsStatus.error,
          error: CustomError(message: e.toString()),
        ),
      );
    }
  }

  Future<void> refresh() async {
    emit(BlogsState.initial());
    await getBlogs();
  }
}
