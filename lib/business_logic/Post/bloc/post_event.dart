part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class InitialPostEvent extends PostEvent {}

class AddNewPost extends PostEvent {
  late final String body;
  late final String? image;
  AddNewPost({
    required this.body,
    required this.image,
  });
}


class GetPostByCityName extends PostEvent {
  late final List<CityId?> postscityId;
  late final int page;
  late final int countItemPerpage;
  late final String sortby;
  GetPostByCityName({
    required this.postscityId,
    required this.page,
    required this.countItemPerpage,
    required this.sortby,
  });
}

class GetAllPost extends PostEvent {
  late final int page;
  late final int countItemPerpage;
  GetAllPost({
    required this.page,
    required this.countItemPerpage,
  });
}
