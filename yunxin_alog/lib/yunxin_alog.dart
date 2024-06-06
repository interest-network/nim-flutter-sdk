// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// library alog;
library alog;


export 'src/alog_web.dart'
    if (dart.library.io) 'src/alog_native.dart' // dart:io implementation
    if (dart.library.html) 'src/alog_web.dart'; // dart:html implementation
  
