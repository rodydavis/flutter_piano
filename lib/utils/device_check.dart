import 'dart:io';

bool get isMobileOS => Platform.isIOS || Platform.isAndroid;
bool get isDesktopOS => Platform.isWindows || Platform.isLinux || Platform.isMacOS;