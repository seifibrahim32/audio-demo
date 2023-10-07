import 'package:equatable/equatable.dart';

class LanguageChangeState extends Equatable {
  final String lang;

  const LanguageChangeState({required this.lang});

  @override
  List<Object?> get props => [lang];

}