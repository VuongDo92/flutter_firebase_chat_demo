import './env.dart';

class StagingEnv extends Env {
  EnvType environmentType = EnvType.STAGING;
  static StagingEnv value;

  @override
  String appName = "Flutter-Base";

  StagingEnv() {
    value = this;
  }
}
