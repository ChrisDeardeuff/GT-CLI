import 'package:args/args.dart';
import 'package:galactic_time_cli_converter/galactic_time_cli.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart galactic_time_cli_converter.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('galactic_time_cli_converter version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }
    // Handle the positional argument
    if (results.rest.isEmpty) {
      // No datetime provided, use current time
      String currentTime = GalacticTime.getGalacticTime();
      print('Current Galactic Time: $currentTime');
    } else {
      // Parse the provided datetime
      try {
        DateTime earthTime = DateTime.parse(results.rest[0]);
        String galacticTime = GalacticTime.convertToGalacticTime(earthTime);
        print('Galactic Time: $galacticTime');

        if (verbose) {
          print('[VERBOSE] Input time: ${earthTime.toString()}');
        }
      } on FormatException catch (_) {
        print('Error: Invalid datetime format. Use YYYY-MM-DD HH:mm:ss');
        printUsage(argParser);
      }
    }
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
