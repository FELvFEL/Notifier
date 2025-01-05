import 'package:bloc/bloc.dart';
import 'package:notificator1/Cubit/requisiteState.dart';

import '../models/requisite.dart';
import '../requests/api.dart';

class RequisiteCubit extends Cubit<RequisiteState> {
  RequisiteCubit() : super(RequisiteLoadingState());

  Future<void> loadData() async {
    try {
      Map<String, dynamic> apiData = await getRequisites();
      Requisite requisiteData = Requisite.fromJson(apiData);
      emit(RequisiteLoadedState(data: requisiteData));
      return;
    } catch (e) {
      emit(RequisiteErrorState());
      return;
    }
  }
}
