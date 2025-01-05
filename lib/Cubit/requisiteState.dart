import '../models/requisite.dart';

abstract class RequisiteState {}

class RequisiteLoadingState extends RequisiteState {}

class RequisiteLoadedState extends RequisiteState {
  final Requisite data;
  RequisiteLoadedState({required this.data});
}

class RequisiteErrorState extends RequisiteState {}