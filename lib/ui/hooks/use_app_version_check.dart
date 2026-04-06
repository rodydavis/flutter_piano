import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../src/services/injection.dart';
import '../../src/version.dart';

void useAppVersionCheck(BuildContext context) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = getIt<SharedPreferences>();
      const updateKey = 'app_check';
      final lastCheck = prefs.getString(updateKey);
      const appVersion = packageVersion;
      if (lastCheck == null || lastCheck != appVersion) {
        if (context.mounted) {
          context.push('/whats-new');
          await prefs.setString(updateKey, appVersion);
        }
      }
    });
    return null;
  }, []);
}
