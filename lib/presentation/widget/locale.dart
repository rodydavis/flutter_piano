import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension LangUtils on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
}
