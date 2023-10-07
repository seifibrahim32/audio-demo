
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itargs_task/models/likes/likes_model.dart';
import 'package:itargs_task/models/provider_models/states/favorites_states.dart';

class FavoritesCubit extends Cubit<FavoritesStates>{

  List<LikesModel> likesModel = [
    LikesModel("Seif", false),
    LikesModel("Ahmed", true),
    LikesModel("Mohamed", false),
  ];

  FavoritesCubit(super.initialState);


  changeLike(int index, bool isLiked){
    likesModel[index].isLiked = !isLiked;
    emit(LikedChanged(isLiked: likesModel[index].isLiked!));
  }

}