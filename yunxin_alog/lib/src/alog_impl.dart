// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of alog;

const libyx_alog = 'libyx_alog.so';
//../../alog_macos/macos/Frameworks/
const libMacOSyx_alog = 'libne-alog.dylib';
// const libWindwosyx_alog = '../../alog_windows/windows/bin/ne-alog.dll';
const libWindwosyx_alog =  r'ne-alog.dll';


/// 获取[DynamicLibrary]的runTime.
/// if so Failed to load dynamic library (dlopen failed: library \"libalog1
/// .so\" not found)
final DynamicLibrary dylib = () {
  if (Platform.isAndroid) {
    return DynamicLibrary.open(libyx_alog);
  }
  if (Platform.isMacOS) {
    return DynamicLibrary.open(libMacOSyx_alog);
  }
 if (Platform.isWindows) {
    return DynamicLibrary.open(libWindwosyx_alog);
  }
  return DynamicLibrary.process();
}();

/**
 * /// FFI signature of the hello_world C function
    typedef hello_world_func = ffi.Void Function();

    /// Dart type definition for calling the C foreign function
    typedef HelloWorld = void Function();

    /// Look up the C function 'hello_world'
    final HelloWorld hello = dylib
    .lookup<ffi.NativeFunction<hello_world_func>>('hello_world')
    .asFunction();
    // Call the function
    hello();
 */

/// FFI signature of the alogger_init C function
/// Map to the corresponding C interface
/// void alogger_init(int level, const char* path, const char* _name_prefix);
typedef ALoggerInitNative = Int32 Function(
    Int32, Pointer<Utf8>, Pointer<Utf8>);

/// Dart type definition for calling the C foreign function
typedef AloggerInit = int Function(int, Pointer<Utf8>, Pointer<Utf8>);

/// ALog 初始化
/// 使用 每次使用前调用 alogger_init 接口完成初始化，之后即可按目标日志等级调用 输出接口。
/// [AloggerInit] dart -> C [ALoggerInitNative],
///
///  Call the function : aloggerInit()
final aloggerInit =
    dylib.lookupFunction<ALoggerInitNative, AloggerInit>(alogger_init);

/// FFI signature of the alogger_flushSync C function
/// Map to the corresponding C interface
/// int alogger_flushSync();
typedef ALoggerFlushSyncNative = Int32 Function();

/// Dart type definition for calling the C foreign function
typedef AloggerFlushSync = int Function();

/// 将缓存信息同步写入目标日志
/// [AloggerFlushSync] dart -> C [ALoggerFlushSyncNative],
///
///  Call the function : aloggerFlushSync()
Function? aloggerFlushSync;

/// FFI signature of the alogger_flushAsync C function
/// Map to the corresponding C interface
/// int alogger_flushAsync();
typedef ALoggerFlushAsyncNative = Int32 Function();

/// Dart type definition for calling the C foreign function
typedef AloggerFlushAsync = int Function();

/// 将缓存信息异步写入目标日志
/// [AloggerFlushAsync] dart -> C [ALoggerFlushAsyncNative],
///
///  Call the function : aloggerFlushAsync()
Function? aloggerFlushAsync;

/// FFI signature of the alogger_init C function
///  [tag] tag 说明
///  [type] 0-普通log，1-api log
///  [moduleName] 模块名称
///  [line] 行数，不支持传 0 即可
///  [content] 日志内容
///
typedef ALoggerFunc = Int32 Function(
    Pointer<Utf8>, Int32, Pointer<Utf8>, Int32, Int32, Pointer<Utf8>);

/// Dart type definition for calling the C foreign function
typedef AloggerDartFunc = int Function(
    Pointer<Utf8>, int, Pointer<Utf8>, int, int, Pointer<Utf8>);

/// ALog debug level
/// 使用 每次使用前调用 alogger_init 接口完成初始化，之后即可按目标日志等级调用 输出接口。
/// [AloggerDartFunc] dart -> C [ALoggerFunc],
///
/// [fuc] C++ methmod name.
Function aloggerCallC(String fuc) =>
    dylib.lookupFunction<ALoggerFunc, AloggerDartFunc>(fuc);

const alogger_flushSync = 'alogger_flushSync';
const alogger_flushAsync = 'alogger_flushAsync';
const alogger_init = 'alogger_init';
const alogger_verbose = 'alogger_verbose';
const alogger_info = 'alogger_info';
const alogger_debug = 'alogger_debug';
const alogger_test = 'alogger_test';
const alogger_warn = 'alogger_warn';
const alogger_error = 'alogger_error';
const alogger_release = 'alogger_release';

const alogger_pid = 'alogger_pid';

///Call dart function [aloggerCallC]
Function? aloggerVerbose;
Function? aloggerInfo;
Function? aloggerDebug;
Function? aloggerTest;
Function? aloggerWarn;
Function? aloggerError;

/// release
int Function()? aloggerRelease;

/// aloggerPid
int Function()? aloggerPid;

int? _currentAlogTid;
int get currentAlogTid => _currentAlogTid ?? 0;

class AlogImpl implements AlogAbs {
  factory AlogImpl() => _getInstance();

  static AlogImpl get instance => _getInstance();

  static AlogImpl _instance = AlogImpl._internal();

  AlogImpl._internal();

  static AlogImpl _getInstance() => _instance;

  bool _isInit = false;

  /// C function: [aloggerInit]
  @override
  bool init(int level, String path, String namePrefix) {
    if (_isInit) return true;
    try {
      var result =
          aloggerInit(level, path.toNativeUtf8(), namePrefix.toNativeUtf8());
      _isInit = (result == 0 || result == -1);
      aloggerVerbose = aloggerCallC(alogger_verbose);
      aloggerInfo = aloggerCallC(alogger_info);
      aloggerDebug = aloggerCallC(alogger_debug);
      aloggerTest = aloggerCallC(alogger_test);
      aloggerWarn = aloggerCallC(alogger_warn);
      aloggerError = aloggerCallC(alogger_error);
      aloggerFlushSync =
          dylib.lookupFunction<ALoggerFlushSyncNative, AloggerFlushSync>(
              alogger_flushSync);
      aloggerFlushAsync =
          dylib.lookupFunction<ALoggerFlushAsyncNative, AloggerFlushAsync>(
              alogger_flushAsync);
      aloggerPid = dylib
          .lookup<NativeFunction<Int32 Function()>>(alogger_pid)
          .asFunction();
      // aloggerRelease = dylib
      //     .lookup<NativeFunction<Int32 Function()>>(alogger_release)
      //     .asFunction();
      ///Isolate.current.debugName is main.It's not what I want.
      _currentAlogTid = aloggerPid!();
    } catch (e) {
      print("e : $e");
      _isInit = false;
    }
    return _isInit;
  }

  @override
  void verbose(
      String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerVerbose != null) {
      aloggerVerbose!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void info(String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerInfo != null) {
      aloggerInfo!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void warn(String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerWarn != null) {
      aloggerWarn!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void test(String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerTest != null) {
      aloggerTest!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void debug(
      String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerDebug != null) {
      aloggerDebug!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void error(
      String tag, int type, String moduleName, int line, String content) {
    if (_isInit && aloggerError != null) {
      aloggerError!(tag.toNativeUtf8(), type, moduleName.toNativeUtf8(), line,
          currentAlogTid, content.toNativeUtf8());
    }
  }

  @override
  void flushAsync() {
    if (_isInit && aloggerFlushAsync != null) {
      aloggerFlushAsync!();
    }
  }

  @override
  void flushSync() {
    if (_isInit && aloggerFlushSync != null) {
      aloggerFlushSync!();
    }
  }

  @override
  int release() {
    return aloggerRelease!();
  }

  @override
  int currentTid() {
    return currentAlogTid;
  }
}
