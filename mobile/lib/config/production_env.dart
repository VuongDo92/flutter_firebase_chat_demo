import './env.dart';

class ProductionEnv extends Env {
  EnvType environmentType = EnvType.PRODUCTION;
  static ProductionEnv value;

  @override
  String appName = "Flutter-Base";

  ProductionEnv() {
    value = this;
  }
}
