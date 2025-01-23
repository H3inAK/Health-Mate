import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:healthmate/utils/custom_error.dart';

import '../../repositories/blogs_repository.dart';

part 'blog_categories_state.dart';

class BlogCategoriesCubit extends Cubit<BlogCategoriesState> {
  BlogCategoriesCubit(this.blogsRepository)
      : super(BlogCategoriesState.initial());

  final BlogsRepository blogsRepository;

  Future<void> getBlogCategories() async {
    emit(state.copyWith(status: BlogCategoriesStatus.loading));
    try {
      final blogCategories = await blogsRepository.fetchCategories();
      emit(state.copyWith(
        status: BlogCategoriesStatus.loaded,
        blogCategories: ['All', ...blogCategories],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BlogCategoriesStatus.error,
        error: CustomError(message: e.toString()),
      ));
    }
  }
}
