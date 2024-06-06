// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of alog;

abstract class AlogAbs {
  static final AlogAbs _instance = AlogImpl.instance;

  /// 获取Alog实例
  static AlogAbs get instance => _instance;

  ///  [level] 最低输出 log 等级
  ///  [path] 日志文件路径
  ///  [name] 日志文件名称
  bool init(int level, String path, String namePrefix);

  /// verbose 打印
  ///  [tag] tag 说明
  ///  [type] 0-普通log，1-api log
  ///  [moduleName] 模块名称
  ///  [line] 行数，不支持传 0 即可
  ///  [content] 日志内容
  void verbose(
      String tag, int type, String moduleName, int line, String content);

  /// debug 打印 参数同 verbose
  void debug(String tag, int type, String moduleName, int line, String content);

  /// info 打印 参数同 verbose
  void info(String tag, int type, String moduleName, int line, String content);

  /// warn 打印 参数同 verbose
  void warn(String tag, int type, String moduleName, int line, String content);

  /// error 打印 参数同 verbose
  void error(String tag, int type, String moduleName, int line, String content);

  /// test 打印 参数同 verbose，底层使用 aloggerinfo
  void test(String tag, int type, String moduleName, int line, String content);

  /// 将缓存信息同步写入目标日志
  void flushSync();

  /// 将缓存信息异步写入目标日志
  void flushAsync();

  /// 销毁对应日志，如果再次使用需要调用 init
  int release();

  /// 获取当前线程，不需要初始化
  int currentTid();
}

/// [api]	应用于组件，组件对外暴露的接口需要在调用时进行日志输出输出时携带 [api] 标记，输出接口名称以及相应入参，其中注意敏感信息规避。非对外接口或应用不带此标记
enum AlogType {
  /// 普通类型
  normal,

  /// 接口类型
  api,
}

enum ALogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

/// 打印日志调用接口
class Alog {
  ///  [level] 最低输出 log 等级.[ALogLevel]
  ///  [path] 日志文件路径，必须输入正确，否则会崩溃
  ///  [name] 日志文件名称
  static bool init(ALogLevel level, String path, String namePrefix) {
    return AlogAbs.instance.init(level.index, path, namePrefix);
  }

  /// verbose 打印
  ///  [tag] tag 说明
  ///  [AlogType]  0-普通log，1-api log
  ///  [moduleName] 模块名称
  ///  [content] 日志内容
  ///
  static void v(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.verbose(tag, type.index, moduleName, 0, content);
  }

  /// debug 打印 参数同 verbose
  static void d(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.debug(tag, type.index, moduleName, 0, content);
  }

  /// info 打印 参数同 verbose
  static void i(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.info(tag, type.index, moduleName, 0, content);
  }

  /// warn 打印 参数同 verbose
  static void w(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.warn(tag, type.index, moduleName, 0, content);
  }

  /// error 打印 参数同 verbose
  static void e(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.error(tag, type.index, moduleName, 0, content);
  }

  /// test 打印 参数同 verbose
  static void test(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    AlogAbs.instance.test(tag, type.index, moduleName, 0, content);
  }

  /// 将缓存信息同步写入目标日志
  static void flushSync() {
    AlogAbs.instance.flushSync();
  }

  /// 将缓存信息异步写入目标日志
  static void flushAsync() {
    AlogAbs.instance.flushAsync();
  }
}
