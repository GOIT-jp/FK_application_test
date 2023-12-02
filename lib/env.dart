import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: 'Scripts/env/.env')
abstract class Env {
  //stripeシークレットAPI
  @EnviedField(varName: 'PASSWORD_1')
  static const String pass1 = _Env.pass1;

  @EnviedField(varName: 'PASSWORD_2')
  static const String pass2 = _Env.pass2;

  @EnviedField(varName: 'PASSWORD_3')
  static const String pass3 = _Env.pass3;

  @EnviedField(varName: 'PASSWORD_4')
  static const String pass4 = _Env.pass4;
}
