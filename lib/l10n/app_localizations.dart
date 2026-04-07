import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'The Pocket Piano'**
  String get title;

  /// No description provided for @sustain.
  ///
  /// In en, this message translates to:
  /// **'Sustain'**
  String get sustain;

  /// No description provided for @themeBrightness.
  ///
  /// In en, this message translates to:
  /// **'Theme Brightness'**
  String get themeBrightness;

  /// No description provided for @themeBrightnessLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeBrightnessLight;

  /// No description provided for @themeBrightnessSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeBrightnessSystem;

  /// No description provided for @themeBrightnessDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeBrightnessDark;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @keySettings.
  ///
  /// In en, this message translates to:
  /// **'Key Settings'**
  String get keySettings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @keyWidth.
  ///
  /// In en, this message translates to:
  /// **'Key Width'**
  String get keyWidth;

  /// No description provided for @invertKeys.
  ///
  /// In en, this message translates to:
  /// **'Invert Keys'**
  String get invertKeys;

  /// No description provided for @colorRole.
  ///
  /// In en, this message translates to:
  /// **'Color Role'**
  String get colorRole;

  /// No description provided for @colorRolePrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get colorRolePrimary;

  /// No description provided for @colorRolePrimaryContainer.
  ///
  /// In en, this message translates to:
  /// **'Primary Container'**
  String get colorRolePrimaryContainer;

  /// No description provided for @colorRoleSecondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get colorRoleSecondary;

  /// No description provided for @colorRoleSecondaryContainer.
  ///
  /// In en, this message translates to:
  /// **'Secondary Container'**
  String get colorRoleSecondaryContainer;

  /// No description provided for @colorRoleTertiary.
  ///
  /// In en, this message translates to:
  /// **'Tertiary'**
  String get colorRoleTertiary;

  /// No description provided for @colorRoleTertiaryContainer.
  ///
  /// In en, this message translates to:
  /// **'Tertiary Container'**
  String get colorRoleTertiaryContainer;

  /// No description provided for @colorRoleSurface.
  ///
  /// In en, this message translates to:
  /// **'Surface'**
  String get colorRoleSurface;

  /// No description provided for @colorRoleInverseSurface.
  ///
  /// In en, this message translates to:
  /// **'Inverse Surface'**
  String get colorRoleInverseSurface;

  /// No description provided for @colorRoleMonoChrome.
  ///
  /// In en, this message translates to:
  /// **'Mono Chrome'**
  String get colorRoleMonoChrome;

  /// No description provided for @keyLabels.
  ///
  /// In en, this message translates to:
  /// **'Key Labels'**
  String get keyLabels;

  /// No description provided for @hapticFeedback.
  ///
  /// In en, this message translates to:
  /// **'Haptic Feedback'**
  String get hapticFeedback;

  /// No description provided for @keyLabelsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get keyLabelsNone;

  /// No description provided for @keyLabelsSharps.
  ///
  /// In en, this message translates to:
  /// **'Sharps'**
  String get keyLabelsSharps;

  /// No description provided for @keyLabelsFlats.
  ///
  /// In en, this message translates to:
  /// **'Flats'**
  String get keyLabelsFlats;

  /// No description provided for @keyLabelsBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get keyLabelsBoth;

  /// No description provided for @keyLabelsMidi.
  ///
  /// In en, this message translates to:
  /// **'Midi'**
  String get keyLabelsMidi;

  /// No description provided for @splitKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Split Keyboard'**
  String get splitKeyboard;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @disableScroll.
  ///
  /// In en, this message translates to:
  /// **'Disable Scroll'**
  String get disableScroll;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageDe.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageDe;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageEs;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFr;

  /// No description provided for @languageJa.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get languageJa;

  /// No description provided for @languageKo.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get languageKo;

  /// No description provided for @languageZh.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get languageZh;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRu;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @showLicenses.
  ///
  /// In en, this message translates to:
  /// **'Show Licenses'**
  String get showLicenses;

  /// No description provided for @webVersion.
  ///
  /// In en, this message translates to:
  /// **'Web Version'**
  String get webVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'ja',
        'ko',
        'ru',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
