
import 'package:equatable/equatable.dart';

abstract class BrightnessStates extends Equatable{

  final bool isDark;

  const BrightnessStates({required this.isDark});

  @override
  List<Object?> get props => [isDark];
}

class LightState extends BrightnessStates{

  const LightState({required bool isDark}) : super(isDark: isDark);

  @override
  List<Object?> get props => [isDark];
}

class DarkState extends BrightnessStates{

  const DarkState({required bool isDark}) : super(isDark: isDark);

  @override
  List<Object?> get props => [isDark];
}