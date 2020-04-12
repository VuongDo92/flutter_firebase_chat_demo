import './env.dart';

class DevelopmentEnv extends Env {
  EnvType environmentType = EnvType.DEVELOPMENT;
  static DevelopmentEnv value;

  @override
  String appName = "Flutter-Base";

  DevelopmentEnv() {
    value = this;
  }
}
