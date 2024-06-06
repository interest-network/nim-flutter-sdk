// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
library alog;

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

enum AlogType {
  // 普通类型
  normal,
  // 接口类型
  api,
}

enum ALogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
}

class Alog {
  static final level = ALogLevel.verbose;

  ///  [level] 最低输出 log 等级
  ///  [path] 日志文件路径
  ///  [name] 日志文件名称
  static bool init(ALogLevel level, String path, String namePrefix) {
    js.context['console'].callMethod('log', [level, path, namePrefix]);
    return true;
  }

  // 日志打印参数规范
  //  [tag] tag 说明
  //  [AlogType]  0-普通log，1-api log
  //  [moduleName] 模块名称
  //  [content] 日志内容
  static void v(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('log', [tag, type.index, moduleName, 0, content]);
  }

  // debug 打印 参数同 verbose
  static void d(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('debug', [tag, type.index, moduleName, 0, content]);
  }

  // info 打印 参数同 verbose
  static void i(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('info', [tag, type.index, moduleName, 0, content]);
  }

  // warn 打印 参数同 verbose
  static void w(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('warning', [tag, type.index, moduleName, 0, content]);
  }

  // error 打印 参数同 verbose
  static void e(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('error', [tag, type.index, moduleName, 0, content]);
  }

  // test 打印 参数同 verbose
  static void test(
      {String tag = '',
      AlogType type = AlogType.normal,
      String moduleName = '',
      String content = ''}) {
    js.context['console']
        .callMethod('log', [tag, type.index, moduleName, 0, content]);
  }

  // 将缓存信息同步写入目标日志
  static void flushSync() {
    //
  }

  // 将缓存信息异步写入目标日志
  static void flushAsync() {
    //
  }
}
