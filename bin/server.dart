import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:markdown/markdown.dart';
import 'package:mustache_template/mustache.dart';
import 'package:recase/recase.dart';

void main(List<String> args) async {
  final webBuildPath = 'build/web';

  // Handler for regular static files in build/web
  final webBuildHandler = createStaticHandler(
    webBuildPath,
    defaultDocument: 'index.html',
  );

  final router = Router();

  router.get('/health', (Request request) {
    return Response.ok('OK');
  });

  router.get('/', (Request request) async {
    final pageHtml = await _getMarketingHtml();
    return Response.ok(
      pageHtml,
      headers: {'content-type': 'text/html'},
    );
  });

  router.get('/web', (Request request) {
    return Response.movedPermanently('/web/');
  });

  router.mount('/web/', (Request request) async {
    Response response = await webBuildHandler(request);

    // Fallback for SPA Routing if file not found and doesn't look like static file
    if (response.statusCode == 404 && !request.url.path.contains('.')) {
      final indexHtml = File('$webBuildPath/index.html');
      if (await indexHtml.exists()) {
        return Response.ok(
          indexHtml.openRead(),
          headers: {'content-type': 'text/html'},
        );
      }
    }
    return response;
  });

  // Markdown content routes
  router.get('/<name>', (Request request, String name) async {
    final file = File('content/$name.md');
    if (!await file.exists()) {
      return Response.notFound('Page not found');
    }
    final markdownContent = await file.readAsString();
    final htmlContent = markdownToHtml(
      markdownContent,
      extensionSet: ExtensionSet.gitHubWeb,
    );

    // Create a title from the filename (e.g. "privacy" -> "Privacy")
    final title = name.titleCase;
    final pageHtml = await _getMarkdownHtml(title, htmlContent);

    return Response.ok(pageHtml, headers: {'content-type': 'text/html'});
  });

  // Serve the Flutter web app
  router.all('/<ignored|.*>', (Request request) async {
    final response = await webBuildHandler(request);

    // Fallback for SPA routing: if the file isn't found and doesn't look like a static asset,
    // serve index.html so the client-side router can take over.
    if (response.statusCode == 404 && !request.url.path.contains('.')) {
      final indexHtml = File('$webBuildPath/index.html');
      if (await indexHtml.exists()) {
        return Response.ok(
          indexHtml.openRead(),
          headers: {'Content-Type': 'text/html'},
        );
      }
    }

    return response;
  });

  // Setup the pipeline with logging and CORS headers
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders())
      .addHandler(router.call);

  // Use PORT from environment or default to 8080
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final ip = InternetAddress.anyIPv4;

  final server = await io.serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}

Middleware _corsHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
          'Access-Control-Allow-Headers':
              'Origin, Content-Type, Accept, Authorization',
          'Cross-Origin-Embedder-Policy': 'require-corp',
          'Cross-Origin-Opener-Policy': 'same-origin',
        },
      );
    };
  };
}

Future<String> _renderTemplate(String name, Map<String, dynamic> values) async {
  final file = File('templates/$name.mustache');
  if (!await file.exists()) {
    return 'Template not found: $name';
  }
  final source = await file.readAsString();
  final template = Template(source, htmlEscapeValues: false);
  return template.renderString(values);
}

Future<String> _getBaseLayout({
  required String title,
  required String content,
}) async {
  return await _renderTemplate('base', {
    'title': title,
    'content': content,
    'year': DateTime.now().year,
    // 'linkDiscord': linkDiscord,
    // 'linkGithubIssues': linkGithubIssues,
  });
}

Future<String> _getMarketingHtml() async {
  final content = await _renderTemplate('marketing', {
    'playStoreLink':
        'https://play.google.com/store/apps/details?id=com.appleeducate.flutter_piano&hl=en_US',
    'appStoreLink':
        'https://apps.apple.com/us/app/the-pocket-piano/id1453992672',
  });
  return await _getBaseLayout(title: 'Home', content: content);
}

Future<String> _getMarkdownHtml(String title, String htmlBody) async {
  final content = await _renderTemplate('markdown', {
    'markdownHtml': htmlBody,
  });
  return await _getBaseLayout(title: title, content: content);
}
