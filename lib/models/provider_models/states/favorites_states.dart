import 'package:equatable/equatable.dart';

class FavoritesStates extends Equatable {
  final bool isLiked;

  const FavoritesStates({required this.isLiked});

  @override
  List<Object?> get props => [isLiked];
}

class LikedChanged extends FavoritesStates{

  const LikedChanged({required super.isLiked});
  @override
  List<Object?> get props => [isLiked];

}
