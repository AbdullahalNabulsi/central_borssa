part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostInitial extends PostState {}

class PostsLoadingError extends PostState {}

class PostsLoadedSuccess extends PostState {
  late final PostGet posts;
  PostsLoadedSuccess({
    required this.posts,
  });
}

//Get Post By City Name Start

class GetPostByCityNameLoading extends PostState {}

class GetPostByCityNameError extends PostState {}

class GetPostByCityNameLoaded extends PostState {
   late final PostGet posts;
  GetPostByCityNameLoaded({
    required this.posts,
  });
}

//Get Post By City Name End

class PostLoadingInProgress extends PostState {}

class AddPostSuccess extends PostState {}

class EditPostSuccess extends PostState {}

class DeletePostSuccess extends PostState {}

class PostError extends PostState {}

class PostInProgress extends PostState {}