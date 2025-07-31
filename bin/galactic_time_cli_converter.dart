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
    )
    ..addOption(
      'direction',
      abbr: 'd',
      allowed: ['to-galactic', 'from-galactic'],
      defaultsTo: 'to-galactic',
      help: 'Conversion direction: to-galactic or from-galactic',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart galactic_time_cli_converter.dart <flags> [time]');
  print('For to-galactic: Use YYYY-MM-DD HH:mm:ss format');
  print('For from-galactic: Use numerical galactic time value');
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

    String direction = results['direction'];

    // Handle the conversion based on direction
    if (results.rest.isEmpty) {
      // No time provided, use current time
      if (direction == 'to-galactic') {
        String currentTime = GalacticTime.getGalacticTime();
        print('Current Galactic Time: $currentTime');
      } else {
        print('Error: Galactic time value is required for conversion to Earth time');
        printUsage(argParser);
      }
    } else {
      try {
        if (direction == 'to-galactic') {
          // Convert Earth time to Galactic time
          DateTime earthTime = DateTime.parse(results.rest[0]);
          String galacticTime = GalacticTime.convertToGalacticTime(earthTime);
          print('Galactic Time: $galacticTime');

          if (verbose) {
            print('[VERBOSE] Input Earth time: ${earthTime.toString()}');
          }
        } else {
          // Convert Galactic time to Earth time
          String galacticTime = results.rest[0];
          DateTime earthTime = GalacticTime.convertFromGalacticTime(galacticTime);
          print('Earth Time: ${earthTime.toUtc().toString()}');

          if (verbose) {
            print('[VERBOSE] Input Galactic time: $galacticTime');
          }
        }
      } on FormatException catch (_) {
        if (direction == 'to-galactic') {
          print('Error: Invalid datetime format. Use YYYY-MM-DD HH:mm:ss');
        } else {
          print('Error: Invalid galactic time format. Use numerical value');
        }
        printUsage(argParser);
      }
    }
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
  }
}