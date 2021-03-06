import 'package:central_borssa/data/model/Post/Cities.dart';
import 'package:central_borssa/data/model/Post/CompanyPost.dart';
import 'package:central_borssa/data/model/Post/CompanyInfo.dart' as companyinfo;
import 'package:equatable/equatable.dart';

abstract class CompanyState extends Equatable {
  const CompanyState();

  @override
  List<Object> get props => [];
}

class CompanyInitial extends CompanyState {}

class GetAllInformationLoading extends CompanyState {}

class GetAllInformationError extends CompanyState {}

class GetAllInformationLoaded extends CompanyState {
  late final Data data;
  GetAllInformationLoaded({
    required this.data,
  });
}

//Companies All
class CompanyNameIsLodaing extends CompanyState {}

class CompanyNameError extends CompanyState {}

class CompanyNameIsLoaded extends CompanyState {
  late final List<list> companies;
  CompanyNameIsLoaded({
    required this.companies,
  });
}

//Follow Company
class FollowIsLoading extends CompanyState {}

class FollowError extends CompanyState {}

class FollowIsLoaded extends CompanyState {
  late final bool status;
  FollowIsLoaded({
    required this.status,
  });
}

//UnFollow Company
class UnFollowIsLoading extends CompanyState {}

class UnFollowError extends CompanyState {}

class UnFollowIsLoaded extends CompanyState {
  late final bool status;
  UnFollowIsLoaded({
    required this.status,
  });
}

class EditPostLoading extends CompanyState {}

class EditPostError extends CompanyState {}

class EditPostLoaded extends CompanyState {
  final String status;
  EditPostLoaded({
    required this.status,
  });
}

//Delete Post

class DeletePostLoading extends CompanyState {}

class DeletePostError extends CompanyState {}

class DeletePostLoaded extends CompanyState {
  final String status;
  DeletePostLoaded({
    required this.status,
  });
}

//info
class GetCompanyInfoLoading extends CompanyState {}

class GetCompanyInfoError extends CompanyState {}

class GetCompanyInfoLoaded extends CompanyState {
  final companyinfo.Data data;
  GetCompanyInfoLoaded({
    required this.data,
  });
}
