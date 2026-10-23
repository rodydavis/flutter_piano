// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import 'package:googleapis/androidpublisher/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

void main(List<String> rawArgs) async {
  final parser = ArgParser()
    ..addOption(
      'aab',
      abbr: 'a',
      defaultsTo: 'build/app/outputs/bundle/release/app-release.aab',
      help: 'Path to the Android App Bundle (.aab)',
    )
    ..addOption(
      'service-account',
      abbr: 's',
      defaultsTo: 'android/app/google_play.json',
      help: 'Path to the Google Play service account JSON key file',
    )
    ..addOption(
      'package-name',
      abbr: 'p',
      defaultsTo: 'com.appleeducate.flutter_piano',
      help: 'Application package name',
    )
    ..addOption(
      'track',
      abbr: 't',
      defaultsTo: 'beta',
      help: 'Target track (e.g. internal, alpha, beta, production)',
    )
    ..addOption(
      'status',
      defaultsTo: 'completed',
      allowed: ['completed', 'draft', 'inProgress', 'halted'],
      help: 'Release status',
    )
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show help');

  final args = parser.parse(rawArgs);
  if (args['help'] == true) {
    print('Usage: dart scripts/upload_play_store.dart [options]');
    print(parser.usage);
    exit(0);
  }

  final aabPath = args['aab'] as String;
  final aabFile = File(aabPath);
  if (!await aabFile.exists()) {
    print('Error: AAB file not found at $aabPath');
    print('Run "flutter build appbundle --release" first.');
    exit(1);
  }

  final saPath = args['service-account'] as String;
  final saFile = File(saPath);
  String? saJsonString;

  if (await saFile.exists()) {
    saJsonString = await saFile.readAsString();
  } else if (Platform.environment['GOOGLE_PLAY_SERVICE_ACCOUNT_JSON'] != null) {
    saJsonString = Platform.environment['GOOGLE_PLAY_SERVICE_ACCOUNT_JSON'];
  } else {
    print(
      'Error: Service account file not found at $saPath and GOOGLE_PLAY_SERVICE_ACCOUNT_JSON is not set.',
    );
    exit(1);
  }

  final packageName = args['package-name'] as String;
  final trackName = args['track'] as String;
  final releaseStatus = args['status'] as String;

  print('====================================================');
  print('Google Play Developer API Deployer');
  print('====================================================');
  print('Package: $packageName');
  print('AAB:     $aabPath (${(await aabFile.length()) / (1024 * 1024)} MB)');
  print('Track:   $trackName');
  print('Status:  $releaseStatus');
  print('====================================================\n');

  final credentials = ServiceAccountCredentials.fromJson(
    jsonDecode(saJsonString!) as Map<String, dynamic>,
  );
  final client = await clientViaServiceAccount(
    credentials,
    [AndroidPublisherApi.androidpublisherScope],
  );

  try {
    final api = AndroidPublisherApi(client);

    print('Step 1/4: Initializing app edit session...');
    final edit = await api.edits.insert(AppEdit(), packageName);
    final editId = edit.id!;
    print('✓ Edit session active (ID: $editId)');

    print('\nStep 2/4: Uploading App Bundle ($aabPath)...');
    final aabStream = aabFile.openRead();
    final aabLength = await aabFile.length();
    final bundle = await api.edits.bundles.upload(
      packageName,
      editId,
      uploadMedia: Media(aabStream, aabLength),
    );
    final versionCode = bundle.versionCode;
    print('✓ App bundle uploaded successfully! Version Code: $versionCode');

    print('\nStep 3/4: Updating track "$trackName" with version $versionCode...');
    final release = TrackRelease(
      name: 'Release v$versionCode',
      versionCodes: [versionCode.toString()],
      status: releaseStatus,
    );
    final track = Track(
      track: trackName,
      releases: [release],
    );

    await api.edits.tracks.update(
      track,
      packageName,
      editId,
      trackName,
    );
    print('✓ Track "$trackName" configured.');

    print('\nStep 4/4: Committing release changes...');
    try {
      await api.edits.commit(packageName, editId);
    } catch (commitErr) {
      print(
        'Standard commit failed ($commitErr); retrying with changesNotSentForReview=true...',
      );
      await api.edits.commit(
        packageName,
        editId,
        changesNotSentForReview: true,
      );
    }
    print('✓ Release committed successfully!');
    print(
      '\n🎉 Successfully deployed version $versionCode to Google Play track "$trackName"!',
    );
  } catch (e) {
    final msg = e.toString();
    if (msg.contains('has already been used')) {
      print(
        '\n⚠️ Version code already exists on Google Play ($msg); skipping duplicate upload.',
      );
      exit(0);
    }
    print('\n❌ Google Play deployment failed: $e');
    exit(1);
  } finally {
    client.close();
  }
}
