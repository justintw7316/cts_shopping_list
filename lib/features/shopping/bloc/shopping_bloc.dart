import 'package:bloc/bloc.dart';

import 'shopping_state.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  ShoppingCubit(): super(ShoppingState.initial());

  void toggleItem(String itemId) {
    final nextSelected = Set<String>.from(state.selectedIds);
    if (nextSelected.contains(itemId)) {
      nextSelected.remove(itemId);
    } else {
      nextSelected.add(itemId);
    }

    emit(state.copyWith(selectedIds: nextSelected));
  }
}
